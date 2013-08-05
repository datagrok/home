%%

% Wanted:
%  - 2nup-letter paper size, for 2-nup printing without wasted space

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{resume}[2013/07/30 Simple resume class]
\RequirePackage{amsmath}
\RequirePackage{amsthm}
\RequirePackage{amssymb}
\RequirePackage{multicol}
% \RequirePackage{concrete}
\LoadClass[notitlepage]{article}
\DeclareOption{letter2nup}
   {\setlength\paperheight {5.5in}%
    \setlength\paperwidth  {4.25in}}
\ProcessOptions

\def\@address{\@empty}
\def\address#1{\def\@address{#1}}

\def\@maketitle{%
	\newpage
    \begin{multicols}{2}
	\part*{\@title}\par
    \columnbreak
    935 Marietta St NW \#705\\
    Atlanta, GA 30318\\
    (404) 368-7309 cell/sms\\
    \href{mailto:mike@datagrok.org}{mike@datagrok.org}\\
    \href{https://github.com/datagrok}{https://github.com/datagrok}
    \end{multicols}
	}

\usepackage[margin=0.75in]{geometry}

%% vim: nospell:
