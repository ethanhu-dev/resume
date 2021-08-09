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

\newbool{fitbool}
\newbool{framebool}
\newbool{iconbool}

%% Options
\DeclareOptionX{fsize}[10pt]{\def\@fsize{#1}}
\DeclareOptionX{fstyle}[cormorantgaramond]{\def\@fstyle{#1}}
\DeclareOptionX{marg}[0.5in]{\def\@marg{margin=#1}}
\DeclareOptionX{fit}[true]{\setbool{fitbool}{#1}}
\DeclareOptionX{frame}[true]{\setbool{framebool}{#1}}
\DeclareOptionX{icon}[true]{\setbool{iconbool}{#1}}

%% Default Options
\ExecuteOptionsX{fsize,fstyle,marg}

\DeclareOptionX*{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOptionX*{\ClassWarning{cvtemplate}{Unknown option: '\CurrentOption'}}
\ProcessOptionsX*

\LoadClass[\@fsize]{article}

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
\RequirePackage[\@marg]{geometry} % set page margins
\RequirePackage[ocgcolorlinks]{hyperref} % web links and pdf configuration

%%--------------------------------------------------------------------
%%  CONSTANTS
%%----------------------------------------------------------

%% Text Formats
\def\nameform         {\huge\scshape}
\def\contform         {\large\upshape}

\def\secheaderform    {\large\scshape}
\def\subheaderform    {\norms\bfseries}
\def\subsubheaderform {\norms\itshape}
\def\subdateform      {\norms\bfseries}
\def\sublocationform  {\norms\itshape}
\def\listitemform     {\norms\upshape}
\def\descitemform     {\norms\upshape}

%% Spacing
\def\nameskip         {\smallskip}
\def\headerskip       {\medskip}
\def\contsep          {\enspace\;}
\def\noiconsep        {\;\textbullet\;}

\def\secheaderskip    {\smallskip}
\def\seclineskip      {\medskip}
\def\secendskip       {\medskip}
\def\subheaderskip    {\vspace{1pt}}
\def\subitemsep       {0pt}
\def\cvitemsep        {0pt}

%% icon
\def\addressicon      {\raisebox{-0.1\height}{\faMapMarker*}\:}
\def\phoneicon        {\raisebox{-0.1\height}{\faPhone*}\:}
\def\websiteicon      {\raisebox{-0.1\height}{\faGlobeAmericas}\:}
\def\emailicon        {\raisebox{-0.1\height}{\faEnvelope}\:}
\def\githubicon       {\raisebox{-0.1\height}{\faGithub}\:}
\def\linkedinicon     {\raisebox{-0.1\height}{\faLinkedin}\:}


%% Other
\def\norms{\normalsize}

%%----------------------------------------------------------
%%  DOCUMENT CONFIGUATION
%%----------------------------

%% Set Font Face
\setmainfont{\@fstyle}

%% Global List Settings
\setlist{%
  leftmargin=0pt,%
}
\setlist[description]{%
  itemsep=\subitemsep%
}
\setlist[itemize]{%
  label=\textbullet,%
  format=\listitemform,%
  itemsep=\cvitemsep%
}

% Paragraph Spacing
\setlength{\parskip}{0pt}

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
  \ifbool{fitbool}{%
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
    \ifbool{framebool}{%
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

%% Set Info If Not Blank
\def\name#1{\notblank{#1}{\def\@name{#1}}{}}
\def\phone#1{\notblank{#1}{\def\@phone{\mbox{#1}}}{}}
\def\address#1{\notblank{#1}{\def\@address{#1}}{}}
\def\website#1{\notblank{#1}{\def\@website{#1}}{}}
\def\email#1{\notblank{#1}{\def\@email{#1}}{}}
\def\github#1{\notblank{#1}{\def\@github{#1}}{}}
\def\linkedin#1{\notblank{#1}{\def\@linkedin{#1}}{}}

%% Print CV Contact
%% print contact with format, icon, ref supplied by arguments if defined
%% [5]: {<linkOption>} {<contForm>} {<contIcon>} {<contItem>} {<contSep>}
\newrobustcmd*{\cvcontact}[5][]{%
  \ifundef{#4}{}{%
    \ifbool{iconbool}{}{%
      \def\contsep{\noiconsep}%
      \def#3{}%
    }%
    \notblank{#1}{%
      \IfSubStringInString{@}{#4}{%
        {#2#3\href{mailto:#4}{#4}#5}%
      }{%
        {#2#3\href{https://#4}{#4}#5}%
      }%
    }{%
      {#2#3#4#5}%
    }%
  }%
}

%% Print CV Name
\newrobustcmd*{\cvname}{%
  \begin{centering}%
    \hfil{\nameform\@name}\hfil%
    \nameskip\par%
  \end{centering}%
}

%% Print CV Header
%% prints formatted page header
\newrobustcmd*{\cvheader}{%
  \cvname%
  \centerline{%
    \cvcontact{\contform}{\phoneicon}{\@phone}{\contsep}%
    \cvcontact{\contform}{\addressicon}{\@address}{\contsep}%
    \cvcontact[l]{\contform}{\websiteicon}{\@website}{\contsep}%
    \cvcontact[l]{\contform}{\emailicon}{\@email}{\contsep}%
    \cvcontact[l]{\contform}{\githubicon}{\@github}{}%
    \cvcontact[l]{\contform}{\linkedinicon}{\@linkedin}{}%
  }\headerskip%
}

%%----------------------------------------------------------
%% SECTION
%%----------------------------

%% CV Section Environment
%% defines section environment, contains formatted subsections and resume items
%% [1]: {<sectionName>}
\newenvironment*{cvsection}[1]{%
  {\secheaderform#1}%
  \secheaderskip%
  \hrule\seclineskip%
  \begin{description}%
}{%
  \end{description}%
  \secendskip%
}

%%----------------------------------------------------------
%% SUBSECTION
%%----------------------------

%% CV Subsection Environment
%% defines subsection environment, contains formatted subheaders and resumeitems
%% [4]: {<subHeader>} {<subSubHeader>} {<subDate>} {<subLocation>}
\newenvironment*{cvsubsection}[4]{%
  \notblank{#4}{%
    \item[\subheaderform#1]\hfill{\subdateform#2}\\
    {\subsubheaderform#3}\hfill{\sublocationform#4}%
  }{%
    \notblank{#3}{%
      \item[\subheaderform#1]|\;\;{\subsubheaderform#2}\hfill{\subdateform#3}%
    }{%
      \item[\subheaderform#1]\hfill{\subdateform#2}%
    }%
  }\subheaderskip%
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
%% Additional icon
%%    phone:    \faPhone(*),\faMobile(*)
%%    address:  \faMapMarker(*),\faMapPin
%%    website:  \faGlobe, \faGlobeAsia, \faGlobeEurope, \faGlobeAfrica
%%    email:    \faEnvelope,\faEnvelope[regular]
%%    github:   \faGithub(*),\faGit,\faGitSquare
%%    linkedin: \faLinkedin,\faLinkedinIn
%%

%%------------------------------------------------------------------------------