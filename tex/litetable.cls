%% ************************************************************************************************************
%% ******************************************************                                                     *
%% * This work may be distributed and/or modified under *           *           *****       *   *             *
%% * the conditions of the LaTeX Project Public License *           *      ** *   *    ***   * *              *
%% *     http://www.latex-project.org/lppl.txt          *           *     *  **   *   *****   *               *
%% * either version 1.3c of this license or any later   *           *     *  **   *   *****   *               *
%% * version.                                           *           *     *  **   *   *      * *              *
%% ******************************************************           *****  ** *   *    ***  *   *             *
%% start of file `litetable.cls'.                                                                             *
%% Copyright 2023 LiteLaTeX (xiamyphys@gmail.com)                                                             *
%% available at https://github.com/xiamyphys/LiteTable                                                        *
%% !Mode:: "TeX:UTF-8"                                                                                        *
%% ************************************************************************************************************
\NeedsTeXFormat{LaTeX2e}
\PassOptionsToPackage{quiet}{xeCJK}
\PassOptionsToPackage{quiet}{fontspec}
\PassOptionsToPackage{no-math}{fontspec}
\ProvidesClass{litetable}[2024/01/31/ v2.2a LiteTable document class]

% ---------- 全局选项 ---------- %
\RequirePackage{kvoptions}
\RequirePackage{etoolbox}
\SetupKeyvalOptions{family=LITE, prefix=LITE@, setkeys=\kvsetkeys}
\newcommand{\ekv}[1]{\kvsetkeys{LITE}{#1}}

\DeclareStringOption[sharp]{style}
\DeclareVoidOption{round}{\ekv{style=round}}
\DeclareVoidOption{sharp}{\ekv{style=sharp}}

\DeclareStringOption[en]{date}
\DeclareVoidOption{en}{\ekv{date=en}}
\DeclareVoidOption{cn}{\ekv{date=cn}}

\DeclareStringOption[times]{font}
\DeclareVoidOption{times}{\ekv{date=times}}
\DeclareVoidOption{libertinuTs}{\ekv{date=libertinus}}

\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{standalone}}
\ProcessKeyvalOptions*\relax
\LoadClass[tikz,margin=6pt]{standalone}

% ---- 文本中的数字 & 字母设置 ---- %
\RequirePackage{ctex}
\ifdefstring{\LITE@font}{libertinus}{
\setmainfont{Libertinus Serif}
\setsansfont{Libertinus Sans}
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
\definecolor{darkgray}{HTML}{727477}% 时间颜色
\definecolor{darkergray}{HTML}{F1F3F5}% 深色块
\definecolor{lightergray}{HTML}{FCFDFE}% 浅色块
\definecolor{blackgray}{HTML}{1A1D21}% 序号颜色
\definecolor{H1}{HTML}{74A7A2}% 深绿
\definecolor{H1*}{HTML}{E9EEED}
\definecolor{H1**}{HTML}{009787}
\definecolor{H2}{HTML}{50C9BD}% 浅绿
\definecolor{H2*}{HTML}{E1F3F2}
\definecolor{H2**}{HTML}{009D8F}
\definecolor{H3}{HTML}{86AFFE}% 深蓝
\definecolor{H3*}{HTML}{DBE7FF}
\definecolor{H3**}{HTML}{1663F5}
\definecolor{H4}{HTML}{6BC0EB}% 浅蓝
\definecolor{H4*}{HTML}{D8EFFA}
\definecolor{H4**}{HTML}{0072B1}
\definecolor{H5}{HTML}{D58DFB}% 深紫
\definecolor{H5*}{HTML}{F2E3FB}
\definecolor{H5**}{HTML}{A83FDF}
\definecolor{H6}{HTML}{FF9393}% 浅紫
\definecolor{H6*}{HTML}{FFDEDE}
\definecolor{H6**}{HTML}{E73030}
\definecolor{H7}{HTML}{FFA17D}% 深橙
\definecolor{H7*}{HTML}{F5E1DA}
\definecolor{H7**}{HTML}{E2612F}
\definecolor{H8}{HTML}{F3C06A}% 浅橙
\definecolor{H8*}{HTML}{F3EADB}
\definecolor{H8**}{HTML}{E09B14}
\definecolor{H9}{HTML}{D09966}% 棕色
\definecolor{H9*}{HTML}{F2E0D0}
\definecolor{H9**}{HTML}{C96F1C}
\pagecolor{lightergray}
\definecolor{丹色}{HTML}{E45E32}
\definecolor{紅緋}{HTML}{E83929}
\definecolor{紺碧}{HTML}{007BBB}
\definecolor{青碧}{HTML}{478384}
\definecolor{金色}{HTML}{E6B422}

\def\pagewidth{8.5 in}
\def\pageheight{-11 in}
\usetikzlibrary{calc}
\ifdefstring{\LITE@style}{round}{\def\corners{round corners=6pt}}{\relax}
\ifdefstring{\LITE@style}{sharp}{\def\corners{}}{\relax}

\ExplSyntaxOn % 二维数组
\seq_new:N \l_node_row_seq  
\seq_new:N \l_node_tmp_seq 
\cs_set:Npn \timelist #1 {
  \gdef\@timelist{#1} % 用于判断\@timelist是否存在
  \seq_set_split:Nnn \l_node_row_seq {;} {#1}
  \int_step_inline:nn{\seq_count:N \l_node_row_seq}
  {
    \seq_if_exist:cF {l_node_row_##1_seq}
    {
      \seq_new:c {l_node_row_##1_seq}
    }
    \exp_args:Ncx\seq_set_from_clist:Nn {l_node_row_##1_seq} {\seq_item:Nn \l_node_row_seq{##1}}
  }
}

\cs_set:Npn \PrintTime [#1][#2] {
  \tl_if_empty:nTF { #1 }
  {
    \tl_if_empty:nTF { #2 }
    {
      \seq_use:Nn \l_node_row_seq {,}
    }
    {
      \int_step_inline:nn{\seq_count:N \l_node_row_seq}
      {
        \seq_put_right:Nn \l_node_tmp_seq {\seq_item:cn {l_node_row_##1_seq}{#2}}
      }
      \seq_use:Nn \l_node_tmp_seq {,}
    }
  }
  {
    \tl_if_empty:nTF {#2}
    {
      \seq_use:cn {l_node_row_#1_seq}{,}
    }
    {
      \seq_item:cn {l_node_row_#1_seq}{#2}
    }
  }
}
\ExplSyntaxOff
\RequirePackage{fontawesome5}
\newcounter{number}
\def\sticker{\gdef\@sticker}
\newcommand{\makeframe}[1]{
    \draw [gray!75] (0,0) rectangle (8.5 in,-11 in);
    \fill [fill=darkergray,\corners] (0,0) rectangle (\pagewidth,1.5*\pageheight/27.5);% 顶部深灰色块
    \node at (.5*\pagewidth,.75*\pageheight/27.5) {\huge\bfseries\sffamily #1};
    \foreach \a in {2,4,...,12}
    \fill [fill=darkergray,yshift=2.5*\pageheight/27.5+2*(\a-2)*\pageheight/27.5,\corners] (0,0) rectangle (\pagewidth,2*\pageheight/27.5);% 中间深灰色块（循环）
    \fill [fill=darkergray,yshift=2.5*\pageheight/27.5+2*12*\pageheight/27.5,\corners] (0,0) rectangle (\pagewidth,\pageheight/27.5);% 底部深灰色块
    \foreach \a in {0,1,2,...,12}
    \draw [densely dashed,gray!75,yshift=2.5*\pageheight/27.5+2*\a*\pageheight/27.5,] (0,0)--(\pagewidth,0);% 分割虚线
    % 时间标注
    \setcounter{number}{0}
    \foreach \a in {1,2,...,12}
    \node [yshift=2.5*\pageheight/27.5+2*(\a-.8)*\pageheight/27.5] at (\pagewidth/32,0) {\bfseries\color{blackgray}\texttt{\refstepcounter{number}\thenumber}};
    \ifcsname @timelist\endcsname % 若 `\@timelist == empty', 跳过该函数 
      \foreach \x in {1,2,...,12}
      {
        \node[yshift=2.5*\pageheight/27.5+2*(\x-.475)*\pageheight/27.5] at (\pagewidth/32,0) {\color{darkgray}\texttt{\PrintTime[1][\x]}};
        \node[yshift=2.5*\pageheight/27.5+2*(\x-.2)*\pageheight/27.5] at (\pagewidth/32,0) {\color{darkgray}\texttt{\PrintTime[2][\x]}};
      }\fi
    % 星期标注
    \ifdefstring{\LITE@date}{en}{
    \node [xshift=2.5*\pagewidth/16] at (0,2*\pageheight/27.5) {\color{丹色}\faIcon{moon}\;\bfseries\heiti{Monday}};
    \node [xshift=5.5*\pagewidth/16] at (0,2*\pageheight/27.5) {\color{紅緋}\faIcon{fire}\;\bfseries\heiti{Tuesday}};
    \node [xshift=8.5*\pagewidth/16] at (0,2*\pageheight/27.5) {\color{紺碧}\faIcon{water}\;\bfseries\heiti{Wednesday}};
    \node [xshift=11.5*\pagewidth/16] at (0,2*\pageheight/27.5) {\color{青碧}\faIcon{tree}\;\bfseries\heiti{Thursday}};
    \node [xshift=14.5*\pagewidth/16] at (0,2*\pageheight/27.5) {\color{金色}\faIcon{sun}\;\bfseries\heiti{Friday}};
    }{\relax}
    \ifdefstring{\LITE@date}{cn}{
    \node [xshift=2.5*\pagewidth/16] at (0,2*\pageheight/27.5) {\color{丹色}\faIcon{moon}\;\bfseries\heiti{星期一}};
    \node [xshift=5.5*\pagewidth/16] at (0,2*\pageheight/27.5) {\color{紅緋}\faIcon{fire}\;\bfseries\heiti{星期二}};
    \node [xshift=8.5*\pagewidth/16] at (0,2*\pageheight/27.5) {\color{紺碧}\faIcon{water}\;\bfseries\heiti{星期三}};
    \node [xshift=11.5*\pagewidth/16] at (0,2*\pageheight/27.5) {\color{青碧}\faIcon{tree}\;\bfseries\heiti{星期四}};
    \node [xshift=14.5*\pagewidth/16] at (0,2*\pageheight/27.5) {\color{金色}\faIcon{sun}\;\bfseries\heiti{星期五}};
    }{\relax}
    \ifcsname @sticker\endcsname
    \node [opacity=.3,anchor=south east,yshift=1.5*\pageheight/27.5+2*12*\pageheight/27.5,inner sep=0pt,scale=3] at (\pagewidth,\pageheight/27.5) {\includegraphics[width=\dimeval{\pagewidth/16}]{\@sticker}};\fi
}

