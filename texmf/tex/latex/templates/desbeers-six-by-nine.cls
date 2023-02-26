%!TEX program = lualatex
%!TEX encoding = UTF-8 Unicode
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{desbeers-six-by-nine}[Make book template]
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{memoir}}
\ProcessOptions\relax
\LoadClass[openright]{memoir}
% [showtrims] is an option, showing the trims.

%%% PACKAGES
% -------------------------------------------------
% grapicx: for image handling.
% etoolbox: for disabling microsetup for verbatim.
% fontspec: use TTF fonts; used for drop-caps.
% caption: captions underneath images.
% float: exact image positioning
% soul: underlining, striking out, etc...
\RequirePackage{graphicx,etoolbox,fontspec,caption,float,soul}

% Configure the caption of images
\DeclareCaptionFormat{custom}
{
    \small #3
}
\captionsetup{format=custom}

% Override default figure placement
% To be within the flow of the text rather than on it's own page.
\makeatletter
\def\fps@figure{H} 
\makeatother

%%% PAGE DIMENSIONS
% -------------------------------------------------
% Class 'ebook' from Memoir is 9 x 6 inches; now only set the margins.
\setlrmarginsandblock{21mm}{13mm}{*}
\setulmarginsandblock{15mm}{25mm}{*}
\sloppybottom
\checkandfixthelayout 

%%% TYPOGRAPHY
% -------------------------------------------------
\RequirePackage[activate={true,nocompatibility},final,tracking=true,factor=1100,stretch=20,shrink=20,]{microtype}
% No funny stuff with small caps and code blocks.
\SetTracking{encoding={*}, shape=sc}{0}
\AtBeginEnvironment{verbatim}{\microtypesetup{activate=false}}

%%% CODE BLOCKS
% -------------------------------------------------
% Small type for code block.
\makeatletter
\patchcmd{\@verbatim}
  {\verbatim@font}
  {\verbatim@font\small}
  {}{}
\makeatother
% Move code block a bit.
\newlength\myverbindent 
\setlength\myverbindent{1.4em} % change this to change indentation
\makeatletter
\def\verbatim@processline{%
  \hspace{\myverbindent}\the\verbatim@line\par}
\makeatother

%%% Colours (for PDF)
% -------------------------------------------------
\RequirePackage{xcolor}
\definecolor{pagecolour}{HTML}{F9F3E9}
\definecolor{textcolour}{HTML}{422B19}
\definecolor{linkcolour}{HTML}{5281C5}

%%% TOC APPEARANCE
% -------------------------------------------------
\maxtocdepth{chapter}
\setlength\cftbooknumwidth{3em}
\setlength\cftpartnumwidth{2em}
\renewcommand{\cftpartfont}{}
\renewcommand{\cftpartpagefont}{}
\renewcommand{\cftchapterpagefont}{}
\renewcommand{\cftchapterfont}{}     % no bold!
\setsecnumdepth{chapter}
\setlength\cftchapternumwidth{2em}
\setlength{\cftbeforebookskip}{2em}
\setlength{\cftbeforepartskip}{0.5em}
\setlength{\cftbeforechapterskip}{0.5em}
% No \book numbers.
\renewcommand{\booknumberline}[1]{}
% No \part numbers.
\renewcommand{\partnumberline}[1]{}
% No \chapter numbers.
\renewcommand{\chapternumberline}[1]{}
% Uppercase \part. See Memoir manual page 158.
\makeatletter
\settocpreprocessor{part}{%
  \let\tempf@rtoc\f@rtoc%
  \def\f@rtoc{%
      \texorpdfstring{\MakeTextUppercase{\tempf@rtoc}}{\tempf@rtoc}}%
}
\makeatother

%%% HYPERLINKS
% -------------------------------------------------
% See https://tex.stackexchange.com/questions/50747/options-for-appearance-of-links-in-hyperref
% Without the pdfencoding option special characters are screwed...
% linkcolor = table of content. I keep them black because they are ugly.
% urlcolor = links to websites.
\RequirePackage[pdfcreator=Pandoc,pdfencoding=auto,colorlinks=true,linkcolor=black,urlcolor=linkcolour,pdfusetitle]{hyperref}
% Move bookmarks, must go after hyperref. Needed, or else TOC is a mess.
\RequirePackage{bookmark}

