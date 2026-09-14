\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{sutthesis}[2026/09/14 v0.1 Unofficial SUT thesis class]

% -----------------------------------------------------------------------------
% Unofficial LaTeX class for Suranaree University of Technology theses.
% Formatting rules are implemented from the public SUT thesis-writing manual.
% This class is NOT an official university template.
% -----------------------------------------------------------------------------

\newif\ifsut@thai
\newif\ifsut@master
\newif\ifsut@strictfont
\sut@thaitrue
\sut@mastertrue
\sut@strictfontfalse

\DeclareOption{thai}{\sut@thaitrue}
\DeclareOption{english}{\sut@thaifalse}
\DeclareOption{master}{\sut@mastertrue}
\DeclareOption{doctoral}{\sut@masterfalse}
\DeclareOption{strictfont}{\sut@strictfonttrue}
\DeclareOption{fallbackfont}{\sut@strictfontfalse}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ProcessOptions\relax

\LoadClass[12pt,a4paper,oneside,openany]{report}

\RequirePackage{iftex}
\ifXeTeX\else
  \ClassError{sutthesis}{This class requires XeLaTeX}
    {Compile with xelatex or latexmk -xelatex. XeTeX is used for Thai line breaking.}
\fi

\RequirePackage{fontspec}
\RequirePackage{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{titlesec}
\RequirePackage{graphicx}
\RequirePackage{booktabs}
\RequirePackage{longtable}
\RequirePackage{array}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{enumitem}
\RequirePackage{caption}
\RequirePackage{xcolor}
\RequirePackage{xparse}
\RequirePackage{etoolbox}
\RequirePackage[hypertexnames=false]{hyperref}

% --- Paper and margins --------------------------------------------------------
% SUT manual chapter 5:
%   A4, top 1.5 in on normal pages, bottom 1 in, left 1.5 in, right 1 in.
%   Chapter/front-matter heading pages begin at 2 in from the top.
% We keep a 1.5 in normal text block and add 0.5 in before chapter-style headings.
\geometry{
  a4paper,
  left=1.5in,
  right=1in,
  top=1.5in,
  bottom=1in,
  headheight=0.28in,
  headsep=0.22in,
  footskip=0.35in
}

% --- Font ---------------------------------------------------------------------
% The official manual explicitly specifies TH SarabunPSK throughout the thesis.
% fallbackfont mode keeps the source buildable on systems without that font, but
% such output is NOT font-compliant with the SUT manual.
\defaultfontfeatures{Ligatures=TeX}
\newcommand{\SUTRequiredFont}{TH SarabunPSK}
\newcommand{\SUTFallbackFont}{FreeSerif}

\IfFontExistsTF{\SUTRequiredFont}{%
  \setmainfont{\SUTRequiredFont}%
}{%
  \ifsut@strictfont
    \ClassError{sutthesis}{Required font TH SarabunPSK was not found}
      {Install TH SarabunPSK or compile without the strictfont option for draft output.}%
  \else
    \ClassWarningNoLine{sutthesis}{TH SarabunPSK not found. Using FreeSerif as a DRAFT fallback; this is not SUT font-compliant}%
    \IfFontExistsTF{\SUTFallbackFont}
      {\setmainfont{\SUTFallbackFont}}
      {\setmainfont{Latin Modern Roman}}
  \fi
}

% Allow an explicit local override when the official font is installed under a
% different family name. Users remain responsible for matching SUT requirements.
\newcommand{\SUTSetMainFont}[1]{\renewcommand{\SUTRequiredFont}{#1}\setmainfont{#1}}

% XeTeX/ICU Thai line breaking. Thai is written without spaces between all words,
% so ordinary TeX inter-word breaking is insufficient.
\ifsut@thai
  \XeTeXlinebreaklocale "th_TH"
  \XeTeXlinebreakskip=0pt plus 1pt
  \XeTeXlinebreakpenalty=100
\fi

% --- Typography ---------------------------------------------------------------
% Confirmed SUT sizes: chapter 20 bold; major heading 18 bold; secondary and
% tertiary headings 16 bold; body 16 regular.
% The public manual excerpts located during implementation do not state a numeric
% baseline skip. 20pt below is therefore an implementation default and can be
% overridden with \SUTSetBodyLeading.
\newlength{\sut@bodyleading}
\setlength{\sut@bodyleading}{20pt}
\newcommand{\SUTSetBodyLeading}[1]{\setlength{\sut@bodyleading}{#1}}
\newcommand{\sut@bodyfont}{\fontsize{16pt}{\sut@bodyleading}\selectfont}
\AtBeginDocument{\sut@bodyfont}

% Default paragraph indent is configurable because the public guide excerpt used
% for this first implementation does not specify a single numeric body-indent rule.
\setlength{\parindent}{2em}
\setlength{\parskip}{0pt}
\setlength{\emergencystretch}{2em}
\newcommand{\SUTSetParagraphIndent}[1]{\setlength{\parindent}{#1}}

% Official indentation rules for heading levels are expressed in character counts.
% Using em units makes the indentation scale with the active 16pt thesis font.
\newlength{\sut@secondaryindent}
\newlength{\sut@tertiaryindent}
\setlength{\sut@secondaryindent}{6em}
\setlength{\sut@tertiaryindent}{12em}

\setcounter{secnumdepth}{3}
\setcounter{tocdepth}{3}

% Chapter: first line starts 0.5 in lower than the normal 1.5 in text boundary,
% producing the required 2 in chapter-start position.
\titleformat{\chapter}[display]
  {\centering\bfseries\fontsize{20pt}{24pt}\selectfont}
  {\ifsut@thai บทที่~\thechapter\else Chapter~\thechapter\fi}
  {0pt}
  {}
\titlespacing*{\chapter}{0pt}{0.5in}{2\baselineskip}

% Major heading: flush left, bold 18pt.
\titleformat{\section}
  {\bfseries\fontsize{18pt}{22pt}\selectfont}
  {\thesection}{0.75em}{}
\titlespacing*{\section}{0pt}{4\baselineskip}{\baselineskip}

% Secondary heading: indent 6 characters, bold 16pt.
\titleformat{\subsection}
  {\bfseries\fontsize{16pt}{20pt}\selectfont}
  {\thesubsection}{0.75em}{}
\titlespacing*{\subsection}{\sut@secondaryindent}{2\baselineskip}{\baselineskip}

% Tertiary heading: indent 12 characters, bold 16pt.
\titleformat{\subsubsection}
  {\bfseries\fontsize{16pt}{20pt}\selectfont}
  {\thesubsubsection}{0.75em}{}
\titlespacing*{\subsubsection}{\sut@tertiaryindent}{2\baselineskip}{\baselineskip}

% --- Page numbering -----------------------------------------------------------
% SUT manual: page number at upper-right, 1 in from top and right edges.
% With a 1.5 in text top and 0.5 in total header+separation, the header starts
% at approximately the required 1 in position; right edge follows the 1 in margin.
\pagestyle{fancy}
\fancyhf{}
\fancyhead[R]{\sut@bodyfont\thepage}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}

% First pages of chapters/front-matter sections are counted but page number hidden.
\fancypagestyle{plain}{\fancyhf{}\renewcommand{\headrulewidth}{0pt}}

% Thai front-matter pagination. The guide illustrates ก, ข, ค, ... but does not
% enumerate the complete alphabetic sequence in the public excerpt. This class
% uses the conventional compact thesis sequence below and exposes an override.
\newcommand{\SUTThaiPageSequence}{ก,ข,ค,ง,จ,ฉ,ช,ซ,ฌ,ญ,ฎ,ฏ,ฐ,ฑ,ฒ,ณ,ด,ต,ถ,ท,ธ,น,บ,ป,ผ,ฝ,พ,ฟ,ภ,ม,ย,ร,ล,ว,ศ,ษ,ส,ห,ฬ,อ,ฮ}
\ExplSyntaxOn
\seq_new:N \g_sut_thai_page_seq
\cs_new_protected:Npn \sut_set_thai_page_sequence:n #1
  { \seq_gset_from_clist:Nn \g_sut_thai_page_seq {#1} }
\sut_set_thai_page_sequence:n {ก,ข,ค,ง,จ,ฉ,ช,ซ,ฌ,ญ,ฎ,ฏ,ฐ,ฑ,ฒ,ณ,ด,ต,ถ,ท,ธ,น,บ,ป,ผ,ฝ,พ,ฟ,ภ,ม,ย,ร,ล,ว,ศ,ษ,ส,ห,ฬ,อ,ฮ}
\NewDocumentCommand{\SUTSetThaiPageSequence}{m}
  { \sut_set_thai_page_sequence:n {#1} }
\cs_new:Npn \sut_thai_page:n #1
  {
    \int_compare:nNnTF {#1} > {\seq_count:N \g_sut_thai_page_seq}
      {#1}
      {\seq_item:Nn \g_sut_thai_page_seq {#1}}
  }
\NewExpandableDocumentCommand{\SUTThaiPage}{m}{\sut_thai_page:n{#1}}
\ExplSyntaxOff

% Appendices: the SUT guide specifies Thai letter labels (ภาคผนวก ก, ข, ...)
% when there is more than one appendix. Standard LaTeX uses A, B, ...; switch
% the chapter representation and displayed chapter label for Thai theses.
\let\sut@standardappendix\appendix
\renewcommand{\appendix}{%
  \sut@standardappendix
  \ifsut@thai
    \renewcommand{\thechapter}{\SUTThaiPage{\value{chapter}}}%
    \titleformat{\chapter}[display]
      {\centering\bfseries\fontsize{20pt}{24pt}\selectfont}
      {ภาคผนวก~\thechapter}
      {0pt}
      {}%
    \titlespacing*{\chapter}{0pt}{0.5in}{2\baselineskip}%
  \fi
}

\newcommand{\frontmatter}{%
  \clearpage
  \setcounter{page}{1}%
  \ifsut@thai
    \renewcommand{\thepage}{\SUTThaiPage{\value{page}}}%
  \else
    \renewcommand{\thepage}{\Roman{page}}%
  \fi
  \pagestyle{fancy}%
}

\newcommand{\mainmatter}{%
  \clearpage
  \pagenumbering{arabic}%
  \pagestyle{fancy}%
}

% --- Metadata -----------------------------------------------------------------
\newcommand{\sut@titleth}{}
\newcommand{\sut@titleen}{}
\newcommand{\sut@authorth}{}
\newcommand{\sut@authoren}{}
\newcommand{\sut@degreeTH}{วิศวกรรมศาสตรมหาบัณฑิต}
\newcommand{\sut@degreeEN}{Master of Engineering}
\newcommand{\sut@programTH}{}
\newcommand{\sut@programEN}{}
\newcommand{\sut@academicyear}{}
\newcommand{\sut@advisorTH}{}
\newcommand{\sut@advisorEN}{}
\newcommand{\sut@keywordsTH}{}
\newcommand{\sut@keywordsEN}{}

\newcommand{\SUTTitleTH}[1]{\renewcommand{\sut@titleth}{#1}}
\newcommand{\SUTTitleEN}[1]{\renewcommand{\sut@titleen}{#1}}
\newcommand{\SUTAuthorTH}[1]{\renewcommand{\sut@authorth}{#1}}
\newcommand{\SUTAuthorEN}[1]{\renewcommand{\sut@authoren}{#1}}
\newcommand{\SUTDegreeTH}[1]{\renewcommand{\sut@degreeTH}{#1}}
\newcommand{\SUTDegreeEN}[1]{\renewcommand{\sut@degreeEN}{#1}}
\newcommand{\SUTProgramTH}[1]{\renewcommand{\sut@programTH}{#1}}
\newcommand{\SUTProgramEN}[1]{\renewcommand{\sut@programEN}{#1}}
\newcommand{\SUTAcademicYear}[1]{\renewcommand{\sut@academicyear}{#1}}
\newcommand{\SUTAdvisorTH}[1]{\renewcommand{\sut@advisorTH}{#1}}
\newcommand{\SUTAdvisorEN}[1]{\renewcommand{\sut@advisorEN}{#1}}
\newcommand{\SUTKeywordsTH}[1]{\renewcommand{\sut@keywordsTH}{#1}}
\newcommand{\SUTKeywordsEN}[1]{\renewcommand{\sut@keywordsEN}{#1}}

% Public read-only metadata accessors for custom front-matter files.
\newcommand{\SUTTitleTHValue}{\sut@titleth}
\newcommand{\SUTTitleENValue}{\sut@titleen}
\newcommand{\SUTAuthorTHValue}{\sut@authorth}
\newcommand{\SUTAuthorENValue}{\sut@authoren}
\newcommand{\SUTDegreeTHValue}{\sut@degreeTH}
\newcommand{\SUTDegreeENValue}{\sut@degreeEN}
\newcommand{\SUTProgramTHValue}{\sut@programTH}
\newcommand{\SUTProgramENValue}{\sut@programEN}
\newcommand{\SUTAcademicYearValue}{\sut@academicyear}
\newcommand{\SUTAdvisorTHValue}{\sut@advisorTH}
\newcommand{\SUTAdvisorENValue}{\sut@advisorEN}

% --- Cover pages --------------------------------------------------------------
% The exact 2026 Word-template spacing is not encoded as an official claim here;
% these helpers provide a clean semantic cover that can be tuned without touching
% thesis content.
\newcommand{\SUTMakeThaiCover}{%
  \begin{titlepage}
    \thispagestyle{empty}
    \begin{center}
      \bfseries\fontsize{20pt}{24pt}\selectfont
      \sut@titleth
      \vfill
      \normalfont\fontsize{18pt}{22pt}\selectfont
      \sut@authorth
      \vfill
      \fontsize{16pt}{20pt}\selectfont
      วิทยานิพนธ์นี้เป็นส่วนหนึ่งของการศึกษาตามหลักสูตร\\
      \sut@degreeTH\\
      \sut@programTH\\
      มหาวิทยาลัยเทคโนโลยีสุรนารี\\
      ปีการศึกษา \sut@academicyear
    \end{center}
  \end{titlepage}
}

\newcommand{\SUTMakeEnglishCover}{%
  \begin{titlepage}
    \thispagestyle{empty}
    \begin{center}
      \bfseries\fontsize{20pt}{24pt}\selectfont
      \MakeUppercase{\sut@titleen}
      \vfill
      \normalfont\fontsize{18pt}{22pt}\selectfont
      \sut@authoren
      \vfill
      \fontsize{16pt}{20pt}\selectfont
      A Thesis Submitted in Partial Fulfillment of the Requirements for the\\
      Degree of \sut@degreeEN\\
      \sut@programEN\\
      Suranaree University of Technology\\
      Academic Year \sut@academicyear
    \end{center}
  \end{titlepage}
}

% --- Front-matter headings ----------------------------------------------------
\newcommand{\SUTFrontMatterHeading}[1]{%
  \clearpage
  \thispagestyle{plain}
  \vspace*{0.5in}% normal text top is 1.5in -> heading begins around 2in
  \begin{center}
    \bfseries\fontsize{20pt}{24pt}\selectfont #1
  \end{center}
  \vspace{2\baselineskip}
}

\NewDocumentEnvironment{sutabstractth}{}{%
  \SUTFrontMatterHeading{บทคัดย่อ}
}{%
  \par\vspace{\baselineskip}
  \noindent\textbf{คำสำคัญ:} \sut@keywordsTH
}

\NewDocumentEnvironment{sutabstracten}{}{%
  \SUTFrontMatterHeading{ABSTRACT}
}{%
  \par\vspace{\baselineskip}
  \noindent\textbf{Keywords:} \sut@keywordsEN
}

\NewDocumentEnvironment{sutacknowledgements}{}{%
  \SUTFrontMatterHeading{กิตติกรรมประกาศ}
}{}

% Convenience page for committee/approval content. The committee body is kept in
% frontmatter/approval.tex because committee composition varies by program.
\newcommand{\SUTApprovalHeading}{\SUTFrontMatterHeading{หน้าอนุมัติวิทยานิพนธ์}}

% --- Localized document names --------------------------------------------------
\ifsut@thai
  \renewcommand{\contentsname}{สารบัญ}
  \renewcommand{\listfigurename}{สารบัญรูป}
  \renewcommand{\listtablename}{สารบัญตาราง}
  \renewcommand{\bibname}{รายการอ้างอิง}
\fi

% --- Captions -----------------------------------------------------------------
\captionsetup{font={normalfont},labelfont={bf},justification=centering}
\ifsut@thai
  \renewcommand{\figurename}{รูปที่}
  \renewcommand{\tablename}{ตารางที่}
\fi

% --- Hyperlinks ---------------------------------------------------------------
\hypersetup{
  unicode=true,
  colorlinks=false,
  pdfborder={0 0 0}
}

% --- References ---------------------------------------------------------------
% SUT manual: first line flush left, continuation lines indented by 8 characters.
% Use this length with biblatex via \setlength{\bibhang}{\SUTReferenceHang}.
\newlength{\SUTReferenceHang}
\setlength{\SUTReferenceHang}{8em}

\endinput
