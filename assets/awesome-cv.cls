%% Simplified Awesome CV Class File
% Based on: https://github.com/posquit0/Awesome-CV
% License: LPPL v1.3c

\ProvidesClass{awesome-cv}[2024/12/10 Simplified Awesome CV Class]
\NeedsTeXFormat{LaTeX2e}

%-------------------------------------------------------------------------------
% Class Options
%-------------------------------------------------------------------------------
\DeclareOption{draft}{\setlength\overfullrule{5pt}}
\DeclareOption{final}{\setlength\overfullrule{0pt}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass{article}

%-------------------------------------------------------------------------------
% Required Packages
%-------------------------------------------------------------------------------
\RequirePackage{array}
\RequirePackage{enumitem}
\RequirePackage{ragged2e}
\RequirePackage{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{xcolor}
\RequirePackage{ifxetex}
\RequirePackage{xifthen}
\RequirePackage{etoolbox}
\RequirePackage{setspace}
\RequirePackage[quiet]{fontspec}
\RequirePackage{unicode-math}
\RequirePackage{fontawesome}
\RequirePackage[default,opentype]{sourcesanspro}
\RequirePackage[skins]{tcolorbox}
\RequirePackage{parskip}
\RequirePackage[hidelinks,unicode]{hyperref}
\RequirePackage[T1]{fontenc}
\RequirePackage{cmap}
\RequirePackage[none]{hyphenat}

\defaultfontfeatures{Ligatures=TeX}
\hypersetup{pdftitle={}, pdfauthor={}, pdfsubject={}, pdfkeywords={}}

%-------------------------------------------------------------------------------
% Font Configuration
%-------------------------------------------------------------------------------
\newcommand*{\fontdir}[1][fonts/]{\def\@fontdir{#1}}
\fontdir

\newfontfamily\headerfontlight[
  Path=\@fontdir,
  UprightFont=*-Thin,
  ItalicFont=*-ThinItalic,
  BoldFont=*-Medium,
  BoldItalicFont=*-MediumItalic,
]{Roboto}

\newfontfamily\headerfont[
  Path=\@fontdir,
  UprightFont=*-Regular,
  ItalicFont=*-Italic,
  BoldFont=*-Bold,
  BoldItalicFont=*-BoldItalic,
]{EBGaramond}

\newfontfamily\bodyfont[
  Path=\@fontdir,
  UprightFont=*-Regular,
  ItalicFont=*-MediumItalic,
  BoldFont=*-Bold,
  BoldItalicFont=*-BoldItalic,
]{EBGaramond}

\newfontfamily\bodyfontlight[
  Path=\@fontdir,
  UprightFont=*-Regular,
  ItalicFont=*-Italic,
  BoldFont=*-SemiBold,
  BoldItalicFont=*-SemiBoldItalic,
]{EBGaramond}

\newcommand*{\footerfont}{\sourcesanspro}

%-------------------------------------------------------------------------------
% Page Layout
%-------------------------------------------------------------------------------
\geometry{left=1.5cm, top=2.5mm, right=1.5cm, bottom=2.0mm, footskip=.5cm, headsep=0cm}
\pagestyle{fancy}
\fancyhfoffset{0em}
\renewcommand{\headrulewidth}{0pt}
\fancyhf{}

%-------------------------------------------------------------------------------
% Colors
%-------------------------------------------------------------------------------
\definecolor{white}{HTML}{FFFFFF}
\definecolor{black}{HTML}{000000}
\definecolor{darkgray}{HTML}{333333}
\definecolor{gray}{HTML}{5D5D5D}
\definecolor{lightgray}{HTML}{999999}
\definecolor{darktext}{HTML}{414141}

\colorlet{text}{darkgray}
\colorlet{graytext}{gray}
\colorlet{lighttext}{lightgray}

\definecolor{awesome-emerald}{HTML}{00A388}
\definecolor{awesome-skyblue}{HTML}{0395DE}
\definecolor{awesome-red}{HTML}{DC3522}
\definecolor{awesome-pink}{HTML}{EF4089}
\definecolor{awesome-orange}{HTML}{FF6138}
\definecolor{awesome-nephritis}{HTML}{27AE60}
\definecolor{awesome-concrete}{HTML}{95A5A6}
\definecolor{awesome-darknight}{HTML}{131A28}

\colorlet{awesome}{awesome-red}

\newbool{acvSectionColorHighlight}
\setbool{acvSectionColorHighlight}{true}

\newcommand*{\sectioncolor}[1]{%
  \ifbool{acvSectionColorHighlight}{{\color{awesome}#1}}{#1}%
}

%-------------------------------------------------------------------------------
% Text Styles
%-------------------------------------------------------------------------------
\newcommand*{\headerfirstnamestyle}[1]{{\fontsize{20pt}{1em}\headerfont\color{text} #1}}
\newcommand*{\headerlastnamestyle}[1]{{\fontsize{20pt}{1em}\headerfont\bfseries\color{text} #1}}
\newcommand*{\headerpositionstyle}[1]{{\fontsize{7.6pt}{1em}\bodyfont\scshape\color{awesome} #1}}
\newcommand*{\headeraddressstyle}[1]{{\fontsize{8pt}{1em}\headerfont\scshape\color{graytext} #1}}
\newcommand*{\headersocialstyle}[1]{{\fontsize{8pt}{1em}\headerfont\bfseries\color{text} #1}}
\newcommand*{\sectionstyle}[1]{{\fontsize{11pt}{1em}\headerfont\bfseries\color{text}\sectioncolor{#1}}}
\newcommand*{\entrycompanystyle}[1]{{\fontsize{10pt}{1em}\headerfont\bfseries\color{darktext} #1}}
\newcommand*{\entrypositionstyle}[1]{{\fontsize{8pt}{1em}\bodyfontlight\scshape\color{graytext} #1}}
\newcommand*{\entrylocationstyle}[1]{{\fontsize{8pt}{1em}\bodyfontlight\color{graytext} #1}}
\newcommand*{\entrykeyskillstyle}[1]{{\fontsize{8pt}{1em}\bodyfontlight\color{graytext} #1}}
\newcommand*{\datestyle}[1]{{\fontsize{8pt}{1em}\bodyfontlight\bfseries\color{awesome} #1}}
\newcommand*{\descriptionstyle}[1]{{\fontsize{9pt}{1em}\fussy\bodyfontlight\color{text} #1}}
\newcommand*{\subentrytitlestyle}[1]{{\fontsize{9pt}{1em}\bodyfont\bfseries\color{text} #1}}
\newcommand*{\subdescriptionstyle}[1]{{\fontsize{9pt}{1em}\bodyfontlight\color{text} #1}}
\newcommand*{\subentrygradestyle}[1]{{\fontsize{9pt}{1em}\bodyfontlight\slshape\color{darktext} #1}}

%-------------------------------------------------------------------------------
% Personal Information Commands
%-------------------------------------------------------------------------------
\newcommand*{\name}[2]{\def\@firstname{#1}\def\@lastname{#2}}
\newcommand*{\firstname}[1]{\def\@firstname{#1}}
\newcommand*{\lastname}[1]{\def\@lastname{#1}}
\newcommand*{\address}[1]{\def\@address{#1}}
\newcommand*{\position}[1]{\def\@position{#1}}
\newcommand*{\mobile}[1]{\def\@mobile{#1}}
\newcommand*{\email}[1]{\def\@email{#1}}
\newcommand*{\homepage}[1]{\def\@homepage{#1}}
\newcommand*{\github}[1]{\def\@github{#1}}
\newcommand*{\gitlab}[1]{\def\@gitlab{#1}}
\newcommand*{\stackoverflow}[2]{\def\@stackoverflowid{#1}\def\@stackoverflowname{#2}}
\newcommand*{\linkedin}[1]{\def\@linkedin{#1}}
\newcommand*{\twitter}[1]{\def\@twitter{#1}}

%-------------------------------------------------------------------------------
% Layout Helper Commands
%-------------------------------------------------------------------------------
\newcommand{\acvHeaderNameDelim}{\space}
\newcommand{\acvHeaderAfterNameSkip}{2mm}
\newcommand{\acvHeaderAfterPositionSkip}{0.25mm}
\newcommand{\acvHeaderAfterAddressSkip}{0.25mm}
\newcommand{\acvHeaderSocialSep}{\quad\textbar\quad}
\newcommand{\acvHeaderAfterSocialSkip}{0.25mm}
\newcommand{\acvSectionTopSkip}{2mm}
\newcommand{\acvSectionContentTopSkip}{2.5mm}

%-------------------------------------------------------------------------------
% Utilities
%-------------------------------------------------------------------------------
\newcolumntype{L}[1]{>{\raggedright\let\newline\\\arraybackslash\hspace{0pt}}m{#1}}
\newcolumntype{C}[1]{>{\centering\let\newline\\\arraybackslash\hspace{0pt}}m{#1}}
\newcolumntype{R}[1]{>{\raggedleft\let\newline\\\arraybackslash\hspace{0pt}}m{#1}}

\def\vhrulefill#1{\leavevmode\leaders\hrule\@height#1\hfill \kern\z@}
\newcommand*{\ifempty}[3]{\ifthenelse{\isempty{#1}}{#2}{#3}}

%-------------------------------------------------------------------------------
% CV Header
%-------------------------------------------------------------------------------
\newcommand*{\makecvheader}[1][C]{%
  \newlength{\headertextwidth}
  \setlength{\headertextwidth}{1\textwidth}
  \begin{minipage}[t]{\headertextwidth}
    \ifthenelse{\equal{#1}{L}}{\raggedright}{\ifthenelse{\equal{#1}{R}}{\raggedleft}{\centering}}
    \headerfirstnamestyle{\@firstname}\headerlastnamestyle{{}\acvHeaderNameDelim\@lastname}%
    \\[\acvHeaderAfterNameSkip]%
    \ifthenelse{\isundefined{\@position}}{}{\headerpositionstyle{\@position\\[\acvHeaderAfterPositionSkip]}}%
    \ifthenelse{\isundefined{\@address}}{}{\headeraddressstyle{\@address\\[\acvHeaderAfterAddressSkip]}}%
    \headersocialstyle{%
      \newbool{isstart}%
      \setbool{isstart}{true}%
      \ifthenelse{\isundefined{\@mobile}}%
        {}%
        {%
          Phone: \@mobile%
          \setbool{isstart}{false}%
        }%
      \ifthenelse{\isundefined{\@email}}%
        {}%
        {%
          \ifbool{isstart}{\setbool{isstart}{false}}{\acvHeaderSocialSep}%
          \href{mailto:\@email}{Email: \@email}%
        }%
      \ifthenelse{\isundefined{\@homepage}}%
        {}%
        {%
          \ifbool{isstart}{\setbool{isstart}{false}}{\acvHeaderSocialSep}%
          \href{http://\@homepage}{Portfolio: \@homepage}%
        }%
      \ifthenelse{\isundefined{\@github}}%
        {}%
        {%
          \ifbool{isstart}{\setbool{isstart}{false}}{\acvHeaderSocialSep}%
          \href{https://github.com/\@github}{Github: \@github}%
        }%
      \ifthenelse{\isundefined{\@gitlab}}%
        {}%
        {%
          \ifbool{isstart}{\setbool{isstart}{false}}{\acvHeaderSocialSep}%
          \href{https://gitlab.com/\@gitlab}{Gitlab: \@gitlab}%
        }%
      \ifthenelse{\isundefined{\@stackoverflowid}}%
        {}%
        {%
          \ifbool{isstart}{\setbool{isstart}{false}}{\acvHeaderSocialSep}%
          \href{https://stackoverflow.com/users/\@stackoverflowid}{StackOverflow: \@stackoverflowname}%
        }%
      \ifthenelse{\isundefined{\@linkedin}}%
        {}%
        {%
          \ifbool{isstart}{\setbool{isstart}{false}}{\acvHeaderSocialSep}%
          \href{https://www.linkedin.com/in/\@linkedin}{Linkedin: \@linkedin}%
        }%
      \ifthenelse{\isundefined{\@twitter}}%
        {}%
        {%
          \ifbool{isstart}{\setbool{isstart}{false}}{\acvHeaderSocialSep}%
          \href{https://twitter.com/\@twitter}{Twitter: \@twitter}%
        }%
    } \\[\acvHeaderAfterSocialSkip]%
  \end{minipage}%
}

%-------------------------------------------------------------------------------
% CV Sections
%-------------------------------------------------------------------------------
\newcommand{\cvsection}[1]{%
  \vspace{\acvSectionTopSkip}
  \sectionstyle{#1}
  \phantomsection
  \color{gray}\vhrulefill{0.5pt}
}

%-------------------------------------------------------------------------------
% Experience Entry
%-------------------------------------------------------------------------------
\newenvironment{cventries}{%
  \vspace{\acvSectionContentTopSkip}
  \begin{center}
}{%
  \end{center}
}

\newcommand*{\cventry}[6]{%
  \setlength\tabcolsep{0pt}
  \setlength{\extrarowheight}{0pt}
  \begin{tabular*}{\textwidth}{@{\extracolsep{\fill}} L{\textwidth - 2.5cm} R{2.5cm}}
    \ifempty{#2#3#4}
      {\entrycompanystyle{#1} \\}
      {\entrycompanystyle{#2} & \datestyle{#4} \\
       \entrypositionstyle{#1} & \entrylocationstyle{#3} \\ [0.5ex]}
    \multicolumn{2}{L{\textwidth}}{\sloppy\descriptionstyle{#5}}\\
    \entrykeyskillstyle{{\scshape Keywords: }#6}
  \end{tabular*}%
  \vspace{0.5em}
}

%-------------------------------------------------------------------------------
% Project Entry
%-------------------------------------------------------------------------------
\newenvironment{cvprojects}{%
  \vspace{\acvSectionContentTopSkip}
  \begin{center}
}{%
  \end{center}
}

\newcommand*{\cvproject}[4]{%
  \setlength\tabcolsep{0pt}
  \setlength{\extrarowheight}{0pt}
  \begin{tabular*}{\textwidth}{@{\extracolsep{\fill}} L{\textwidth - 2.5cm} R{2.5cm}}
    \entrycompanystyle{#1} & \datestyle{#2} \\ [0.5ex]
    \multicolumn{2}{L{\textwidth}}{\descriptionstyle{#3}}\\
    \entrykeyskillstyle{{\scshape Keywords: }#4}
  \end{tabular*}%
  \vspace{0.5em}
}

%-------------------------------------------------------------------------------
% Education Entry
%-------------------------------------------------------------------------------
\newenvironment{cveducation}{%
  \vspace{\acvSectionContentTopSkip}
  \begin{center}
}{%
  \end{center}
}

\newcommand*{\cveditems}[5]{%
  \setlength\tabcolsep{0pt}
  \setlength{\extrarowheight}{0pt}
  \begin{center}
  \begin{tabular*}{\textwidth}{@{\extracolsep{\fill}} L{\textwidth - 2.5cm} R{2.5cm}}
    \subentrytitlestyle{#1}, \subdescriptionstyle{#2, #3} & \datestyle{#4} \\
  \end{tabular*}%
  \end{center}
  \ifempty{#5}{}{\subentrygradestyle{#5}}
  \vspace{-0.5em}
}

%-------------------------------------------------------------------------------
% Skills Section
%-------------------------------------------------------------------------------
\newenvironment{cvskills}{%
  \vspace{\acvSectionContentTopSkip}
  \begin{center}
  \raggedright
}{%
  \end{center}
}

\newcommand*{\cvskill}[2]{%
  \subentrytitlestyle{#1}: \subdescriptionstyle{#2}\\
}

%-------------------------------------------------------------------------------
% Item List (for bullet points)
%-------------------------------------------------------------------------------
\newenvironment{cvitems}{%
  \vspace{-4.0mm}
  \begin{justify}
  \begin{itemize}[leftmargin=2ex, nosep, noitemsep]
    \setlength{\parskip}{0pt}
    \renewcommand{\labelitemi}{\bullet}
}{%
  \end{itemize}
  \end{justify}
  \vspace{-4.0mm}
}