\newcounter{weekday}
\def\newday{\addtocounter{weekday}{1}}
\AtEndEnvironment{tikzpicture}{\setcounter{weekday}{0}}
\newcommand{\course}[7]
{
  \fill [#1,\corners,yshift=2*(#2-1)*\pageheight/27.5,xshift=3*\theweekday*\pagewidth/16] (\pagewidth/16,2.5*\pageheight/27.5) rectangle ($({4*\pagewidth/16},{(4.5+2*(#3-#2))*\pageheight/27.5})$); % frame
  \fill [#1*,\corners,yshift=(2*(#2-1)+.5)*\pageheight/27.5,xshift=3*\theweekday*\pagewidth/16] (\pagewidth/16,2.5*\pageheight/27.5) rectangle ($({4*\pagewidth/16},{(4+2*(#3-#2))*\pageheight/27.5})$); % content
  \node [#1**,yshift=(#2+#3-1.25)*\pageheight/27.5,xshift=3*\theweekday*\pagewidth/16] at (2.5*\pagewidth/16,2.5*\pageheight/27.5) {\heiti\large\bfseries #4}; % course
  \node [#1**,anchor=south,yshift=(#2+#3-.2)*\pageheight/27.5,xshift=3*\theweekday*\pagewidth/16] at (2.5*\pagewidth/16,2.5*\pageheight/27.5) {\heiti\bfseries\small #5}; % location
  \node [#1**,anchor=north,yshift=(#2+#3-.2)*\pageheight/27.5,xshift=3*\theweekday*\pagewidth/16] at (2.5*\pagewidth/16,2.5*\pageheight/27.5) {\heiti\bfseries\small #6}; % teacher
  \node [#1**,anchor=south east,yshift=2*#3*\pageheight/27.5,xshift=3*\theweekday*\pagewidth/16] at (4*\pagewidth/16,2.5*\pageheight/27.5) {\heiti\footnotesize #7}; % weeks
}

\def\more#1{
  \node [xshift=-1em,yshift=2.5*\pageheight/27.5+2*12*\pageheight/27.5,anchor=east] at (\pagewidth,.5*\pageheight/27.5){\small\bfseries\color{darkgray}#1};
}