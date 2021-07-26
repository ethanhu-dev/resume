%------------------------------------------------
%   Resume in Latex
%   Author  : Ethan Hu
%------------------------------------------------

\ProvidesClass{cvtemplate}[2021/07/23 Resume Template]

\newcommand\@cvfontsize{11pt}
\newcommand\@cvfontface{LatinModernRoman}
\newcommand\@cvdocpaper{letterpaper}
\newcommand\@cvmargsize{margin=0.5in}

%\DeclareOption{times}{\renewcommand\@cvfontface{TimesNewRoman}}
%\DeclareOption{latin}{\renewcommand\@cvfontface{LatinModernRoman}}
%\DeclareOption{calib}{\renewcommand\@cvfontface{Calibri}}
%\DeclareOption{cambr}{\renewcommand\@cvfontface{Cambria}}
%\DeclareOption{garam}{\renewcommand\@cvfontface{Garamond}}
%\DeclareOption{georg}{\renewcommand\@cvfontface{Georgia}}
%\DeclareOption{helve}{\renewcommand\@cvfontface{Helvetica}}
%\DeclareOption{arial}{\renewcommand\@cvfontface{Arial}}
%
%\DeclareOption{10pt}{\renewcommand\@cvfontsize{10pt}}
%\DeclareOption{12pt}{\renewcommand\@cvfontsize{12pt}}
%
%\DeclareOption{half}{\renewcommand\@cvmargins{margin=0.5in}}
%\DeclareOption{inch}{\renewcommand\@cvmargins{margin=1.0in}}

%\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}

\ProcessOptions\relax

\LoadClass[\@cvdocpaper,\@cvfontsize]{article}

\usepackage[\@cvmargsize]{geometry}     % Required for margin setup
\usepackage[svgnames]{xcolor}           % Required for colors
\usepackage{array}                      % Required for boldface
\usepackage{tabu}                       % Required for tables
\usepackage[tuenc]{fontspec}            % Required for fonts faces
\usepackage{fontawesome5}               % Required for symbols
\usepackage[ocgcolorlinks]{hyperref}    % Required for colored web links
\usepackage{enumitem}                   % Required for itemized lists
\usepackage{etoolbox}                   % Required for boolean statements
\usepackage{microtype}                  % Required for text aesthetics

% Required for paragraph spacing
% Sets \parindent, \itemsep, \topsep = 0 if \normalsize
% Sets \parskip, \parsep = 0.5\baselineskip +/- 2
\usepackage{parskip}[parfill]

% Sets table column separation
\setlength{\tabcolsep}{0pt}
%\renewcommand\arraystretch{1}

% Sets list spacing
% Sets \itemsep and \parsep = 0
\setlist{
  leftmargin=0pt,
  noitemsep,
  topsep=0pt
}

% Keeps URL style consistent with font and suppress page numbers
\urlstyle{same}
\pagestyle{empty}

% Sets document font face
%\setmainfont{LatinModernRoman}
%[
%%  BoldFeatures={
%    SmallCapsFont=\@cvfontface,
%    SmallCapsFeatures={Letters=SmallCaps}
%%  }
%]

% Sets web link colors and PDF options
\hypersetup{
  final,
  debug=true,
  pdfauthor={Ethan Hu},
  pdfdisplaydoctitle,
  pdfhighlight=/N,
  pdfkeywords={Hire}{Ethan}{Hu},
  pdflang={en-US},
  pdfpagelayout=SinglePage,
  pdfpagemode=FullScreen,
  pdfstartview=Fit,
  pdftitle={EthanHuResume},
  urlcolor=DarkBlue,
}

% Declares and activates font set
\DeclareMicrotypeSet*{smallcaps}{
  encoding = {OT1,T1,T2A,LY1,OT4,QX,T5,TS1,EU1,EU2},
  shape = {sc*,si,scit}
}

%-------------------------------------------------------------------------------
%   CONSTANTS
%   Defines macros for consistency in spacing in the document
%-------------------------------------------------------------------------------
% Commands to set spacing
\def\hsp#1{\hspace{#1}}
\def\vsp#1{\vspace{#1}}
\def\sep{\textbullet}   % Set default separator/list label

