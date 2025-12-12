#!/usr/bin/env python3
"""
Resume PDF Generator
Generates a PDF resume from resume.yaml using LaTeX templates
"""

import argparse
import subprocess
import sys
from pathlib import Path

import yaml
from jinja2 import Environment, FileSystemLoader


class ResumeGenerator:
    """Generate PDF resume from YAML data and LaTeX templates"""

    def __init__(self, project_root: Path = None):
        """
        Initialize the resume generator

        Args:
            project_root: Root directory of the project (defaults to script location)
        """
        self.project_root = project_root or Path(__file__).parent.parent
        self.templates_dir = self.project_root / "templates"
        self.output_dir = self.project_root / "output"

        # Ensure output directory exists
        self.output_dir.mkdir(exist_ok=True)

        # Setup Jinja2 environment
        self.jinja_env = Environment(
            loader=FileSystemLoader(str(self.templates_dir)),
            block_start_string="\\BLOCK{",
            block_end_string="}",
            variable_start_string="\\VAR{",
            variable_end_string="}",
            comment_start_string="\\#{",
            comment_end_string="}",
            line_statement_prefix="%%",
            line_comment_prefix="%#",
            trim_blocks=True,
            lstrip_blocks=True,
            autoescape=False,
        )

        # Add LaTeX escape filter
        self.jinja_env.filters["escape_latex"] = self.escape_latex

    @staticmethod
    def convert_markdown_to_latex(text):
        """
        Convert markdown-style formatting to LaTeX commands

        Supports:
        - *text* or **text** -> \textbf{text} (bold)
        - _text_ -> \textit{text} (italic)
        - `text` -> \texttt{text} (code/monospace)

        Args:
            text: String with markdown formatting

        Returns:
            String with LaTeX formatting using placeholders
        """
        if not isinstance(text, str):
            return text

        import re

        # Use placeholders to protect LaTeX commands from being escaped
        # Convert **bold** or *bold* to placeholder
        text = re.sub(r"\*\*(.+?)\*\*", r"<<<TEXTBFSTART>>>\1<<<TEXTBFEND>>>", text)
        text = re.sub(r"\*(.+?)\*", r"<<<TEXTBFSTART>>>\1<<<TEXTBFEND>>>", text)

        # Convert _italic_ to placeholder
        text = re.sub(r"_(.+?)_", r"<<<TEXTITSTART>>>\1<<<TEXTITEND>>>", text)

        # Convert `code` to placeholder
        text = re.sub(r"`(.+?)`", r"<<<TEXTTTSTART>>>\1<<<TEXTTTEND>>>", text)

        return text

    @staticmethod
    def escape_latex(text, preserve_commands=False):
        """
        Escape special LaTeX characters in text

        Args:
            text: String to escape
            preserve_commands: If True, preserve LaTeX commands from markdown

        Returns:
            Escaped string safe for LaTeX
        """
        if not isinstance(text, str):
            return text

        # If preserving commands, protect our placeholders first
        if preserve_commands:
            # Don't escape underscores and braces inside our placeholders
            # We'll handle this differently
            pass

        # Escape special characters (but not backslashes in our placeholders)
        replacements = {
            "&": r"\&",
            "%": r"\%",
            "$": r"\$",
            "#": r"\#",
            "~": r"\textasciitilde{}",
            "^": r"\textasciicircum{}",
        }

        # Only escape _ and {} if not preserving commands
        if not preserve_commands:
            replacements["_"] = r"\_"
            replacements["{"] = r"\{"
            replacements["}"] = r"\}"

        for char, replacement in replacements.items():
            text = text.replace(char, replacement)

        # Convert placeholders to actual LaTeX commands
        if preserve_commands:
            text = text.replace("<<<TEXTBFSTART>>>", r"\textbf{")
            text = text.replace("<<<TEXTBFEND>>>", "}")
            text = text.replace("<<<TEXTITSTART>>>", r"\textit{")
            text = text.replace("<<<TEXTITEND>>>", "}")
            text = text.replace("<<<TEXTTTSTART>>>", r"\texttt{")
            text = text.replace("<<<TEXTTTEND>>>", "}")

        return text

    def load_resume_data(self, source: Path) -> dict:
        """
        Load resume data from directory of YAML files or single YAML file

        Args:
            source: Path to directory containing YAML files or single YAML file

        Returns:
            Dictionary containing resume data
        """
        if source.is_dir():
            return self._load_from_directory(source)
        else:
            return self._load_from_file(source)

    def _load_from_directory(self, data_dir: Path) -> dict:
        """
        Load resume data from directory of YAML files

        Args:
            data_dir: Directory containing section YAML files

        Returns:
            Dictionary containing resume data from all sections
        """
        data = {}
        sections = [
            "personal",
            "config",
            "experience",
            "projects",
            "education",
            "skills",
            "research",
        ]

        for section in sections:
            section_file = data_dir / f"{section}.yaml"
            if section_file.exists():
                with open(section_file, "r", encoding="utf-8") as f:
                    section_data = yaml.safe_load(f)
                    data[section] = section_data

        return data

    def _load_from_file(self, yaml_file: Path) -> dict:
        """
        Load resume data from single YAML file (backward compatible)

        Args:
            yaml_file: Path to the YAML file

        Returns:
            Dictionary containing resume data
        """
        with open(yaml_file, "r", encoding="utf-8") as f:
            data = yaml.safe_load(f)
        return data

    def render_template(self, template_name: str, data: dict) -> str:
        """
        Render LaTeX template with resume data

        Args:
            template_name: Name of the template file
            data: Resume data dictionary

        Returns:
            Rendered LaTeX content
        """
        # Recursively escape LaTeX special characters in all string values
        escaped_data = self._escape_data(data)
        template = self.jinja_env.get_template(template_name)
        return template.render(**escaped_data)

    def _escape_data(self, data):
        """
        Recursively convert markdown and escape LaTeX special characters in data structure

        Args:
            data: Data structure (dict, list, or primitive)

        Returns:
            Data structure with markdown converted and LaTeX-escaped strings
        """
        if isinstance(data, dict):
            return {key: self._escape_data(value) for key, value in data.items()}
        elif isinstance(data, list):
            return [self._escape_data(item) for item in data]
        elif isinstance(data, str):
            # First convert markdown to LaTeX (creates placeholders)
            text = self.convert_markdown_to_latex(data)
            # Then escape special chars while preserving our placeholders
            return self.escape_latex(text, preserve_commands=True)
        else:
            return data

    def compile_latex(self, tex_content: str, output_name: str = "resume") -> bool:
        """
        Compile LaTeX to PDF using Tectonic

        Args:
            tex_content: LaTeX source content
            output_name: Name for output files (without extension)

        Returns:
            True if compilation succeeded, False otherwise
        """
        tex_file = self.output_dir / f"{output_name}.tex"
        pdf_file = self.output_dir / f"{output_name}.pdf"

        # Symlinks to create temporarily
        cls_symlink = self.output_dir / "awesome-cv.cls"
        fonts_symlink = self.output_dir / "fonts"

        # Write LaTeX content to file
        with open(tex_file, "w", encoding="utf-8") as f:
            f.write(tex_content)

        print(f"# LaTeX file written to: {tex_file}")

        try:
            # Create temporary symlinks to class file and fonts
            if not cls_symlink.exists():
                cls_symlink.symlink_to(self.project_root / "assets/awesome-cv.cls")
            if not fonts_symlink.exists():
                fonts_symlink.symlink_to(self.project_root / "assets/fonts")

            # Compile with Tectonic
            print("# Compiling PDF with Tectonic...")
            result = subprocess.run(
                ["tectonic", str(tex_file)],
                cwd=str(self.output_dir),
                capture_output=True,
                text=True,
                check=True,
            )

            if result.stdout:
                print(result.stdout)

            print(f"# PDF generated successfully: {pdf_file}")
            return True

        except subprocess.CalledProcessError as e:
            print(f"# Error compiling LaTeX:\n{e.stderr}", file=sys.stderr)
            return False
        except FileNotFoundError:
            print(
                "# Tectonic not found. Install from: https://tectonic-typesetting.github.io/en-US/install.html",
                file=sys.stderr,
            )
            return False
        finally:
            # Clean up symlinks after compilation
            if cls_symlink.is_symlink():
                cls_symlink.unlink()
            if fonts_symlink.is_symlink():
                fonts_symlink.unlink()

    def generate(
        self,
        yaml_file: Path,
        template_name: str = "awesome-cv.tex",
        output_name: str = "resume",
    ) -> bool:
        """
        Generate PDF resume from YAML file

        Args:
            yaml_file: Path to resume YAML file
            template_name: Name of the LaTeX template to use
            output_name: Name for output files

        Returns:
            True if generation succeeded, False otherwise
        """
        print(f"# Generating resume from {yaml_file}")

        # Load resume data
        try:
            data = self.load_resume_data(yaml_file)
            print("# Loaded resume data")
        except Exception as e:
            print(f"# Error loading YAML: {e}", file=sys.stderr)
            return False

        # Render template
        try:
            tex_content = self.render_template(template_name, data)
            print("# Rendered template: {template_name}")
        except Exception as e:
            print(f"# Error rendering template: {e}", file=sys.stderr)
            return False

        return self.compile_latex(tex_content, output_name)


def main():
    """Main entry point"""
    parser = argparse.ArgumentParser(description="Generate PDF resume from YAML data")
    parser.add_argument(
        "--yaml",
        type=Path,
        default=Path("data"),
        help="Path to resume data directory or YAML file (default: data)",
    )
    parser.add_argument(
        "--template",
        type=str,
        default="awesome-cv.tex",
        help="Template name (default: awesome-cv.tex)",
    )
    parser.add_argument(
        "--output",
        type=str,
        default="resume",
        help="Output filename without extension (default: resume)",
    )

    args = parser.parse_args()

    # Create generator and generate PDF
    generator = ResumeGenerator()
    success = generator.generate(
        yaml_file=args.yaml, template_name=args.template, output_name=args.output
    )
    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
