# Markdown Formatting Guide

PyResume now supports basic markdown-style formatting in your YAML files that gets automatically converted to LaTeX formatting in the PDF.

## Supported Formatting

### Bold Text
Use `*text*` or `**text**` to make text bold.

**YAML Example**:
```yaml
details:
  - "Reduced latency by *40%* using optimized algorithms"
  - "Improved **performance** significantly"
```

**PDF Output**: 
- Reduced latency by **40%** using optimized algorithms
- Improved **performance** significantly

---

### Italic Text
Use `_text_` to make text italic.

**YAML Example**:
```yaml
details:
  - "Implemented _real-time_ data processing"
  - "Focused on _scalability_ and _maintainability_"
```

**PDF Output**:
- Implemented *real-time* data processing
- Focused on *scalability* and *maintainability*

---

### Code/Monospace Text
Use `` `text` `` for code or technical terms.

**YAML Example**:
```yaml
details:
  - "Built pipelines using `PySpark` and `Apache Airflow`"
  - "Optimized `SQL` queries for better performance"
```

**PDF Output**:
- Built pipelines using `PySpark` and `Apache Airflow`
- Optimized `SQL` queries for better performance

---

## Combining Formats

You can combine multiple formatting styles in the same text:

**YAML Example**:
```yaml
details:
  - "Achieved *95% accuracy* using `YOLOv7` in _real-time_ inference"
  - "Reduced costs by **50%** through _efficient_ `AWS` resource management"
```

**PDF Output**:
- Achieved **95% accuracy** using `YOLOv7` in *real-time* inference
- Reduced costs by **50%** through *efficient* `AWS` resource management

---

## Usage Examples

### Experience Section
```yaml
- company: "Tech Company"
  position: "Data Engineer"
  details:
    - "Reduced query time by *40%* using `PostgreSQL` optimization"
    - "Built _scalable_ ETL pipelines with **PySpark**"
    - "Implemented `Apache Kafka` for _real-time_ data streaming"
```

### Projects Section
```yaml
- name: "ML Pipeline"
  details:
    - "Achieved **95% accuracy** using `TensorFlow` and `Keras`"
    - "Deployed on `AWS Lambda` for _serverless_ execution"
    - "Reduced inference time by *60%* through model optimization"
```

### Skills Section
```yaml
- category: "Programming"
  items: "*Python*, `SQL`, **JavaScript**, _TypeScript_"
```

---

## Important Notes

### Escaping
If you need to use literal `*`, `_`, or `` ` `` characters without formatting:
- Currently not supported - these will always be interpreted as formatting
- Workaround: Avoid using these characters in places where you don't want formatting

### Nested Formatting
Avoid nesting the same format type:
- ❌ `*text with *nested* bold*` - May not work as expected
- ✅ `*bold* and _italic_` - Works fine

### LaTeX Commands
The markdown is converted to LaTeX commands:
- `*text*` → `\textbf{text}` (bold)
- `_text_` → `\textit{text}` (italic)
- `` `text` `` → `\texttt{text}` (monospace)

---

## How It Works

The conversion happens automatically in the `generate_resume.py` script:

1. **Load YAML data** from `data/` directory
2. **Convert markdown** to LaTeX commands (`*bold*` → `\textbf{bold}`)
3. **Escape special characters** (protect LaTeX syntax)
4. **Render template** with processed data
5. **Compile PDF** with Tectonic

---

## Testing Your Formatting

1. Edit your YAML files with markdown formatting
2. Run `make build`
3. Check the generated PDF in `output/resume.pdf`

**Example**:
```bash
# Edit your data
vim data/experience.yaml

# Build resume
make build

# View PDF
make view-pdf
```

---

## Tips

### Emphasis Numbers and Percentages
```yaml
- "Improved performance by *40%*"
- "Achieved **99.9% uptime**"
- "Reduced costs by *$50K annually*"
```

### Highlight Technologies
```yaml
- "Built with `Python`, `Docker`, and `Kubernetes`"
- "Deployed on `AWS` using `Terraform`"
```

### Emphasize Key Achievements
```yaml
- "Led a team of **5 engineers** to deliver _critical_ features"
- "Managed **$2M budget** for _infrastructure_ improvements"
```

---

## Summary

| Syntax | LaTeX Command | Effect |
|--------|---------------|--------|
| `*text*` or `**text**` | `\textbf{text}` | **Bold** |
| `_text_` | `\textit{text}` | *Italic* |
| `` `text` `` | `\texttt{text}` | `Monospace` |

Use these formatting options to make your resume more visually appealing and highlight important information!
