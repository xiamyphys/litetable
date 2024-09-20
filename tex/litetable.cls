%% ***********************************************************
%%   Copyright 2024 by Mingyu XIA <xiamyphys@gmail.com>      *
%%                                                           *
%%   This work may be distributed and/or modified under      *
%%   the conditions of the LaTeX Project Public License      *
%%                                                           *
%%       http://www.latex-project.org/lppl.txt               *
%%                                                           *
%%   either version 1.3c of this license or any later        *
%%   version.                                                *
%%                                                           *
%%   This work has the LPPL maintenance status `maintained'. *
%%                                                           *
%%   The Current Maintainer of this work is Mingyu XIA.      *
%%                                                           *
%%   This work consists of the files litetable.cls,          *
%%                               and README.md.              *
%%   available at https://github.com/xiamyphys/litetable     *
%% ***********************************************************
% !Mode:: "TeX:UTF-8"
\ProvidesExplClass {litetable} {2024/09/22} {3.0a} {Colorful timetable}

\RequirePackage{kvoptions}

\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessKeyvalOptions*\relax

\LoadClass{article}

\RequirePackage[svgnames]{xcolor}
\definecolor{darkergray}{HTML}{F1F3F5}% Blocks
\definecolor{lightergray}{HTML}{FCFDFE}% Pagecolor
\pagecolor{lightergray}
\let\thepage\relax

\ExplSyntaxOff
\RequirePackage{tikz}
\tikzset{
    every picture/.append style = {line join = round, line cap = round}
}
\usetikzlibrary{calc}
\ExplSyntaxOn

\RequirePackage{listofitems}
\ignoreemptyitems
\newlength{\vunit}
\NewDocumentCommand{\timelist}{ o m }{
    \setsepchar{,/-}
    \IfBlankTF{#2}{\gdef\@classnum{#1}\let\@timelist\relax}{
        \readlist*\@timelist{#2}
        \IfNoValueTF{#1}{
            \gdef\@classnum{\@timelistlen}
        }{\gdef\@classnum{#1}}
    }
    \setlength{\vunit}{\fpeval{1/(2*\@classnum+3.5)}\paperheight}
}
\clist_new:N \l__sums_in_clist
\clist_new:N \l__sums_out_clist
\clist_new:N \l__sums_tmp_clist

\NewDocumentCommand{\partialsums}{mmm}
 {% #1 = list name, #2 = row, #3 = macro name for storing
  \clist_set:Ne \l__sums_in_clist { #1[#2] }
  \clist_clear:N \l__sums_out_clist
  \int_step_inline:nn { \clist_count:N \l__sums_in_clist }
   {% ##1 is the highest term
    \clist_clear:N \l__sums_tmp_clist
    \int_step_inline:nn { ##1 }
     {% populate the tmp clist
      \clist_put_right:Ne \l__sums_tmp_clist { \clist_item:Nn \l__sums_in_clist {####1} }
     }
    \clist_put_right:Ne \l__sums_out_clist
     {% do the partial sum
      \int_eval:n { \clist_use:Nn \l__sums_tmp_clist { + } }
     }
   }
   \tl_set:Ne #3 { \clist_use:Nn \l__sums_out_clist {,} }
 }
\newlength{\hunit}
\NewDocumentCommand{\weeklist}{om}{
    \IfValueT{#1}{\gdef\course@weeks{#1}}
    \setsepchar{;/,}
    \readlist*\@weeklist{#2}
    \partialsums{\@weeklist}{2}{\@weeklistaccumulate}
    \int_compare:nNnTF {\listlen\@weeklist[1]} > {\listlen\@weeklist[2]} {
        \msg_new:nnn {litetable} {weeklist} {weeklist~extra~weekday~item(s)~were~ignored}
        \msg_warning:nn {litetable} {weeklist}
    } {}
    \readlist*\@weeklistshifts{\@weeklistaccumulate}
    \setlength{\hunit}{\fpeval{1/\@weeklistshifts[1,\fpeval{\listlen\@weeklist[2]}]*14/15}\paperwidth}
}
\newcounter{weekday}
\def\newday{\addtocounter{weekday}{1}}

\NewDocumentCommand{\maketable}{ m o }{
    \fill [darkergray] (current~page.north~west) rectangle + (\paperwidth,{-1.5*\vunit}) node [midway, black, font = \huge\bfseries] {#1};% Gray Block at the top
    \IfNoValueF{#2}{
        \node [left, rectangle, fill=DarkBlue!10, text=DarkBlue!60, inner~sep=2ex, rounded~corners=8pt, font = \large] at ($(current~page.north~east)+(-.02\paperwidth,-.75*\vunit)$) {$\rightleftharpoons$~#2}; % Semester
    }
    \foreach \a in {0,2,...,\@classnum}
        \fill [densely~dashed,darkergray]
         ([yshift=-2*\a*\vunit]$(current~page.north~west)+(0,-2.5*\vunit)$) rectangle + (\paperwidth,-2*\vunit);% Darker Blocks
    \foreach \a in {0,1,2,...,\@classnum}
        \draw [densely~dashed, gray, thick]
        ([yshift=-2*\a*\vunit]$(current~page.north~west)+(0,-2.5*\vunit)$) --++ (\paperwidth,0);% Sepdashes
    \cs_if_exist:NTF {\@timelist}
    {% Classes numbering with time
        \foreach \a in {1,2,...,\@classnum}
            \node [yshift=-2*(\a-1)*\vunit, darkgray, font = \bfseries\large\ttfamily] at ($(current~page.north~west)+(\paperwidth/30,-3*\vunit)$){\a};
        \foreach \a in {1,2,...,\@timelistlen}
            \node [yshift=-2*(\a-1)*\vunit, gray, font = \ttfamily] at ($(current~page.north~west)+(\paperwidth/30,-3.65*\vunit)$){\@timelist[\a,1]};% Classes start time
        \foreach \a in {1,2,...,\@timelistlen}
            {\node [yshift=-2*(\a-1)*\vunit, gray, font = \ttfamily] at ($(current~page.north~west)+(\paperwidth/30,-4.15*\vunit)$){\@timelist[\a,2]};}% Classes end time
    }{% Classes numbering without time
        \foreach \a in {1,2,...,\@classnum}
            \node [yshift=-2*(\a-1)*\vunit, darkgray, font = \bfseries\large\ttfamily] at ($(current~page.north~west)+(\paperwidth/30,-3.5*\vunit)$){\a};
    }
    \foreach \a in {1,2,...,\listlen\@weeklist[2]}
        \node [ font = \large\bfseries, 
                xshift = \fpeval{(
                    \@weeklistshifts[1,\a]-\@weeklist[2,\a]/2)/
                    \@weeklistshifts[1,\fpeval{\listlen\@weeklist[2]}]
                    *14/15}*\paperwidth]
                at ($(current~page.north~west)+(\paperwidth/15,-2*\vunit)$) {\@weeklist[1,\a]};% Weekdays
}
\def\more#1{
    \node [left = 1ex, darkgray, font = \small\bfseries] at ($(current~page.south~east)+(0,.5*\vunit)$) {#1};
}

\tl_new:N \l_course_color_tl
\tl_new:N \l_course_subject_tl
\tl_new:N \l_course_teacher_tl
\tl_new:N \l_course_location_tl
\tl_new:N \l_course_weeks_tl
\keys_define:nn{course}{
    color.tl_set:N = \l_color_tl,
    color.initial:n = DarkSlateGray,
    color.default:n = DarkSlateGray,
    subject.tl_set:N = \l_subject_tl,
    teacher.tl_set:N = \l_teacher_tl,
    location.tl_set:N = \l_location_tl,
    weeks.tl_set:N = \l_weeks_tl,
    weeks.initial:n = \course@weeks,
    weeks.default:n = \course@weeks,
}

\NewDocumentCommand{\course}{O{}mm}{%
    \group_begin:
    \keys_set:nn{course}{#1}
    \fill [ \tl_use:N\l_color_tl!60, rounded~corners = 8pt] ($
            (current~page.north~west)+(.4pt,-.4pt)+
            (\fpeval{\@weeklistshifts[1,\theweekday]-\@weeklist[2,\theweekday]}
                *\hunit+\paperwidth/15,
            \fpeval{-.5-2*#2}*\vunit)
        $) rectangle ($
            (current~page.north~west)+(-.2pt,.2pt)+
            (\@weeklistshifts[1,\theweekday]*\hunit+\paperwidth/15,
            \fpeval{-2.5-2*#3}*\vunit)
        $);
    \fill [ thick, \tl_use:N\l_color_tl!10] ($
            (current~page.north~west)+(1.2pt,-.4pt)+
            (\fpeval{\@weeklistshifts[1,\theweekday]-\@weeklist[2,\theweekday]}
                *\hunit+\paperwidth/15,
            \fpeval{-1-2*#2}*\vunit)
        $) -- ($
            (current~page.north~west)+(-1.2pt,-.4pt)+
            (\@weeklistshifts[1,\theweekday]
                *\hunit+\paperwidth/15,
            {\fpeval{-1-2*#2}*\vunit})
        $) {[rounded~corners = 7.2pt] -- ($
            (current~page.north~west)+(-1.2pt,1.2pt)+
            (\@weeklistshifts[1,\theweekday]
                *\hunit+\paperwidth/15,
            \fpeval{-2.5-2*#3}*\vunit)
        $) -- ($
            (current~page.north~west)+(1.2pt,1.2pt)+
            (\fpeval{\@weeklistshifts[1,\theweekday]-\@weeklist[2,\theweekday]}
                *\hunit+\paperwidth/15,
            \fpeval{-2.5-2*#3}*\vunit)
        $)} -- cycle;
    \tl_if_eq:NNTF {#2} {#3}
    {
        \cs_if_exist:NT {\l_subject_tl}{
        \node [above, \tl_use:N\l_color_tl!60, align = center, font = \large\bfseries] at ($
            (current~page.north~west)+
            (\fpeval{\@weeklistshifts[1,\theweekday]-\@weeklist[2,\theweekday]/2}
                *\hunit+\paperwidth/15,
            \fpeval{-1.75-#2-#3}*\vunit)$) 
            {\tl_use:N\l_subject_tl};
        }
        \bool_if:nTF {!\tl_if_empty_p:N \l_location_tl && !\tl_if_empty_p:N \l_teacher_tl} { \def\shortcourse@sep@tl{ ,~ } } { \def\shortcourse@sep@tl{} }
        \node [below, \tl_use:N\l_color_tl!60, align = center] at ($
            (current~page.north~west)+
            (\fpeval{\@weeklistshifts[1,\theweekday]-\@weeklist[2,\theweekday]/2}
                *\hunit+\paperwidth/15,
            \fpeval{-1.75-#2-#3}*\vunit)$) 
            {\tl_if_exist:NT { \l_location_tl } {\tl_use:N\l_location_tl} \shortcourse@sep@tl \tl_if_exist:NT { \l_teacher_tl } {\tl_use:N\l_teacher_tl}};
    }{  
        \cs_if_exist:NT {\l_subject_tl}{
        \node [above, \tl_use:N\l_color_tl!60, align = center, font = \large\bfseries] at ($
            (current~page.north~west)+
            (\fpeval{\@weeklistshifts[1,\theweekday]-\@weeklist[2,\theweekday]/2}
                *\hunit+\paperwidth/15,
            \fpeval{-1.375-#2-#3}*\vunit)$) 
            {\tl_use:N\l_subject_tl};
        }
        \bool_if:nTF { !\tl_if_empty_p:N \l_location_tl && !\tl_if_empty_p:N \l_teacher_tl} { \def\courseinfo@sep@tl{ \\ } } { \def\courseinfo@sep@tl{} }
        \node [below, \tl_use:N\l_color_tl!60, align = center] at ($
            (current~page.north~west)+
            (\fpeval{\@weeklistshifts[1,\theweekday]-\@weeklist[2,\theweekday]/2}
                *\hunit+\paperwidth/15,
            \fpeval{-1.625-#2-#3}*\vunit)$) 
            {\tl_if_exist:NT { \l_location_tl } {\tl_use:N\l_location_tl} \courseinfo@sep@tl \tl_if_exist:NT { \l_teacher_tl } {\tl_use:N\l_teacher_tl}};
        \node [above~left, \tl_use:N\l_color_tl!60, inner~sep = {7.2pt-.5ex}] at ($
            (current~page.north~west)+
            (\@weeklistshifts[1,\theweekday]
                *\hunit+\paperwidth/15,
            \fpeval{-2.5-2*#3}*\vunit)
            $) {\tl_use:N\l_weeks_tl};
    }
    \group_end:
}
\endinput
%%