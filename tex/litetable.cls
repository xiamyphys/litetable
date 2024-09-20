%% ************************************************************************************************************
%% ******************************************************                                                     *
%% * This work may be distributed and/or modified under *           *           *****       *   *             *
%% * the conditions of the LaTeX Project Public License *           *      ** *   *    ***   * *              *
%% *     http://www.latex-project.org/lppl.txt          *           *     *  **   *   *****   *               *
%% * either version 1.3c of this license or any later   *           *     *  **   *   *****   *               *
%% * version.                                           *           *     *  **   *   *      * *              *
%% ******************************************************           *****  ** *   *    ***  *   *             *
%% start of file `litetable.cls'.                                                                             *
%% Copyright 2023-2024 LiteLaTeX (xiamyphys@gmail.com)                                                        *
%% available at https://github.com/xiamyphys/LiteTable                                                        *
% !Mode:: "TeX:UTF-8"                                                                                         *
%% ************************************************************************************************************
\NeedsTeXFormat{LaTeX2e}
\PassOptionsToPackage{quiet}{xeCJK}
\PassOptionsToPackage{no-math}{fontspec}
\ProvidesClass{litetable}[2024/03/03/ v2.4c LiteTable document class]

% ---------- 全局选项 ---------- %
\RequirePackage{kvoptions}
\RequirePackage{etoolbox}
\SetupKeyvalOptions{family=LITE, prefix=LITE@, setkeys=\kvsetkeys}

\DeclareStringOption[portiait]{direction}
\DeclareVoidOption{portiait}{\kvsetkeys{LITE}{direction=portiait}}
\DeclareVoidOption{landscape}{\kvsetkeys{LITE}{direction=landscape}}

\DeclareStringOption[times]{font}
\DeclareVoidOption{times}{\kvsetkeys{LITE}{font=times}}
\DeclareVoidOption{libertinus}{\kvsetkeys{LITE}{font=libertinus}}

\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{standalone}}
\ProcessKeyvalOptions*\relax

\LoadClass[tikz]{standalone}

% ---- 文本中的数字 & 字母设置 ---- %
\RequirePackage{xeCJK}
\setCJKfamilyfont{zhhei}{Heiti SC}
\newcommand*\heiti{\CJKfamily{zhhei}}
\ifdefstring{\LITE@font}{libertinus}{
\RequirePackage{libertine}
}{\relax}
\ifdefstring{\LITE@font}{times}{
\ifXeTeX
  \RequirePackage[no-math]{fontspec}
  \setmainfont{texgyretermes}[
    UprightFont = *-regular ,
    BoldFont = *-bold ,
    ItalicFont = *-italic ,
    BoldItalicFont = *-bolditalic ,
    Extension = .otf ,
    Scale = 1.0]
  \setsansfont{texgyreheros}[
    UprightFont = *-regular ,
    BoldFont = *-bold ,
    ItalicFont = *-italic ,
    BoldItalicFont = *-bolditalic ,
    Extension = .otf ,
    Scale = 0.9]
\else
  \RequirePackage{newtxtext}
  \RequirePackage[scaled=.90]{helvet}
\fi
}{\relax}

% ---------- 色彩组合 ---------- %
\definecolor{darkgray}{HTML}{727477} % 时间颜色
\definecolor{darkergray}{HTML}{F1F3F5} % 深色块
\definecolor{lightergray}{HTML}{FCFDFE} % 浅色块
\definecolor{blackgray}{HTML}{1A1D21} % 序号颜色
\definecolor{SEM}{HTML}{DEEAF8} % 学期按钮
\definecolor{SEM*}{HTML}{3085F3}
\definecolor{SEM**}{HTML}{007DC3}
\pagecolor{lightergray}
\definecolor{H1}{HTML}{74A7A2} % 深绿
\definecolor{H1*}{HTML}{E9EEED}
\definecolor{H1**}{HTML}{009787}
\definecolor{H2}{HTML}{50C9BD} % 浅绿
\definecolor{H2*}{HTML}{E1F3F2}
\definecolor{H2**}{HTML}{009D8F}
\definecolor{H3}{HTML}{86AFFE} % 深蓝
\definecolor{H3*}{HTML}{DBE7FF}
\definecolor{H3**}{HTML}{1663F5}
\definecolor{H4}{HTML}{6BC0EB} % 浅蓝
\definecolor{H4*}{HTML}{D8EFFA}
\definecolor{H4**}{HTML}{0072B1}
\definecolor{H5}{HTML}{D58DFB} % 深紫
\definecolor{H5*}{HTML}{F2E3FB}
\definecolor{H5**}{HTML}{A83FDF}
\definecolor{H6}{HTML}{FF9393} % 浅紫
\definecolor{H6*}{HTML}{FFDEDE}
\definecolor{H6**}{HTML}{E73030}
\definecolor{H7}{HTML}{FFA17D} % 深橙
\definecolor{H7*}{HTML}{F5E1DA}
\definecolor{H7**}{HTML}{E2612F}
\definecolor{H8}{HTML}{F3C06A} % 浅橙
\definecolor{H8*}{HTML}{F3EADB}
\definecolor{H8**}{HTML}{E09B14}
\definecolor{H9}{HTML}{D09966} % 棕色
\definecolor{H9*}{HTML}{F2E0D0}
\definecolor{H9**}{HTML}{C96F1C}
\definecolor{W1}{HTML}{CCAD52}
\definecolor{W2}{HTML}{8FCC52}
\definecolor{W3}{HTML}{52CC70}
\definecolor{W4}{HTML}{52CCCC}
\definecolor{W5}{HTML}{5270CC}
\definecolor{W6}{HTML}{8F52CC}
\definecolor{W7}{HTML}{CC52AD}

\usetikzlibrary{calc}
\ifdefstring{\LITE@direction}{portiait}{
  \def\pagewidth{8.5 in}
  \def\pageheight{-11 in}
  \def\rotatepage{
    \def\pagewidth{11 in}
    \def\pageheight{-8.5 in}
  }
  \def\rerotatepage{
    \def\pagewidth{8.5 in}
    \def\pageheight{-11 in}
  }
}{\relax}

\ifdefstring{\LITE@direction}{landscape}{
  \def\pagewidth{11 in}
  \def\pageheight{-8.5 in}
  \def\rotatepage{
    \def\pagewidth{8.5 in}
    \def\pageheight{-11 in}
  }
  \def\rerotatepage{
    \def\pagewidth{11 in}
    \def\pageheight{-8.5 in}
  }
}{\relax}

\ExplSyntaxOn % 数组
% 1. Set up arrays
\def\definearray#1#2
 {
  \seq_clear_new:c { l__litetable_array_#1_seq }
  \seq_set_split:cnn { l__litetable_array_#1_seq } { ; } { #2 }
 }

\cs_generate_variant:Nn \seq_set_split:Nnn { c }

% 2. Define commands to work with arrays
\NewExpandableDocumentCommand{\arraycount}{ o m }
 {
  \IfNoValueTF { #1 }
     {
      \litetable_array_count_full:n { #2 }
     }
     {
      \litetable_array_count_item:nn { #2 } { #1 }
     }
 }

\cs_new:Nn \litetable_array_count_item:nn
 {
  \clist_count:e { \seq_item:cn { l__litetable_array_#1_seq } { #2 } }
 }

\NewExpandableDocumentCommand{\arrayitem}{ m m m }
 {
  \clist_item:en { \seq_item:cn { l__litetable_array_#1_seq } { #2 } } { #3 }
 }

\ExplSyntaxOff

\NewDocumentCommand{\timelist}{ o m }
{
  \gdef\@timelist{#2}
  \definearray{timelist}{#2}
  \IfNoValueTF{#1}{
    \ifnum \arraycount[2]{timelist}<\arraycount[1]{timelist}
      \def\@classnum{\arraycount[1]{timelist}}
      \else
      \def\@classnum{\arraycount[2]{timelist}}
    \fi
  }{\def\@classnum{#1}}
}
\ifcsname @timelist\endcsname
  \relax
  \else
  \def\@classnum{12}
\fi
\def\weeklist#1{
  \gdef\@weeklist{#1}
  \definearray{weeklist}{#1}
}
\gdef\@weeknum{\arraycount[1]{weeklist}}

\RequirePackage{fontawesome5}
\RequirePackage[hidelinks]{hyperref}
\newcounter{number}
\tikzset{
  hyperlink node/.style={
    alias=sourcenode,
    append after command={
      let \p1 = (sourcenode.north west),
          \p2 = (sourcenode.south east),
          \n1 = {\x2-\x1}, \n2 = {\y1-\y2} in
            node [inner sep=0pt, outer sep=auto, anchor=north west,at=(\p1)]
            {\Acrobatmenu{#1}{\XeTeXLinkBox{\phantom{\rule{\n1}{\n2}}}}}
    }
  }
}
\NewDocumentCommand{\makeframe}{ o m }{
  \draw [lightergray] (0,0) rectangle (\pagewidth,\pageheight);
  \fill [fill=darkergray] (0,0) rectangle (\pagewidth,{1.5*\pageheight/(2*\@classnum+3.5)});% 顶部深灰色块
  \node at (.5*\pagewidth,{.75*\pageheight/(2*\@classnum+3.5)}) {\huge\bfseries\sffamily #2}; % 标题
  \IfNoValueF{#1}{
    \node [outer sep=auto,hyperlink node=NextPage,left,rectangle,fill=SEM,text=SEM*,draw=none,inner sep=1.75ex,rounded corners=6pt] at (.98*\pagewidth,{.75*\pageheight/(2*\@classnum+3.5)}) {\large\sffamily\;$\rightleftharpoons$~#1\;}; % 学期
  }

  \ifodd\@classnum
    \foreach \a in {2,4,...,\@classnum,\@classnum+2}
    \fill [fill=darkergray,yshift=(2*\a-1.5)*\pageheight/(2*\@classnum+3.5)] (0,0) rectangle (\pagewidth,{2*\pageheight/(2*\@classnum+3.5)}); % 中间深灰色块（循环）
    \else
    \foreach \a in {2,4,...,\@classnum}
    \fill [fill=darkergray,yshift=(2*\a-1.5)*\pageheight/(2*\@classnum+3.5)] (0,0) rectangle (\pagewidth,{2*\pageheight/(2*\@classnum+3.5)}); % 中间深灰色块（循环）
    \fill [fill=darkergray,yshift=(2.5+2*\@classnum)*\pageheight/(2*\@classnum+3.5)] (0,0) rectangle (\pagewidth,{\pageheight/(2*\@classnum+3.5)}); % 底部深灰色块
  \fi
  \foreach \a in {0,1,2,...,\@classnum}
    \draw [densely dashed,gray!75,yshift=(2.5+2*\a)*\pageheight/(2*\@classnum+3.5)] (0,0)--(\pagewidth,0); % 分割虚线
    
  % 时间标注
  \setcounter{number}{0}
  \ifcsempty{@timelist}{
    \foreach \a in {1,2,...,\@classnum}
    {
      \node [yshift=(1.5+2*\a)*\pageheight/(2*\@classnum+3.5)] at(\pagewidth/32,0)
      {\bfseries\large\color{blackgray}\texttt{\refstepcounter{number}\thenumber}};
    }
  }{
    \foreach \x in {1,2,...,\@classnum}
      {
        \node [yshift=(2*\x+.9)*\pageheight/(2*\@classnum+3.5)] at (\pagewidth/32,0)
        {\bfseries\color{blackgray}\texttt{\refstepcounter{number}\thenumber}};
        \node[yshift=(2*\x+1.55)*\pageheight/(2*\@classnum+3.5)] at (\pagewidth/32,0)
        {\color{darkgray}\texttt{\arrayitem{timelist}{1}{\x}}};
        \node[yshift=(2*\x+2.1)*\pageheight/(2*\@classnum+3.5)] at (\pagewidth/32,0)
        {\color{darkgray}\texttt{\arrayitem{timelist}{2}{\x}}};
    }
  }

  % 星期标注
  \foreach \a in {1,2,...,\@weeknum}
      \node [xshift=\pagewidth/16] at ({.5*(\arrayitem{weeklist}{2}{\a}+\arrayitem{weeklist}{2}{\a+1})*15*\pagewidth/16},{2*\pageheight/(2*\@classnum+3.5)})
      {\arrayitem{weeklist}{1}{\a}};

  \ifcsname @sticker\endcsname
    \node [opacity=.3,above left,yshift=(1.5+2*\@classnum)*\pageheight/(2*\@classnum+3.5),inner sep=0pt,outer sep=auto,scale=15] at (\pagewidth,{\pageheight/(2*\@classnum+3.5)}) {\includegraphics[width=\dimeval{\pagewidth/16/\@weeknum}]{\@sticker}};\fi
}

\newcounter{weekday}
\def\newday{\addtocounter{weekday}{1}}
\AtEndEnvironment{tikzpicture}{\setcounter{weekday}{0}}
\def\sticker#1{\gdef\@sticker{#1}}
\def\corner#1{\gdef\@corner{#1}}
\def\weeks#1{\gdef\@weeks{#1}}

\NewDocumentCommand{\course}{O{H1} m m m m m O{\@weeks}}
{
  \ifcsname @corner\endcsname
    \tikzset{corner/.style={rounded corners=\@corner}}
  \else
    \tikzset{corner/.style={}}
  \fi
  \fill [#1,corner,
  yshift=(2*(#2-1))*\pageheight/(2*\@classnum+3.5),
  xshift=\pagewidth/16]
  ({\arrayitem{weeklist}{2}{\theweekday+1}*15*\pagewidth/16},{2.5*\pageheight/(2*\@classnum+3.5)}) rectangle ++
  ({(\arrayitem{weeklist}{2}{\theweekday+2}-\arrayitem{weeklist}{2}{\theweekday+1})*15*\pagewidth/16},{(2+2*(#3-#2))*\pageheight/(2*\@classnum+3.5)}); % frame

  \fill [#1*,
  yshift=(2*(#2-1)+.5)*\pageheight/(2*\@classnum+3.5),
  xshift=\pagewidth/16]
  ({\arrayitem{weeklist}{2}{\theweekday+1}*15*\pagewidth/16},{2.5*\pageheight/(2*\@classnum+3.5)}) --++
  ({(\arrayitem{weeklist}{2}{\theweekday+2}-\arrayitem{weeklist}{2}{\theweekday+1})*15*\pagewidth/16},0) 
  { [corner] --++ (0,{(1.5+2*(#3-#2))*\pageheight/(2*\@classnum+3.5)}) --++
  ({(-\arrayitem{weeklist}{2}{\theweekday+2}+\arrayitem{weeklist}{2}{\theweekday+1})*15*\pagewidth/16},0)} -- cycle; % content
  
  \node [#1**,yshift=(#2+#3-1.25)*\pageheight/(2*\@classnum+3.5),
  xshift=\pagewidth/16] at
  ({.5*(\arrayitem{weeklist}{2}{\theweekday+1}+\arrayitem{weeklist}{2}{\theweekday+2})*15*\pagewidth/16},{2.5*\pageheight/(2*\@classnum+3.5)})
  {\heiti\large\bfseries #4}; % course

  \node [#1**,above,
  yshift=(#2+#3-.2)*\pageheight/(2*\@classnum+3.5),
  xshift=\pagewidth/16] at
  ({.5*(\arrayitem{weeklist}{2}{\theweekday+1}+\arrayitem{weeklist}{2}{\theweekday+2})*15*\pagewidth/16},{2.5*\pageheight/(2*\@classnum+3.5)})
  {\heiti\bfseries\small #5}; % location

  \node [#1**,below,
  yshift=(#2+#3-.2)*\pageheight/(2*\@classnum+3.5),
  xshift=\pagewidth/16] at
  ({.5*(\arrayitem{weeklist}{2}{\theweekday+1}+\arrayitem{weeklist}{2}{\theweekday+2})*15*\pagewidth/16},{2.5*\pageheight/(2*\@classnum+3.5)})
  {\heiti\bfseries\small #6}; % teacher

  \ifcsname @weeks\endcsname
  \node [#1**,above left,
  yshift=2*#3*\pageheight/(2*\@classnum+3.5),
  xshift=\pagewidth/16] at
  ({\arrayitem{weeklist}{2}{\theweekday+2}*15*\pagewidth/16},{2.5*\pageheight/(2*\@classnum+3.5)})
  {\heiti\footnotesize #7};
  \fi % weeks
}

\def\more#1{
  \node [xshift=-1em,yshift=(2.5+2*\@classnum)*\pageheight/(2*\@classnum+3.5),left] at (\pagewidth,{.5*\pageheight/(2*\@classnum+3.5)}){\small\bfseries\color{darkgray}#1};
}