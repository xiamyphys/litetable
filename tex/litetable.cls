%% ************************************************************************************************************
%% ******************************************************                                                     *
%% * This work may be distributed and/or modified under *           *           *****       *   *             *
%% * the conditions of the LaTeX Project Public License *           *      ** *   *    ***   * *              *
%% *     http://www.latex-project.org/lppl.txt          *           *     *  **   *   *****   *               *
%% * either version 1.3c of this license or any later   *           *     *  **   *   *****   *               *
%% * version.                                           *           *     *  **   *   *      * *              *
%% ******************************************************           *****  ** *   *    ***  *   *             *
%% start of file `notebeamer.cls'.                                                                            *
%% Copyright 2023 LiteLaTeX (xiamyphys@gmail.com)                                                             *
%% available at https://github.com/xiamyphys/LiteTable                                                        *
%% !Mode:: "TeX:UTF-8"                                                                                        *
%% ************************************************************************************************************
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{litetable}[11/11/2023 v2.1b LiteTable document class]
\LoadClass[tikz,margin=10pt]{standalone}
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
\DeclareVoidOption{libertinus}{\ekv{date=libertinus}}

\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessKeyvalOptions*\relax

% ---------- 中文字体 ---------- %
\RequirePackage{ctex}

% ---- 文本中的数字 & 字母设置 ---- %
\PassOptionsToPackage{no-math}{fontspec}
\PassOptionsToPackage{quiet}{fontspec}
\ifdefstring{\LITE@font}{libertinus}{
\setmainfont{Libertinus Serif}
\setsansfont{Libertinus Sans}
\setmonofont{NotoSansMono}[
  Scale=MatchLowercase,
  Extension=.ttf,
  UprightFont=*-Light,
  BoldFont=*-Medium
]
}{\relax}
\RequirePackage{iftex}
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
\definecolor{lightergray}{HTML}{F8F9FA}% 浅色块
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
\newcommand{\xscale}{2.2733}
\newcommand{\yscale}{0.4291}

\usetikzlibrary{calc}
\ifdefstring{\LITE@style}{round}{
\newcommand{\course}[8]{
    \fill [#1,rounded corners=5pt] ($({(-23+32*(#2))*\xscale},{-\yscale*(21+93*#3)-0.2})$) rectangle ($({(9+32*(#2))*\xscale},{-\yscale*(114+93*#4)+0.2})$);
    \fill [#1*,rounded corners=5pt] ($({(-23+32*(#2))*\xscale+0.1},{-\yscale*(42+93*#3)})$) -- ($({(-23+32*(#2))*\xscale+0.1},{-\yscale*(114+93*#4)+0.3})$) -- ($({(9+32*(#2))*\xscale-0.1},{-\yscale*(114+93*#4)+0.3})$) -- ($({(9+32*(#2))*\xscale-0.1},{-\yscale*(42+93*#3)})$);
    \node [#1**,anchor=south] at ($({((-23+32*(#2))*\xscale+(9+32*(#2))*\xscale)/2},{(-\yscale*(21+93*#3)-\yscale*(114+93*#4))/2})$) {\heiti\bfseries #5};
    \node [#1**,anchor=north] at ($({((-23+32*(#2))*\xscale+(9+32*(#2))*\xscale)/2},{(-\yscale*(21+93*#3)-\yscale*(114+93*#4))/2-21*\yscale})$) {\heiti\bfseries\footnotesize #6};
    \node [#1**,anchor=north] at ($({((-23+32*(#2))*\xscale+(9+32*(#2))*\xscale)/2},{(-\yscale*(21+93*#3)-\yscale*(114+93*#4))/2-42*\yscale})$) {\heiti\footnotesize #7};
    \node [#1**,anchor=south east] at ($({(9+32*(#2))*\xscale-0.1},{-\yscale*(114+93*#4)+0.3})$) {\heiti\footnotesize #8};
    }
  }{\relax}
\ifdefstring{\LITE@style}{sharp}{
\newcommand{\course}[8]{
    \fill [#1] ($({(-23+32*(#2))*\xscale},{-\yscale*(21+93*#3)-0.2})$) rectangle ($({(9+32*(#2))*\xscale},{-\yscale*(114+93*#4)+0.2})$);
    \fill [#1*] ($({(-23+32*(#2))*\xscale+0.1},{-\yscale*(42+93*#3)})$) rectangle ($({(9+32*(#2))*\xscale-0.1},{-\yscale*(114+93*#4)+0.3})$);
    \node [#1**,anchor=south] at ($({((-23+32*(#2))*\xscale+(9+32*(#2))*\xscale)/2},{(-\yscale*(21+93*#3)-\yscale*(114+93*#4))/2})$) {\heiti\bfseries #5};
    \node [#1**,anchor=north] at ($({((-23+32*(#2))*\xscale+(9+32*(#2))*\xscale)/2},{(-\yscale*(21+93*#3)-\yscale*(114+93*#4))/2-21*\yscale})$) {\heiti\bfseries\footnotesize #6};
    \node [#1**,anchor=north] at ($({((-23+32*(#2))*\xscale+(9+32*(#2))*\xscale)/2},{(-\yscale*(21+93*#3)-\yscale*(114+93*#4))/2-42*\yscale})$) {\heiti\footnotesize #7};
    \node [#1**,anchor=south east] at ($({(9+32*(#2))*\xscale-0.1},{-\yscale*(114+93*#4)+0.3})$) {\heiti\footnotesize #8};
    }
  }{\relax}

\newcounter{number}
\RequirePackage{fontawesome5}
\definecolor{丹色}{HTML}{E45E32}
\definecolor{紅緋}{HTML}{E83929}
\definecolor{紺碧}{HTML}{007BBB}
\definecolor{青碧}{HTML}{478384}
\definecolor{金色}{HTML}{E6B422}
\newcommand{\makeframe}[1]{
    \ifdefstring{\LITE@style}{round}{
    \fill [fill=darkergray,rounded corners=8pt] (0,0) rectangle ($({169*\xscale},{-\yscale*72})$);% 顶部深灰色块
    \foreach \a in {2,4,...,12}
    \fill [fill=darkergray,yshift=\yscale*72 cm-\yscale*93*\a cm,rounded corners=8pt] (0,0) rectangle ($({169*\xscale},{-\yscale*93})$);% 中间深灰色块（循环）
    \fill [fill=darkergray,yshift=-\yscale*114 cm-\yscale*93*12 cm,rounded corners=8pt] (0,0) rectangle ($({169*\xscale},{-\yscale*36})$);% 底部深灰色块
    }{\relax}
    \ifdefstring{\LITE@style}{sharp}{
    \fill [fill=darkergray] (0,0) rectangle ($({169*\xscale},{-\yscale*72})$);% 顶部深灰色块
    \foreach \a in {2,4,...,12}
    \fill [fill=darkergray,yshift=\yscale*72 cm-\yscale*93*\a cm] (0,0) rectangle ($({169*\xscale},{-\yscale*93})$);% 中间深灰色块（循环）
    \fill [fill=darkergray,yshift=-\yscale*114 cm-\yscale*93*12 cm] (0,0) rectangle ($({169*\xscale},{-\yscale*36})$);% 底部深灰色块
    }{\relax}
    \foreach \a in {0,1,2,...,12}
    \draw [densely dashed,gray!75,yshift=-\yscale*114 cm-\yscale*93*\a cm] ($({9*\xscale},0)$)--($({169*\xscale},0)$);% 分割虚线
    \node at ($({169*\xscale/2},{-\yscale*72/2})$) {\huge\bfseries\sffamily #1};
    % 时间标注
    \setcounter{number}{0}
    \foreach \a in {1,2,...,12}
    \node [yshift=-93*\yscale*(\a-1)*0.05 cm] at ($({9*\xscale/2},{-\yscale*135})$) {\bfseries\color{blackgray}\texttt{\textit{\refstepcounter{number}\thenumber}}};
    \node at ($({9*\xscale/2},{-\yscale*171})$) {\footnotesize\color{darkgray}\texttt{8:05}};
    \node at ($({9*\xscale/2},{-\yscale*195})$) {\footnotesize\color{darkgray}\texttt{8:50}};

    \node [yshift=-93*\yscale*0.05 cm] at ($({9*\xscale/2},{-\yscale*171})$) {\footnotesize\color{darkgray}\texttt{8:55}};
    \node [yshift=-93*\yscale*0.05 cm] at ($({9*\xscale/2},{-\yscale*195})$) {\footnotesize\color{darkgray}\texttt{9:40}};

    \node [yshift=-2*93*\yscale*0.05 cm] at ($({9*\xscale/2},{-\yscale*171})$) {\footnotesize\color{darkgray}\texttt{10:00}};
    \node [yshift=-2*93*\yscale*0.05 cm] at ($({9*\xscale/2},{-\yscale*195})$) {\footnotesize\color{darkgray}\texttt{10:45}};

    \node [yshift=-3*93*\yscale*0.05 cm] at ($({9*\xscale/2},{-\yscale*171})$) {\footnotesize\color{darkgray}\texttt{10:50}};
    \node [yshift=-3*93*\yscale*0.05 cm] at ($({9*\xscale/2},{-\yscale*195})$) {\footnotesize\color{darkgray}\texttt{11:35}};

    \node [yshift=-4*93*\yscale*0.05 cm] at ($({9*\xscale/2},{-\yscale*171})$) {\footnotesize\color{darkgray}\texttt{11:40}};
    \node [yshift=-4*93*\yscale*0.05 cm] at ($({9*\xscale/2},{-\yscale*195})$) {\footnotesize\color{darkgray}\texttt{12:25}};

    \node [yshift=-5*93*\yscale*0.05 cm] at ($({9*\xscale/2},{-\yscale*171})$) {\footnotesize\color{darkgray}\texttt{13:30}};
    \node [yshift=-5*93*\yscale*0.05 cm] at ($({9*\xscale/2},{-\yscale*195})$) {\footnotesize\color{darkgray}\texttt{14:15}};

    \node [yshift=-6*93*\yscale*0.05 cm] at ($({9*\xscale/2},{-\yscale*171})$) {\footnotesize\color{darkgray}\texttt{14:20}};
    \node [yshift=-6*93*\yscale*0.05 cm] at ($({9*\xscale/2},{-\yscale*195})$) {\footnotesize\color{darkgray}\texttt{15:05}};

    \node [yshift=-7*93*\yscale*0.05 cm] at ($({9*\xscale/2},{-\yscale*171})$) {\footnotesize\color{darkgray}\texttt{15:15}};
    \node [yshift=-7*93*\yscale*0.05 cm] at ($({9*\xscale/2},{-\yscale*195})$) {\footnotesize\color{darkgray}\texttt{16:00}};

    \node [yshift=-8*93*\yscale*0.05 cm] at ($({9*\xscale/2},{-\yscale*171})$) {\footnotesize\color{darkgray}\texttt{16:05}};
    \node [yshift=-8*93*\yscale*0.05 cm] at ($({9*\xscale/2},{-\yscale*195})$) {\footnotesize\color{darkgray}\texttt{16:50}};

    \node [yshift=-9*93*\yscale*0.05 cm] at ($({9*\xscale/2},{-\yscale*171})$) {\footnotesize\color{darkgray}\texttt{18:30}};
    \node [yshift=-9*93*\yscale*0.05 cm] at ($({9*\xscale/2},{-\yscale*195})$) {\footnotesize\color{darkgray}\texttt{19:15}};

    \node [yshift=-10*93*\yscale*0.05 cm] at ($({9*\xscale/2},{-\yscale*171})$) {\footnotesize\color{darkgray}\texttt{19:20}};
    \node [yshift=-10*93*\yscale*0.05 cm] at ($({9*\xscale/2},{-\yscale*195})$) {\footnotesize\color{darkgray}\texttt{20:05}};

    \node [yshift=-11*93*\yscale*0.05 cm] at ($({9*\xscale/2},{-\yscale*171})$) {\footnotesize\color{darkgray}\texttt{20:10}};
    \node [yshift=-11*93*\yscale*0.05 cm] at ($({9*\xscale/2},{-\yscale*195})$) {\footnotesize\color{darkgray}\texttt{20:55}};
    % 星期标注
    \ifdefstring{\LITE@date}{en}{
    \node [xshift=\xscale*25*0.05 cm] at ($(0,{-\yscale*93})$) {\color{丹色}\faIcon{moon}\;\bfseries\heiti{Monday}};
    \node [xshift=\xscale*57*0.05 cm] at ($(0,{-\yscale*93})$) {\color{紅緋}\faIcon{fire}\;\bfseries\heiti{Tuesday}};
    \node [xshift=\xscale*89*0.05 cm] at ($(0,{-\yscale*93})$) {\color{紺碧}\faIcon{water}\;\bfseries\heiti{Wednesday}};
    \node [xshift=\xscale*121*0.05 cm] at ($(0,{-\yscale*93})$) {\color{青碧}\faIcon{tree}\;\bfseries\heiti{Thursday}};
    \node [xshift=\xscale*153*0.05 cm] at ($(0,{-\yscale*93})$) {\color{金色}\faIcon{sun}\;\bfseries\heiti{Friday}};
    }{\relax}
    \ifdefstring{\LITE@date}{cn}{
    \node [xshift=\xscale*25*0.05 cm] at ($(0,{-\yscale*93})$) {\color{丹色}\faIcon{moon}\;\bfseries\heiti{星期一}};
    \node [xshift=\xscale*57*0.05 cm] at ($(0,{-\yscale*93})$) {\color{紅緋}\faIcon{fire}\;\bfseries\heiti{星期二}};
    \node [xshift=\xscale*89*0.05 cm] at ($(0,{-\yscale*93})$) {\color{紺碧}\faIcon{water}\;\bfseries\heiti{星期三}};
    \node [xshift=\xscale*121*0.05 cm] at ($(0,{-\yscale*93})$) {\color{青碧}\faIcon{tree}\;\bfseries\heiti{星期四}};
    \node [xshift=\xscale*153*0.05 cm] at ($(0,{-\yscale*93})$) {\color{金色}\faIcon{sun}\;\bfseries\heiti{星期五}};
    }{\relax}
}
\newcommand{\more}[1]{\node [yshift=-\yscale*0.05*114 cm-\yscale*0.05*93*12 cm,anchor=east] at ($({169*\xscale},{-\yscale*18})$) {\small\color{darkgray}#1};}