%%------------------------------------------------------------------------------
%%
%%  Resume Template in LaTeX
%%  Name: cvtemplate.cls
%%  Author: Ethan Hu
%%  Built in: LuaTeX
%%  Last Updated: 2021/08/06
%%
%%--------------------------------------------------------------------

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{cvtemplate}[2021/08/06 Resume Template]

\RequirePackage{xkeyval} % key-value macros
\RequirePackage{etoolbox} % robust commands, macros, booleans, tests

\newbool{fitpagebool}
\newbool{framepagebool}

%% Options
\DeclareOptionX{fontsize}[10pt]{\def\@fontsize{#1}}
\DeclareOptionX{fontface}[cormorantgaramond]{\def\@fontface{#1}}
\DeclareOptionX{margin}[0.5in]{\def\@margins{margin={#1}}}
\DeclareOptionX{fitpage}[true]{\setbool{fitpagebool}{#1}}
\DeclareOptionX{framepage}[true]{\setbool{framepagebool}{#1}}
\ExecuteOptionsX{fontsize,fontface,margin}
\DeclareOptionX*{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOptionX*{\ClassWarning{cvtemplate}{'\CurrentOption':Unknown}}
\ProcessOptionsX*

\LoadClass[\@fontsize]{article}

\RequirePackage{ulem} % underlining without disruption
\RequirePackage{array} % tabular and array environments
\RequirePackage{substr} % substring manipulation
\RequirePackage{environ} % allows use of macros on entire body of environment
\RequirePackage{multicol} % Enables multicolumn tables
\RequirePackage{enumitem} % itemized lists
\RequirePackage{scalerel} % scaling and stretching of objects
\RequirePackage{fontspec} % set new font faces
\RequirePackage{stackengine} % customized object stacking
\RequirePackage{fontawesome5} % icons and logos
\RequirePackage[nomessages]{fp} % fixed point arithmetic
\RequirePackage[empty]{fullpage} % suppresses page numbers and headers/footersm
\RequirePackage[parfill]{parskip} % removes paragraph indent and sets spacing
\RequirePackage[svgnames]{xcolor} % text colors and color names
\RequirePackage[\@margins]{geometry} % set page margins
\RequirePackage[ocgcolorlinks]{hyperref} % web links and pdf configuration

%%--------------------------------------------------------------------
%%  CONSTANTS
%%----------------------------------------------------------

%% Header
\def\nameform         {\huge\scshape}
\def\contform         {\normalsize\upshape}
\def\addressicon      {\faMapMarker*~}
\def\phoneicon        {\faPhone*~}
\def\websiteicon      {\faGlobeAmericas~}
\def\emailicon        {\faEnvelope~}
\def\githubicon       {\faGithub~}
\def\linkedinicon     {\faLinkedin~}
\def\namespace        {\smallskip}
\def\contsep          {~|~}
\def\pgheaderspace    {\vspace{1pt}}
\newbool{icons}

%% Sections
\def\secheaderform    {\large\scshape}
\def\subheaderform    {\small\bfseries}
\def\subsubheaderform {\small\itshape}
\def\subdateform      {\small\bfseries}
\def\sublocationform  {\small\itshape}
\def\listitemform     {\small\upshape}
\def\descitemform     {\small\upshape}
\def\secheaderspace   {\smallskip}
\def\seclinespace     {\medskip}
\def\secendspace      {\smallskip}
\def\subheaderspace   {\vspace{1pt}}
\def\subitemsep       {3pt}
\def\resumeitemsep    {0pt}

%% Other
\def\norms{\normalsize}

%%----------------------------------------------------------
%%  DOCUMENT CONFIGUATION
%%----------------------------

%% Set Font Face
\setmainfont{\@fontface}

%% Global List Settings
\setlist{%
  noitemsep,%
  leftmargin=0pt,%
  topsep=-1\parskip%
}
\setlist[description]{%
  itemsep=\subitemsep%
}
\setlist[itemize]{%
  label=\textbullet,%
  format=\listitemform,%
  itemsep=\resumeitemsep%
}

%% Reference Settings
\hypersetup{
  allcolors=DarkBlue,
  pdfauthor={EthanHu},
  pdftitle={EthanHuResume}
  pdfpagelayout=SinglePage,
  pdfpagemode=FullScreen,
  pdfdisplaydoctitle,
  pdfstartview=Fit,
  pdflang={en-US},
  debug=true,
  final
}

%%----------------------------------------------------------
%%  AUTO-SIZE PAGE FUNCTION
%%----------------------------

%% Variables
\newsavebox\cvbox
\newcount\cvboxwidth
\newcount\cvboxheight
\environbodyname\cvbody
\newlength\currtextwidth
\newlength\decrtextwidth
\newcounter{iter}

%% Aspect Ratio
%% find and save aspect ratio of input box
%% [1]: {<inputBox>}
\newrobustcmd*{\findaspect}[1]{%
  \cvboxwidth=\wd#1\relax%
  \cvboxheight=\ht#1\relax%
  \FPdiv\curraspect{\the\cvboxwidth}{\the\cvboxheight}%
}

%% Resume Text Environ
%% applies box found by findbox to all resume text
\NewEnviron{cvtext}{%
  \ifbool{fitpagebool}{%
    \setlength{\fboxsep}{-1\fboxrule}
    \setlength{\decrtextwidth}{0.01\textwidth}%
    \setlength{\currtextwidth}{1.1\textwidth}%
    \sbox{\cvbox}{\rule{\textwidth}{\textheight}}%
    \findaspect{\cvbox}%
    \edef\targaspect{\curraspect}%
    \findbox{\targaspect}{\currtextwidth}{\textheight}{\decrtextwidth}{\cvbody}
  }{%
    \cvbody%
  }%
}

%% Find Box
%% finds box size that meets original aspect ratio, scale to height
%% [5]: {<targAspect>} {<startWidth>} {<targHeight>} {<decrWidth>} {<targText>}
\newrobustcmd*{\findbox}[5]{%
  \stepcounter{iter}%
  \sbox{\cvbox}{\fbox{\parbox[b]{#2}{#5}}}%
  \findaspect{\cvbox}%
  \FPifgt{\curraspect}{#1}%
    \setlength{\currtextwidth}{#2}%
    \addtolength{\currtextwidth}{-#4}%
    \findbox{#1}{\currtextwidth}{#3}{#4}{#5}%
  \else%
    \ifbool{framepagebool}{%
      \framebox[#1#3]{%
        \hfil{\scaleto{\parbox[t]{#2}{#5}}{#3}}\hfil}%
    }{%
      \makebox[#1#3]{%
        \hfil{\scaleto{\parbox[t]{#2}{#5}}{#3}}\hfil}%
    }%

  \fi%
}

%%--------------------------------------------------------------------
%%  SECTION COMMANDS
%%----------------------------------------------------------

%% Variables
\let\@address\relax
\let\@website\relax
\let\@email\relax
\let\@phone\relax
\let\@github\relax
\let\@linkedin\relax

%% Set Applicant Info
\newrobustcmd*{\name}[1]{\notblank{#1}{\def\@name{#1}}{}}
\newrobustcmd*{\phone}[1]{\notblank{#1}{\def\@phone{#1}}{}}
\newrobustcmd*{\address}[1]{\notblank{#1}{\def\@address{#1}}{}}
\newrobustcmd*{\website}[1]{\notblank{#1}{\def\@website{#1}}{}}
\newrobustcmd*{\email}[1]{\notblank{#1}{\def\@email{#1}}{}}
\newrobustcmd*{\github}[1]{\notblank{#1}{\def\@github{#1}}{}}
\newrobustcmd*{\linkedin}[1]{\notblank{#1}{\def\@linkedin{#1}}{}}

%% Print Name
\newrobustcmd*{\printname}{%
  \begin{centering}%
    \hfil{\nameform\@name}\hfil%
    \namespace\break%
  \end{centering}%
}

%% Print Contact
%% print contact with format, icon, ref supplied by arguments
%% [4]: {<contactFormat>} {<contactIcon>} {<contactItem>} {<contactSepSpace>}
\newrobustcmd*{\printcontact}[4]{%
  \ifundef{#3}{}{%
    \ifbool{icons}{
      \IfSubStringInString{@}{#3}{%
        {#1#2\href{mailto:#3}{#3}#4}%
      }{%
        \IfSubStringInString{.com}{#3}{%
          {#1#2\href{https://#3}{#3}#4}%
        }{%
          {#1#2#3#4}%
        }%
      }%
    }{%
      \IfSubStringInString{@}{#3}{%
        {#1\href{mailto:#3}{#3}#4}%
      }{%
        \IfSubStringInString{.com}{#3}{%
          {#1\href{https://#3}{#3}#4}%
        }{%
          {#1#3#4}%
        }%
      }%
    }%
  }
}

%% Print Page Header
%% prints page header with specified number of columns
%% [1]: {<numberColumns>}
\newrobustcmd*{\printcvheader}[1]{%
  \ifnumcomp{#1}{>}{1}{%
    \begin{center}%
      \begin{multicols}{#1}[\printname]%
        \printcontact{\contform}{\phoneicon}{\@phone}{}%
        \printcontact{\contform}{\addressicon}{\@address}{}%
        \printcontact{\contform}{\websiteicon}{\@website}{}%
        \printcontact{\contform}{\emailicon}{\@email}{}%
        \printcontact{\contform}{\githubicon}{\@github}{}%
        \printcontact{\contform}{\linkedinicon}{\@linkedin}{}%
      \end{multicols}%
    \end{center}%
  }{%
    \printname%
    \centerline{%
      \printcontact{\contform}{\phoneicon}{\@phone}{\contsep}%
      % \printcontact{\contform}{\addressicon}{\@address}{\contsep}%
      % \printcontact{\contform}{\websiteicon}{\@website}{\contsep}%
      \printcontact{\contform}{\emailicon}{\@email}{\contsep}%
      % \printcontact{\contform}{\githubicon}{\@github}{\contsep}%
      \printcontact{\contform}{\linkedinicon}{\@linkedin}{}%
    }%
  }%
  \pgheaderspace%
}

%%----------------------------------------------------------
%% SECTION
%%----------------------------

%% Section Environment
%% defines section environment, contains formatted subsections and resume items
%% [1]: {<sectionName>}
\newenvironment*{cvsection}[1]{%
  {\secheaderform#1}%
  \secheaderspace%
  \hrule\seclinespace%
  \begin{description}%
}{%
  \end{description}%
  \secendspace%
}

%%----------------------------------------------------------
%% SUBSECTION
%%----------------------------

%% Subsection Environment
%% defines subsection environment, contains formatted subheaders and resumeitems
%% [4]: {<subHeader>} {<subSubHeader>} {<subDate>} {<subLocation>}
\newenvironment*{cvsubsection}[4]{%
  \notblank{#4}{%
    \item[\subheaderform#1]\hfill{\subdateform#2}\\
    {\subsubheaderform#3}\hfill{\sublocationform#4}%
  }{%
    \notblank{#3}{%
      \item[\subheaderform#1]|~~{\subsubheaderform#2}\hfill{\subdateform#3}%
    }{%
      \item[\subheaderform#1]\hfill{\subdateform#2}%
    }%
  }%
  \subheaderspace%
  \begin{itemize}%
}{%
  \end{itemize}%
}

%%----------------------------------------------------------
%% LIST ITEMS
%%----------------------------

%% List/Desc Items
%% applies list item formats to resume items
\newrobustcmd*{\listitem}[1]{\listitemform\item#1}
\newrobustcmd*{\descitem}[1]{\descitemform\item#1}

%%--------------------------------------------------------------------

%%
%% Vertical Spacing Notes
%%    Package parskip
%%      parskip package sets \parindent = 0, \parskip = 0.5\baselineskip +/- 2
%%      parfill option sets \parfillskip = 30pt
%%      Also sets list \itemsep, \topsep, \partopsep = 0, \parsep = \parskip
%%    Package enumitem
%%      setlist{} noitemsep option kills all space between list items and par
%%      \itemsep, \parsep, \topsep, \parskip, \partopsep = 0
%%      nosep option kills all vertical spacing
%%
%% Additional Icons
%%    phone:    \faPhone(*),\faMobile(*)
%%    address:  \faMapMarker(*),\faMapPin
%%    website:  \faGlobe, \faGlobeAsia, \faGlobeEurope, \faGlobeAfrica
%%    email:    \faEnvelope,\faEnvelope[regular]
%%    github:   \faGithub(*),\faGit,\faGitSquare
%%    linkedin: \faLinkedin,\faLinkedinIn
%%

%%------------------------------------------------------------------------------