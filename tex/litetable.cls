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
\ProvidesExplClass{litetable}{2024/09/25}{3.0B}{Course Schedule}

\ExplSyntaxOff

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass{article}

\RequirePackage[svgnames]{xcolor}
\definecolor{darkergray}{HTML}{F1F3F5}% Blocks
\definecolor{lightergray}{HTML}{FCFDFE}% Pagecolor
\pagecolor{lightergray}

\RequirePackage{tikz}
\tikzset
{
    every picture/.append style =
    {
        line join = round, line cap = round
    }
}
\usetikzlibrary{calc}

\RequirePackage{listofitems}
\ignoreemptyitems

\ExplSyntaxOn

\int_new:N \l_time_num_int
\dim_new:N \l_time_vunit_dim
\msg_new:nnn {litetable} {timelist}
{\noexpand\timelist~extra~time~group(s)~were~ignored}
\NewDocumentCommand{\timelist}{om}
{
    \setsepchar{,/-}
    \IfBlankTF{#2}
    {
        \int_set:Nn \l_time_num_int { #1 }
        \tl_clear:N \@timelist
    }{
        \readlist*\@timelist{#2}
        \IfNoValueTF{#1}
        {
            \int_set:Nn \l_time_num_int {\@timelistlen}
        }{
            \int_set:Nn \l_time_num_int { #1 }
            \int_compare:nNnT {\@timelistlen} > {#1}
            {
                \msg_warning:nn {litetable} {timelist}
            }
        }
    }
    \dim_set:Nn \l_time_vunit_dim
    {
        \fp_eval:n {1/(2*\l_time_num_int+3.5)}\paperheight
    }
}

\int_new:N \l_week_num_int
\dim_new:N \l_week_hunit_dim
\msg_new:nnn {litetable} {weeklist}
{\noexpand\weeklist~extra~weekday~item(s)~were~ignored}
\NewDocumentCommand{\weeklist}{om}
{
    \IfValueT{#1}{\tl_set:Nn \l_weeks_tl { #1 }}
    \setsepchar{;/,}\readlist*\@weeklist{#2}
    \clist_set:Ne \l_weekshifts_in_clist { \@weeklist[2] }
    \clist_clear:N \l_week_shift_clist
    \int_step_inline:nn { \clist_count:N \l_weekshifts_in_clist }
    {
        \clist_clear:N \l__weekshifts_tmp_clist
        \int_step_inline:nn { ##1 }
        {
            \clist_put_right:Ne \l__weekshifts_tmp_clist
            {
                \clist_item:Nn \l_weekshifts_in_clist {####1}
            }
        }
        \clist_put_right:Ne \l_week_shift_clist
        {
            \int_eval:n
            {
                \clist_use:Nn \l__weekshifts_tmp_clist { + }
            }
        }
    }
    \int_compare:nNnT 
    {\listlen\@weeklist[1]} > {\listlen\@weeklist[2]}
    {
        \msg_warning:nn {litetable} {weeklist}
    }
    \int_set:Nn \l_week_num_int
    {
        \clist_item:Nn \l_week_shift_clist
        {
            \listlen\@weeklist[2]
        }
    }
    \dim_set:Nn \l_week_hunit_dim
    {
        \fp_eval:n {1/\l_week_num_int*14/15}\paperwidth
    }
}

\NewDocumentCommand{\maketable}{mo}{
    % Gray Block at top
    \fill [ darkergray ] (current~page.north~west)
            rectangle + (\paperwidth,{-1.5*\l_time_vunit_dim})
            node [ midway, black, font = \huge\bfseries ] {#1};
    \IfNoValueF{#2}% Semester
    {
        \node [ left, rectangle, fill = DarkBlue!10,
                text = DarkBlue!60, inner~sep = 2ex,
                rounded~corners = 8pt, font = \large
              ] at ($
                (current~page.north~east)+
                (-.02\paperwidth,-.75*\l_time_vunit_dim)
                $) {\ensuremath\rightleftharpoons~#2};
    }
    % Darker Blocks
    \int_step_inline:nnnn {0} {2} {\l_time_num_int} {
        \fill [ densely~dashed, darkergray ] 
                ([yshift = -2*##1*\l_time_vunit_dim]$
                    (current~page.north~west)+
                    (0,-2.5*\l_time_vunit_dim)
                $) rectangle + 
                (\paperwidth,-2*\l_time_vunit_dim);
    }
    % Sepdashes
    \int_step_inline:nnnn {0} {1} {\l_time_num_int} {
        \draw [ densely~dashed, gray, thick ]
                ([yshift = -2*##1*\l_time_vunit_dim]$
                    (current~page.north~west)+
                    (0,-2.5*\l_time_vunit_dim)
                $) --++ (\paperwidth,0);
    }
    \tl_if_empty:NTF {\@timelist}% Classes numbering
    {
        \int_step_inline:nnnn {1} {1} {\l_time_num_int} {
            \node [ yshift = -2*##1*\l_time_vunit_dim,
                    darkgray!80, font = \bfseries\large\ttfamily
                  ] at ($
                        (current~page.north~west)+
                        (\paperwidth/30,-1.5*\l_time_vunit_dim)
                    $) {##1};
        }
    }{
        \int_step_inline:nnnn {1} {1} {\l_time_num_int} {
            \node [ yshift = -2*##1*\l_time_vunit_dim,
                    darkgray!80, font = \bfseries\large\ttfamily
                  ] at ($
                        (current~page.north~west)+
                        (\paperwidth/30,-\l_time_vunit_dim)
                    $) {##1};
        }
        % Classes start time
        \int_step_inline:nnnn {1} {1} {\@timelistlen} {
            \node [ yshift = -2*##1*\l_time_vunit_dim,
                    gray, font = \ttfamily ]
                    at ($
                        (current~page.north~west)+
                        (\paperwidth/30,-1.65*\l_time_vunit_dim)
                    $) {\@timelist[##1,1]};
        }
        % Classes end time
        \int_step_inline:nnnn {1} {1} {\@timelistlen} {
            \node [ yshift=-2*##1*\l_time_vunit_dim,
                    gray, font = \ttfamily ]
                    at ($
                        (current~page.north~west)+
                        (\paperwidth/30,-2.15*\l_time_vunit_dim)
                    $) {\@timelist[##1,2]};
        }
    }
    % Weekdays
    \int_step_inline:nnnn {1} {1} {
        \int_min:nn
        {
            \listlen\@weeklist[1]
        }{
            \listlen\@weeklist[2]
        }
    } {
        \node [ font = \large\bfseries,
                xshift = \clist_item:Nn \l_week_shift_clist {##1}/
                \l_week_num_int*14/15*\paperwidth
              ]
                at ($
                    (current~page.north~west)-
                    (\fp_eval:n {(
                        \@weeklist[2,##1]/2)/
                        \l_week_num_int*14/15-1/15
                    }*\paperwidth,2*\l_time_vunit_dim)
                $) {\@weeklist[1,##1]};
    }   
}

\int_new:N \l_week_day_int
\newcommand{\newday}{\int_add:Nn \l_week_day_int {1}}
\keys_define:nn{course}{
    color.tl_set:N = \l_color_tl,
    color.initial:n = DarkSlateGray,
    color.default:n = DarkSlateGray,
    subject.tl_set:N = \l_subject_tl,
    teacher.tl_set:N = \l_teacher_tl,
    location.tl_set:N = \l_location_tl,
    weeks.tl_set:N = \l_weeks_tl,
    weeks.initial:n = \l_weeks_tl,
    weeks.default:n = \l_weeks_tl,
}
\dim_new:N \l_course_infoshift_dim
\NewDocumentCommand{\course}{O{}mm}
{
    \group_begin:
    \keys_set:nn{course}{#1}
    % Course block fg
    \fill [ \l_color_tl!60, rounded~corners = 8pt ] ($
            (current~page.north~west)+(.4pt,-.4pt)+
            (\fp_eval:n
            {
                \clist_item:Nn \l_week_shift_clist
                {
                    \l_week_day_int
                }-\@weeklist[2,\l_week_day_int]
            }*\l_week_hunit_dim+\paperwidth/15,
            \fp_eval:n {-.5-2*#2}*\l_time_vunit_dim)
        $) rectangle ($
            (current~page.north~west)+(-.4pt,.4pt)+
            (\clist_item:Nn \l_week_shift_clist
            {
                \l_week_day_int
            }*\l_week_hunit_dim+\paperwidth/15,
            \fp_eval:n {-2.5-2*#3}*\l_time_vunit_dim)
        $);
    % Course block bg
    \fill [ \l_color_tl!10 ] ($
            (current~page.north~west)+(1.2pt,-.4pt)+
            (\fp_eval:n
            {
                \clist_item:Nn \l_week_shift_clist
                {
                    \l_week_day_int
                }-\@weeklist[2,\l_week_day_int]
            }*\l_week_hunit_dim+\paperwidth/15,
            \fp_eval:n {-1-2*#2}*\l_time_vunit_dim)
        $) -- ($
            (current~page.north~west)+(-1.2pt,-.4pt)+
            (\clist_item:Nn \l_week_shift_clist
            {
                \l_week_day_int
            }*\l_week_hunit_dim+\paperwidth/15,
            \fp_eval:n {-1-2*#2}*\l_time_vunit_dim)
        $) {[rounded~corners = 7.2pt] -- ($
            (current~page.north~west)+(-1.2pt,1.2pt)+
            (\clist_item:Nn \l_week_shift_clist
            {
                \l_week_day_int
            }*\l_week_hunit_dim+\paperwidth/15,
            \fp_eval:n {-2.5-2*#3}*\l_time_vunit_dim)
        $) -- ($
            (current~page.north~west)+(1.2pt,1.2pt)+
            (\fp_eval:n
            {
                \clist_item:Nn \l_week_shift_clist
                {
                    \l_week_day_int
                }-\@weeklist[2,\l_week_day_int]
            }*\l_week_hunit_dim+\paperwidth/15,
            \fp_eval:n {-2.5-2*#3}*\l_time_vunit_dim)
        $)} -- cycle;
    % Course info
    \tl_if_eq:NNTF {#2} {#3}% Single-unit height course block
    {
        \bool_if:nTF
        {
            \tl_if_empty_p:N \l_location_tl &&
            \tl_if_empty_p:N \l_teacher_tl
        }{
            \tl_set:Nn \l_shortcourse_anchor_tl { }
        }{
            \tl_set:Nn \l_shortcourse_anchor_tl { above }
        }
        \cs_if_exist:NT {\l_subject_tl }
        {
            \node [ \l_shortcourse_anchor_tl,
                    \l_color_tl!60, align = center,
                    font = \large\bfseries ]
                    at ($
                        (current~page.north~west)+
                        (\fp_eval:n
                        {
                            \clist_item:Nn \l_week_shift_clist
                            {
                                \l_week_day_int
                            }-\@weeklist[2,\l_week_day_int]/2
                        }*\l_week_hunit_dim+\paperwidth/15,
                        \fp_eval:n {-1.75-#2-#3}*\l_time_vunit_dim)
                    $) { \l_subject_tl };
        }
        \bool_if:nTF
        {
            !\tl_if_empty_p:N \l_location_tl &&
            !\tl_if_empty_p:N \l_teacher_tl
        }{
            \tl_set:Nn \l_shortcourse_sep_tl { ,~ }
        }{
            \tl_set:Nn \l_shortcourse_sep_tl { }
        }
        \node [ below, \l_color_tl!60, align = center ]
                at ($
                    (current~page.north~west)+
                    (\fp_eval:n
                    {
                        \clist_item:Nn \l_week_shift_clist
                        {
                           \l_week_day_int
                        }-\@weeklist[2,\l_week_day_int]/2
                    }*\l_week_hunit_dim+\paperwidth/15,
                    \fp_eval:n {-1.75-#2-#3}*\l_time_vunit_dim)
                    $) {
                        \tl_if_exist:NT
                            { \l_location_tl } { \l_location_tl }
                            \l_shortcourse_sep_tl
                        \tl_if_exist:NT
                            { \l_teacher_tl } { \l_teacher_tl }
                       };
    }{
        \bool_if:nTF% Multiply-unit height course block
        {
            \tl_if_empty_p:N \l_location_tl &&
            \tl_if_empty_p:N \l_teacher_tl
        }{
            \tl_set:Nn \l_course_anchor_tl {}
            \dim_set:Nn \l_course_infoshift_dim { 0pt }
        }{
            \tl_set:Nn \l_course_anchor_tl { above }
            \dim_set:Nn \l_course_infoshift_dim
            {
                .125\l_time_vunit_dim
            }
        }
        \cs_if_exist:NT { \l_subject_tl }
        {
            \node [ \l_course_anchor_tl,
                    yshift = \l_course_infoshift_dim,
                    \l_color_tl!60, align = center,
                    font = \large\bfseries
                  ] at ($
                        (current~page.north~west)+
                        (\fp_eval:n
                        {
                            \clist_item:Nn \l_week_shift_clist
                            {
                                \l_week_day_int
                            }-\@weeklist[2,\l_week_day_int]/2
                        }*\l_week_hunit_dim+\paperwidth/15,
                        \fp_eval:n {-1.5-#2-#3}*\l_time_vunit_dim)
                    $) { \l_subject_tl };
        }
        \bool_if:nTF
        {
            !\tl_if_empty_p:N \l_location_tl && 
            !\tl_if_empty_p:N \l_teacher_tl
        }{
            \tl_set:Nn \l_courseinfo_sep_tl { \\ }
        }{
            \tl_set:Nn \l_courseinfo_sep_tl { }
        }
        \node [ below, \l_color_tl!60, align = center ]
                at ($
                    (current~page.north~west)+
                    (\fp_eval:n
                    {
                        \clist_item:Nn \l_week_shift_clist
                        {
                            \l_week_day_int
                        }-\@weeklist[2,\l_week_day_int]/2
                    }*\l_week_hunit_dim+\paperwidth/15,
                    \fp_eval:n {-1.625-#2-#3}*\l_time_vunit_dim)
                    $) {
                        \tl_if_exist:NT
                            { \l_location_tl } { \l_location_tl }
                            \l_courseinfo_sep_tl
                        \tl_if_exist:NT
                            { \l_teacher_tl } { \l_teacher_tl }
                       };
        \node [ above~left, \l_color_tl!60, outer~sep = .5ex ]
                at ($
                    (current~page.north~west)+
                    (\clist_item:Nn \l_week_shift_clist
                    {
                        \l_week_day_int
                    }*\l_week_hunit_dim+\paperwidth/15,
                    \fp_eval:n {-2.5-2*#3}*\l_time_vunit_dim)
                $) { \l_weeks_tl };
    }
    \group_end:
}

\newcommand{\more}[1]% Additional info
{
    \node [ left = 1ex, darkgray, font = \small\bfseries ]
            at ($
                (current~page.south~east)+(0,.5*\l_time_vunit_dim)
            $) {#1};
}
\tl_clear:N \thepage
\endinput
%%