\def\nspace               {\vsp{-4pt}}   % Spacing after name
\def\csep                 {\hsp{5pt}}   % Spacing between contact items
\def\userspace            {\vsp{4pt}}   % Spacing after user info
\def\secheaderafter       {\vsp{2pt}}   % Spacing after section titles
\def\seclineafter         {\vsp{1pt}}   % Spacing after lines
\def\subheadertwolineafter{\vsp{2pt}}   % Spacing after 2line header subsections
\def\subheaderonelineafter{\vsp{1pt}}   % Spacing after 1line header subsections
\def\nosubheaderafter     {\vsp{0pt}}   % Spacing after no header subsections
\def\secitemsep           {6pt}   % Spacing between section items
\def\subitemsep           {-1pt}   % Spacing between subsection items
\def\secheadermargin      {0pt}   % Margin for section items
\def\subheadermargin      {0pt}   % Margin for subsection items
\def\seclistmargin        {0pt}   % Margin for section items
\def\sublistmargin        {0pt}   % Margin for subsection items

%-------------------------------------------------------------------------------
% 	MACROS
%   Defines
%-------------------------------------------------------------------------------

% Commands to set user information
\newcommand\name[1]{\def\@name{#1}}
\newcommand\addr[1]{\def\@addr{#1}}
\newcommand\numb[1]{\def\@numb{#1}}
\newcommand\mail[1]{\def\@mail{#1}}
\newcommand\link[1]{\def\@link{#1}}
\newcommand\gith[1]{\def\@gith{#1}}

% Set default to empty
\def\@name{}
\def\@addr{}
\def\@numb{}
\def\@mail{}
\def\@link{}
\def\@gith{}

% Prints user name and contact info
\newcommand\printuserheader{
  \begin{center}
    \begin{tabu} to \textwidth {X[c]}
      {\Huge\scshape \@name}
    \end{tabu}
  \end{center} \nspace
  \begin{center}
    \begin{tabu} to \textwidth {X[c]}
      \ifblank{\@addr}{}{\@addr}
      \ifblank{\@numb}{}{\faPhone*~\@numb\csep}
      \ifblank{\@mail}{}{\faEnvelope~\href{mailto:\@mail}{\@mail}\csep}
      \ifblank{\@link}{}{\faLinkedin~\href{https://\@link}{\@link}\csep}
      \ifblank{\@gith}{}{\faGithub~\href{https://\@gith}{\@gith}}
    \end{tabu}
  \end{center} \userspace
}

% Prints header at document begin
\let\@document\document
\renewcommand\document{\@document\printuserheader}

%-------------------------------------------------------------------------------
% 	SECTION/SUBSECTION FORMATTING
%   Defines section and subsection environments for each section in the document
%-------------------------------------------------------------------------------

% Section environment
% 1 input: section name
\newenvironment{cvsection}[1]{
  {\Large\scshape #1}
  \secheaderafter
  \hrule
  \seclineafter
  \begin{itemize}[label={},itemsep=\secitemsep]
}{
  \end{itemize}
}


\newenvironment{cvtabu}[3][1]{
  \begin{tabu} to 0.99\textwidth {X[#2,l] X[#3,r]}
}{
  \end{tabu}
%  \ifnumcomp{#1}{=}{1}{
%  }{}
}

% Subsection environment
% Up to 4 subsection heading inputs
\newenvironment{cvsubsection}[4]{
  \ifblank{#1}{ % 0
    \item
    \nosubheaderafter
  }{
    \ifblank{#3}{
      \item \begin{cvtabu}{1}{1} % 2
        {\bfseries #1} & {\itshape #2}
      \end{cvtabu}
      \subheaderonelineafter
    }{
      \ifblank{#4}{
        \item \begin{cvtabu}{4}{1} % 3
          {\bfseries #1} | {\itshape #2} & {\itshape #3}
        \end{cvtabu}
        \subheaderonelineafter
      }{
        \item \begin{cvtabu}[2]{3}{1} % 4
          {\bfseries #1} & {\itshape #2} \\
          {\itshape #3} & {\itshape #4}
        \end{cvtabu}
        \subheadertwolineafter
      }
    }
  }
  \begin{itemize}[label=\sep,itemsep=\subitemsep]
}{
  \end{itemize}
}