%%% COUNTERS
% -------------------------------------------------
\counterwithin*{chapter}{part} % Reset chapter count at the start of a new part
\counterwithin*{part}{book} % Reset part count at the start of a new part
\counterwithin*{chapter}{book}
% This is needed else hyperref does not work
\renewcommand*{\theHchapter}{\thepart.\thebook.\thechapter}

%%% HEADERS & FOOTERS
% -------------------------------------------------
\pagestyle{plain}
% Small type for page number
\makeevenfoot{plain}{}{\scriptsize\thepage}{}
\makeoddfoot{plain}{}{\scriptsize\thepage}{}

%%% \book and \parts
% -------------------------------------------------
%% book
\renewcommand{\printbookname}{}  % Eliminates "Book" from \book page
\renewcommand{\printbooknum}{}   % Eliminates number from \book page
%% part
\renewcommand{\printpartname}{}  % Eliminates "Part" from \part page
\renewcommand{\printpartnum}{}   % Eliminates number from \part page
% Allow text on the part page
\makeatletter
   \renewcommand*{\beforepartskip}{\cleardoublepage\null\vskip1cm}
   \renewcommand*{\afterpartskip}{\par\vskip1cm%
     \@afterindentfalse\@afterheading}
 \makeatother

%%% CHAPTERS
% -------------------------------------------------
% Chapters are '#' in Markdown.
%
% Style can be overwritted by the Pandoc template
% with 'chapter-style: plain' or any other style
% avaiable in the Memoir class.
%
% The default:
\chapterstyle{thatcher}
\renewcommand{\printchaptername}{\centering{\chapnumfont\thechapter}}
  \renewcommand*{\afterchapternum}{%
    \par\centerline{\parbox{0.5in}{\hrulefill}}\par}
\setlength{\afterchapskip}{\baselineskip}
% Very plain:
\makechapterstyle{plain}{%
  \chapterstyle{thatcher}  
  \renewcommand{\printchaptername}{\centering{\chapnumfont\thechapter}}
  \renewcommand*{\afterchapternum}{}
  \renewcommand*{\printchaptername}{}
  \renewcommand*{\chapterheadstart}{\vspace*{1\baselineskip}}
  \setlength{\afterchapskip}{\baselineskip}}

%%% SECTIONS
% -------------------------------------------------
% Sections are ## 
\setsecheadstyle{\noindent\scshape\raggedright}
% Subsection ###
\setsubsecheadstyle{\noindent\textnormal\raggedright}
% Header ###### used as \chapterprecise
\renewcommand{\subparagraph}[1]{%
  {\small\scshape\centering{#1}\par}}

%%% IMAGES
% -------------------------------------------------
\graphicspath{{.}}
% Below is to keep aspect ratio when only 'width' is given.
\setkeys{Gin}{keepaspectratio}

%%% Drop Caps
% -------------------------------------------------
\RequirePackage{lettrine}
\setcounter{DefaultLines}{2}
\newfontfamily\DropCaps{Great Vibes}
\renewcommand{\LettrineFontHook}{\DropCaps}
\renewcommand{\DefaultOptionsFile}{GreatVibes.cfl}
\setlength{\parindent}{0.5cm}
\renewcommand*{\DefaultLhang}{0}
\renewcommand*{\DefaultLoversize}{0.4}
\renewcommand*{\DefaultLraise}{0.2}
\setlength{\DefaultFindent}{0.6em}

%%% Cover on first page
% -------------------------------------------------
\RequirePackage[pages=some]{background}
\backgroundsetup{
scale=1,
color=black,
opacity=1,
angle=0,
contents={%
  \includegraphics[width=\paperwidth,height=\paperheight]{assets/cover-screen}
  }%
}

