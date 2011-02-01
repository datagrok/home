%%

% Here's what I wish to do with the homework class:
%  - Simple header: name, prof, class, date
%  - If there's a title, typeset it flush left, similar to but larger than \part*
%  - No page number at bottom of first page
%  - ``Lamb 2'' in upper right of second page, etc.
%  - ``Lamb 3'' in upper left *if* printing even/odd.

% Wanted:
%  - 2nup-letter paper size, for 2-nup printing without wasted space

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{homework}[2006/10/04 Simple homework class]
\RequirePackage{amsmath}
\RequirePackage{amsthm}
\RequirePackage{amssymb}
\LoadClass[notitlepage]{article}
\DeclareOption{letter2nup}
   {\setlength\paperheight {5.5in}%
    \setlength\paperwidth  {4.25in}}
\ProcessOptions

%%\renewcommand{\maketitle}{%
%%      \fontfamily{phv}\fontseries{b}%
%%      \fontshape{sl}\selectfont
%%      \@title
%%}

\def\@class{\@empty}
\def\@professor{\@empty}
\def\class#1{\def\@class{#1}}
\def\professor#1{\def\@professor{#1}}

\def\@maketitle{%
	\newpage
	\let \footnote \thanks
	\noindent\@class\\\@professor\\\@author\\\@date\par
	\part*{\@title}\par
	}

%% vim: nospell:
