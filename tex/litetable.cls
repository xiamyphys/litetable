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
\ProvidesClass{litetable}[2024/02/24/ v2.4a LiteTable document class]

% ---------- 全局选项 ---------- %
\RequirePackage{kvoptions}
\RequirePackage{etoolbox}
\SetupKeyvalOptions{family=LITE, prefix=LITE@, setkeys=\kvsetkeys}

\DeclareStringOption[sharp]{style}
\DeclareVoidOption{round}{\kvsetkeys{LITE}{style=round}}
\DeclareVoidOption{sharp}{\kvsetkeys{LITE}{style=sharp}}

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

\ifdefstring{\LITE@style}{round}{\def\corners{rounded corners}}{\relax}
\ifdefstring{\LITE@style}{sharp}{\def\corners{}}{\relax}

\ExplSyntaxOn % 数组
\cs_set:Npn \timelist #1 {
  \gdef\@timelist{#1}
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

\cs_set:Npn \weeklist #1 {
  \gdef\@weeklist{#1}
  \gdef\@weeknum{\clist_count:n {#1}} % 计数模块
  \seq_set_split:Nnn \r_node_row_seq {;} {#1}
  \int_step_inline:nn{\seq_count:N \r_node_row_seq}
  {
    \exp_args:Ncx\seq_set_from_clist:Nn {r_node_row_##1_seq} {\seq_item:Nn \r_node_row_seq{##1}}
  }
}

\cs_set:Npn \PrintWeek [#1] {
  \tl_if_empty:nTF {#1}
    {
      \seq_use:cn {r_node_row_1_seq}{,}
    }
    {
      \seq_item:cn {r_node_row_1_seq}{#1}
    }
}
\ExplSyntaxOff

\def\classnum#1{\gdef\@classnum{#1}}
\ifcsname @classnum\endcsname % 判断`\@classnum'由`\timelist'计数赋值还是`\classnum'直接赋值
  \relax
  \else
    \ifcsname @timelist\endcsname
      \gdef\@classnum{\int_div_round:nn {\clist_count:n {\@timelist}}{2}} % 计数模块
      \else
        \def\@classnum{12}
    \fi
\fi

\RequirePackage{fontawesome5}
\newcounter{number}
\def\sticker#1{\gdef\@sticker{#1}}
\def\makeframe#1{
    \draw [darkergray] (0,0) rectangle (\pagewidth,\pageheight);
    \fill [fill=darkergray,\corners] (0,0) rectangle (\pagewidth,{1.5*\pageheight/(2*\@classnum+3.5)});% 顶部深灰色块
    \node at (.5*\pagewidth,{.75*\pageheight/(2*\@classnum+3.5)}) {\huge\bfseries\sffamily #1}; % 标题

    \ifodd\@classnum
    \foreach \a in {2,4,...,\@classnum,\@classnum+2}
    \fill [fill=darkergray,yshift=(2*\a-1.5)*\pageheight/(2*\@classnum+3.5),\corners] (0,0) rectangle (\pagewidth,{2*\pageheight/(2*\@classnum+3.5)}); % 中间深灰色块（循环）
    \else
    \foreach \a in {2,4,...,\@classnum}
    \fill [fill=darkergray,yshift=(2*\a-1.5)*\pageheight/(2*\@classnum+3.5),\corners] (0,0) rectangle (\pagewidth,{2*\pageheight/(2*\@classnum+3.5)}); % 中间深灰色块（循环）
    \fill [fill=darkergray,yshift=(2.5+2*\@classnum)*\pageheight/(2*\@classnum+3.5),\corners] (0,0) rectangle (\pagewidth,{\pageheight/(2*\@classnum+3.5)}); % 底部深灰色块
    \fi

    \foreach \a in {0,1,2,...,\@classnum}
      \draw [densely dashed,gray!75,yshift=(2.5+2*\a)*\pageheight/(2*\@classnum+3.5)] (0,0)--(\pagewidth,0); % 分割虚线
    
    % 时间标注
    \setcounter{number}{0}
    \ifcsname @timelist\endcsname % 若 `\@timelist == empty', 跳过该函数 
    \foreach \x in {1,2,...,\@classnum}
    {
      \node [yshift=(2*\x+.9)*\pageheight/(2*\@classnum+3.5)] at (\pagewidth/32,0)
      {\bfseries\color{blackgray}\texttt{\refstepcounter{number}\thenumber}};
      \node[yshift=(2*\x+1.55)*\pageheight/(2*\@classnum+3.5)] at (\pagewidth/32,0)
      {\color{darkgray}\texttt{\PrintTime[1][\x]}};
      \node[yshift=(2*\x+2.1)*\pageheight/(2*\@classnum+3.5)] at (\pagewidth/32,0)
      {\color{darkgray}\texttt{\PrintTime[2][\x]}};
    }
    \else
    \foreach \a in {1,2,...,\@classnum}
    {
      \node [yshift=(1.5+2*\a)*\pageheight/(2*\@classnum+3.5)] at(\pagewidth/32,0)
      {\bfseries\large\color{blackgray}\texttt{\refstepcounter{number}\thenumber}};
    }
    \fi
    % 星期标注
    \foreach \a in {1,2,...,\@weeknum}
      \node [xshift=3*\a*\pagewidth/16] at ({\pagewidth/16-\a*(15*\pagewidth/16*(1/5-1/\@weeknum))-7.5*\pagewidth/(16*\@weeknum)},{2*\pageheight/(2*\@classnum+3.5)})
      {\PrintWeek[\a]};
    \ifcsname @sticker\endcsname
    \node [opacity=.3,above left,yshift=(1.5+2*\@classnum)*\pageheight/(2*\@classnum+3.5),inner sep=0pt,outer sep=auto,scale=15] at (\pagewidth,{\pageheight/(2*\@classnum+3.5)}) {\includegraphics[width=\dimeval{\pagewidth/16/\@weeknum}]{\@sticker}};\fi
}

\newcounter{weekday}
\def\newday{\addtocounter{weekday}{1}}
\AtEndEnvironment{tikzpicture}{\setcounter{weekday}{0}}

\def\weeks#1{\gdef\@weeks{#1}}
\ifcsname @weeks\endcsname
  \relax
\else
  \let\@weeks\relax
\fi

\NewDocumentCommand{\course}{O{H1} m m m m m O{\@weeks}}
{
  \fill [#1,\corners,
  yshift=(2*(#2-1))*\pageheight/(2*\@classnum+3.5),
  xshift=3*\theweekday*\pagewidth/16]
  ({\pagewidth/16-\theweekday*(15*\pagewidth/16*(1/5-1/\@weeknum))},{2.5*\pageheight/(2*\@classnum+3.5)}) rectangle ++
  ({15*\pagewidth/(16*\@weeknum)},{(2+2*(#3-#2))*\pageheight/(2*\@classnum+3.5)}); % frame

  \fill [#1*,\corners,
  yshift=(2*(#2-1)+.5)*\pageheight/(2*\@classnum+3.5),
  xshift=3*\theweekday*\pagewidth/16]
  ({\pagewidth/16-\theweekday*(15*\pagewidth/16*(1/5-1/\@weeknum))},{2.5*\pageheight/(2*\@classnum+3.5)}) rectangle ++
  ({15*\pagewidth/(16*\@weeknum)},{(1.5+2*(#3-#2))*\pageheight/(2*\@classnum+3.5)}); % content
  
  \node [#1**,yshift=(#2+#3-1.25)*\pageheight/(2*\@classnum+3.5),
  xshift=3*\theweekday*\pagewidth/16] at
  ({\pagewidth/16-\theweekday*(15*\pagewidth/16*(1/5-1/\@weeknum))+7.5*\pagewidth/(16*\@weeknum)},{2.5*\pageheight/(2*\@classnum+3.5)})
  {\heiti\large\bfseries #4}; % course

  \node [#1**,above,
  yshift=(#2+#3-.2)*\pageheight/(2*\@classnum+3.5),
  xshift=3*\theweekday*\pagewidth/16] at
  ({\pagewidth/16-\theweekday*(15*\pagewidth/16*(1/5-1/\@weeknum))+7.5*\pagewidth/(16*\@weeknum)},{2.5*\pageheight/(2*\@classnum+3.5)})
  {\heiti\bfseries\small #5}; % location

  \node [#1**,below,
  yshift=(#2+#3-.2)*\pageheight/(2*\@classnum+3.5),
  xshift=3*\theweekday*\pagewidth/16] at
  ({\pagewidth/16-\theweekday*(15*\pagewidth/16*(1/5-1/\@weeknum))+7.5*\pagewidth/(16*\@weeknum)},{2.5*\pageheight/(2*\@classnum+3.5)})
  {\heiti\bfseries\small #6}; % teacher

  \node [#1**,above left,
  yshift=2*#3*\pageheight/(2*\@classnum+3.5),
  xshift=3*\theweekday*\pagewidth/16] at
  ({\pagewidth/16-\theweekday*(15*\pagewidth/16*(1/5-1/\@weeknum))+15*\pagewidth/(16*\@weeknum)},{2.5*\pageheight/(2*\@classnum+3.5)})
  {\heiti\footnotesize #7}; % weeks
}

\def\more#1{
  \node [xshift=-1em,yshift=(2.5+2*\@classnum)*\pageheight/(2*\@classnum+3.5),left] at (\pagewidth,{.5*\pageheight/(2*\@classnum+3.5)}){\small\bfseries\color{darkgray}#1};
}