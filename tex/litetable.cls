%% ***********************************************************
%%   Copyright 2024 by M.Y. XIA <xiamyphys@gmail.com>        *
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
%%   The Current Maintainer of this work is M.Y. XIA.        *
%%                                                           *
%%   This work consists of the files litetable.cls,          *
%%                               and README.md.              *
%%   available at https://github.com/xiamyphys/litetable     *
%% ***********************************************************
\ProvidesExplClass{litetable}{2024/09/26}{3.1A}{Course Schedule}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\LoadClass{article}

\pagestyle{empty}
\RequirePackage{tikz}
\definecolor{darkergray}{HTML}{F4F6F8}

% For texlive 2022 and later
\cs_if_exist:NF \clist_put_right:Ne 
{ \cs_generate_variant:Nn \clist_put_right:Nn { Ne } }
\cs_if_exist:NF \clist_set:Ne 
{ \cs_generate_variant:Nn \clist_set:Nn { Ne } }
\cs_if_exist:NT \clist_count:e 
{ \cs_generate_variant:Nn \clist_count:n { e } }

% For left -> right data type
\cs_new_protected_nopar:Npn \__litetable_get_left:nnN #1#2
{
  \group_begin:
  \seq_set_split:Nnn \l__litetable_tmpa_seq { -> } { #1 }
  \exp_args:NNNe \group_end: \tl_set:Nn #2
  { \seq_item:Nn \l__litetable_tmpa_seq { 1 } }
}
\cs_new_protected_nopar:Npn \__litetable_get_right:nnN #1#2
{
  \group_begin:
  \seq_set_split:Nnn \l__litetable_tmpa_seq { -> } { #1 }
  \exp_args:NNNe \group_end: \tl_set:Nn #2 
  { \seq_item:Nn \l__litetable_tmpa_seq { 2 } }
}
\cs_generate_variant:Nn \__litetable_get_left:nnN { e }
\cs_generate_variant:Nn \__litetable_get_right:nnN { e }

\int_new:N \l__time_num_int
\dim_new:N \l__time_vunit_dim
\cs_new_protected:Npn \litetable_msg_new:nn #1#2 
{ \msg_new:nnn { litetable} { #1 } { #2 } }
\cs_new_protected:Npn \litetable_msg_warning:n #1 
{ \msg_warning:nn { litetable } { #1 } }
\litetable_msg_new:nn { timelist }
{ \exp_not:N \timelist~extra~time~group(s)~were~ignored }
\cs_new_protected_nopar:Npn \litetable_timelist:nn #1#2
{
  \clist_set:Nn \l__litetable_timelist_clist { #2 }
  \tl_if_empty:nTF { #1 }
  {
    \int_set:Nn \l__time_num_int
    {
      \clist_count:N \l__litetable_timelist_clist
    }
  }
  {
    \int_set:Nn \l__time_num_int { #1 }
    \int_compare:nNnTF { #1 } <
    { \clist_count:N \l__litetable_timelist_clist }
    {
      \int_set:Nn \l__time_num_int
      {
        \clist_count:N \l__litetable_timelist_clist
      }
      \litetable_msg_warning:n { timelist }
    } { \int_set:Nn \l__time_num_int { #1 } }
  }
  \dim_set:Nn \l__time_vunit_dim
  {
    \fp_eval:n {1/(2*\l__time_num_int+3.5)}\paperheight
  }
}
\NewDocumentCommand \timelist { O{} m O{} } 
{ \litetable_timelist:nn { #1#3 } { #2 } }

\clist_new:N \l__week_ratio_clist
\clist_new:N \l__week_accum_clist
\int_new:N \l__week_num_int
\dim_new:N \l__week_hunit_dim
\cs_new_protected_nopar:Npn \litetable_weeklist:nn #1#2
{   
  \tl_set:Nn \l__default_weeks_tl { #1 }
  \clist_set:Nn \l__litetable_weeklist_clist { #2 }
  \int_step_inline:nn 
  {
    \clist_count:N \l__litetable_weeklist_clist
  }
  {
    \__litetable_get_right:enN
    {
      \clist_item:Nn \l__litetable_weeklist_clist {##1}
    } {\l__litetable_tmpb_tl}
    \clist_put_right:Ne \l__week_ratio_clist
    {
      \l__litetable_tmpb_tl
    }
  }
  \int_step_inline:nn 
  {
    \clist_count:N \l__litetable_weeklist_clist
  }
  {
    \clist_clear:N \l__week_accumtmp_clist
    \int_step_inline:nn { ##1 }
    {
      \clist_put_right:Ne \l__week_accumtmp_clist
      {
        \clist_item:Nn \l__week_ratio_clist { ####1 }
      }
    }
    \clist_put_right:Ne \l__week_accum_clist
    {
      \int_eval:n
      {
        \clist_use:Nn \l__week_accumtmp_clist { + }
      }
    }
  }
  \int_set:Nn \l__week_num_int
  {
    \clist_item:Nn \l__week_accum_clist
    {
      \clist_count:N \l__litetable_weeklist_clist
    }
  }
  \dim_set:Nn \l__week_hunit_dim
  {
    \fp_eval:n {1/\l__week_num_int*14/15}\paperwidth
  }
}
\NewDocumentCommand \weeklist { O{} m O{} } 
{ \litetable_weeklist:nn { #1#3 } { #2 } }

\int_new:N \l__litetable_week_day_int
\newcommand \newday {\int_incr:N \l__litetable_week_day_int}

\cs_new_protected_nopar:Npn \litetable_maketable:nn #1#2
{
  % Darker Block at top
  \fill [ darkergray ] (current~page.north~west)
          rectangle + (\paperwidth,-1.5\l__time_vunit_dim)
          node [ midway, black, font = \huge\bfseries ] {#1};
  \tl_if_empty:nF { #2 }% Semester
  {
    \node [ shift = {(-.02\paperwidth,-.75\l__time_vunit_dim)},
            left, rectangle, fill = DarkBlue!10,
            text = DarkBlue!60, inner~sep = 2ex,
            rounded~corners = 8pt, font = \large
          ] at (current~page.north~east)
    {\ensuremath\rightleftharpoons\ #2};
  }
  % Darker Blocks
  \int_step_inline:nnnn {0} {2} {\l__time_num_int}
  {
    \filldraw [ fill = darkergray, draw = gray, thick,
                densely~dashed, line~cap = round
              ] ([shift = {(-.4pt,{\fp_eval:n {
                  -2*##1-2.5}\l__time_vunit_dim})
                }]current~page.north~west) rectangle +
              ({\paperwidth+.8pt},-2*\l__time_vunit_dim);
  }
  % Classes numbering
  \clist_if_empty:NTF {\l__litetable_timelist_clist}
  {
    \int_step_inline:nn {\l__time_num_int}
    {
      \node [ shift = {(\paperwidth/30,{\fp_eval:n {
              -2*##1-1.5}\l__time_vunit_dim})
              }, darkgray!80, font = \large\ttfamily\bfseries
            ] at (current~page.north~west) {##1};
    }
  }
  {
    \int_step_inline:nn {\l__time_num_int}
    {
      \node [ shift = {(\paperwidth/30,\fp_eval:n {
              -2*##1-1}\l__time_vunit_dim)
              }, darkgray!80, font = \large\ttfamily\bfseries
            ] at (current~page.north~west) {##1};
    }
    % Classes time
    \int_step_inline:nn 
    {
      \clist_count:N \l__litetable_timelist_clist
    }
    {
      \__litetable_get_left:enN
      {
        \clist_item:Nn \l__litetable_timelist_clist {##1}
      } {\l__litetable_tmpa_tl}
      \__litetable_get_right:enN
      {
        \clist_item:Nn \l__litetable_timelist_clist {##1}
      } {\l__litetable_tmpb_tl}
      \node [ shift = {(\paperwidth/30,\fp_eval:n {
              -1.9-2*##1}\l__time_vunit_dim)
              }, gray, font = \ttfamily ,align = center
            ] at (current~page.north~west)
      {\l__litetable_tmpa_tl\\\l__litetable_tmpb_tl};
    }
  }
  % Weekdays
  \int_step_inline:nn
  {
    \clist_count:N \l__litetable_weeklist_clist
  }
  {
    \__litetable_get_left:enN
    {
      \clist_item:Nn \l__litetable_weeklist_clist {##1}
    } {\l__litetable_tmpa_tl}
    \node [ font = \large\bfseries,
            shift = {({\fp_eval:n {
            (\clist_item:Nn \l__week_accum_clist {##1}
            -\clist_item:Nn \l__week_ratio_clist {##1}/2)/
            \l__week_num_int*14/15+1/15}\paperwidth},
            -2\l__time_vunit_dim)}
          ] at (current~page.north~west)
    { \l__litetable_tmpa_tl };
  }
}
\NewDocumentCommand \maketable { O{} m O{} } 
{ \litetable_maketable:nn { #2 } { #1#3 } }

\keys_define:nn { litetable / course }
{
  color.tl_set:N = \l__course_color_tl,
  color.initial:n = teal,
  subject.tl_set:N = \l__course_subject_tl,
  teacher.tl_set:N = \l__course_teacher_tl,
  location.tl_set:N = \l__course_location_tl,
  weeks.tl_set:N = \l__default_weeks_tl,
  weeks.initial:n = \l__default_weeks_tl,
}
\dim_new:N \l__course_infoshift_dim
\cs_new_protected_nopar:Npn \__litetable_course_block_aux:nn #1#2
{
  % Course block fg
  \begin{scope}
  \clip [ preaction = {draw, ultra~thick, \l__course_color_tl!60},
          preaction = {fill, \l__course_color_tl!10},
          rounded~corners = 8pt ] 
        ([shift = {(\fp_eval:n {
          \clist_item:Nn \l__week_accum_clist
            {\l__litetable_week_day_int}-
          \clist_item:Nn \l__week_ratio_clist
            {\l__litetable_week_day_int}
        }\l__week_hunit_dim+\paperwidth/15+1.2pt,
        \fp_eval:n {-.5-2*#1}\l__time_vunit_dim-1.2pt)
        }]current~page.north~west) rectangle + 
        (\clist_item:Nn \l__week_ratio_clist
          {\l__litetable_week_day_int}\l__week_hunit_dim-2.4pt,
        \fp_eval:n {2*(#1-#2-1)}\l__time_vunit_dim+2.4pt);
  % Course block bg
  \fill [ \l__course_color_tl!60 ]
        ([shift = {(\fp_eval:n {
          \clist_item:Nn \l__week_accum_clist
            {\l__litetable_week_day_int}-
          \clist_item:Nn \l__week_ratio_clist
            {\l__litetable_week_day_int}
        }\l__week_hunit_dim+\paperwidth/15,
        \fp_eval:n {-.5-2*#1}\l__time_vunit_dim)
        }]current~page.north~west) rectangle +
        (\clist_item:Nn \l__week_ratio_clist
          {\l__litetable_week_day_int}\l__week_hunit_dim,
        -.5*\l__time_vunit_dim);
  \end{scope}
  % Course info
  \tl_if_eq:NNTF {#1} {#2}% Single-unit height course block
  {
    \bool_if:nTF
    {
      \tl_if_empty_p:N \l__course_location_tl &&
      \tl_if_empty_p:N \l__course_teacher_tl
    }
    {\tl_set:Nn \l_shortcourse_anchor_tl { }}
    {\tl_set:Nn \l_shortcourse_anchor_tl { above }}
    \cs_if_exist:NT {\l__course_subject_tl }
    {
      \node [ shift = {(\fp_eval:n {
              \clist_item:Nn \l__week_accum_clist
                {\l__litetable_week_day_int}-
              \clist_item:Nn \l__week_ratio_clist
                {\l__litetable_week_day_int}/2
            }\l__week_hunit_dim+\paperwidth/15,
            \fp_eval:n {-1.75-#1-#2}\l__time_vunit_dim)},
            \l_shortcourse_anchor_tl, \l__course_color_tl!60,
            align = center, font = \large\bfseries
            ] at (current~page.north~west)
      { \l__course_subject_tl };
    }
    \bool_if:nTF
    {
      !\tl_if_empty_p:N \l__course_location_tl &&
      !\tl_if_empty_p:N \l__course_teacher_tl
    }{\tl_set:Nn \l_shortcourse_sep_tl { ,~ }}
    {\tl_set:Nn \l_shortcourse_sep_tl { }}
    \node [ shift = {(\fp_eval:n {
            \clist_item:Nn \l__week_accum_clist
              {\l__litetable_week_day_int}-
            \clist_item:Nn \l__week_ratio_clist
              {\l__litetable_week_day_int}/2
            }\l__week_hunit_dim+\paperwidth/15,
            \fp_eval:n {-1.75-#1-#2}\l__time_vunit_dim)},
            below, \l__course_color_tl!60, align = center
          ] at (current~page.north~west)
    {
      \tl_if_exist:NT { \l__course_location_tl }
                      { \l__course_location_tl }
      \l_shortcourse_sep_tl
      \tl_if_exist:NT { \l__course_teacher_tl }
                      { \l__course_teacher_tl }
    };
  }
  {
    \bool_if:nTF% Multiply-unit height course block
    {
      \tl_if_empty_p:N \l__course_location_tl &&
      \tl_if_empty_p:N \l__course_teacher_tl
    }
    {
      \tl_set:Nn \l_course_anchor_tl {}
      \dim_set:Nn \l__course_infoshift_dim { 0pt }
    }
    {
      \tl_set:Nn \l_course_anchor_tl { above }
      \dim_set:Nn \l__course_infoshift_dim
      {
        .125\l__time_vunit_dim
      }
    }
    \cs_if_exist:NT { \l__course_subject_tl }
    {
      \node [ font = \large\bfseries, \l_course_anchor_tl,
              shift = {(\fp_eval:n {
              \clist_item:Nn \l__week_accum_clist
                {\l__litetable_week_day_int}-
              \clist_item:Nn \l__week_ratio_clist
                {\l__litetable_week_day_int }/2
              }\l__week_hunit_dim+\paperwidth/15,
              \fp_eval:n {-1.5-#1-#2}\l__time_vunit_dim)},
              yshift = \l__course_infoshift_dim,
              \l__course_color_tl!60, align = center,
            ] at (current~page.north~west)
      { \l__course_subject_tl };
    }
    \bool_if:nTF
    {
      !\tl_if_empty_p:N \l__course_location_tl && 
      !\tl_if_empty_p:N \l__course_teacher_tl
    }
    {
      \tl_set:Nn \l_courseinfo_sep_tl { \\ }
    }
    {
      \tl_set:Nn \l_courseinfo_sep_tl { }
    }
    \node [ below, \l__course_color_tl!60, align = center,
            shift = {(\fp_eval:n {
            \clist_item:Nn \l__week_accum_clist
              {\l__litetable_week_day_int}-
            \clist_item:Nn \l__week_ratio_clist
              {\l__litetable_week_day_int}/2
            }\l__week_hunit_dim+\paperwidth/15,
            \fp_eval:n {-1.625-#1-#2}\l__time_vunit_dim
        )}] at (current~page.north~west)
    {
      \tl_if_exist:NT { \l__course_location_tl }
                      { \l__course_location_tl }
      \l_courseinfo_sep_tl
      \tl_if_exist:NT { \l__course_teacher_tl }
                      { \l__course_teacher_tl }
    };
    \node [ above~left, \l__course_color_tl!60, outer~sep = .5ex,
            shift = {(
            \clist_item:Nn \l__week_accum_clist
              {\l__litetable_week_day_int}
            \l__week_hunit_dim+\paperwidth/15,
            \fp_eval:n {-2.5-2*#2}\l__time_vunit_dim
        )}] at (current~page.north~west) { \l__default_weeks_tl };
  }
}
\NewDocumentCommand \course { O{} m m }
{ 
  \group_begin:
  \keys_set:nn { litetable / course } { #1 }
  \__litetable_course_block_aux:nn { #2 } { #3 }
  \group_end:
}

\newcommand \more [1]% Additional info
{
  \node [ yshift = .5*\l__time_vunit_dim, 
          left = 1ex, darkgray, font = \small\bfseries
        ] at (current~page.south~east) {#1};
}

\endinput

% End of file litetable.cls
