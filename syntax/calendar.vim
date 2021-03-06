" =============================================================================
" Filename: syntax/calendar.vim
" Version: 0.0
" Author: itchyny
" License: MIT License
" Last Change: 2014/01/04 20:24:53.
" =============================================================================

if version < 700
  syntax clear
elseif exists('b:current_syntax')
  finish
endif

let s:fg_color = calendar#color#normal_fg_color()
let s:bg_color = calendar#color#normal_bg_color()
let s:comment_fg_color = calendar#color#comment_fg_color()
let s:select_color = calendar#color#gen_color(s:fg_color, s:bg_color, 1, 4)
let s:is_dark = &background ==# 'dark'

if !has('gui_running')
  if s:is_dark
    let s:sunday_bg_color = calendar#color#select_rgb(s:fg_color, 0, 5)
    let s:saturday_bg_color = calendar#color#select_rgb(s:fg_color, 2, 5)
    let s:sunday_fg_color = calendar#color#gen_color(s:sunday_bg_color, s:bg_color, 1, 7)
    let s:saturday_fg_color = calendar#color#gen_color(s:saturday_bg_color, s:bg_color, 1, 7)
    let s:today_color = calendar#color#select_rgb(s:fg_color, 1, 5)
    let s:today_fg_color = calendar#color#gen_color(s:today_color, s:bg_color, 1, 5)
  else
    let s:sunday_fg_color = calendar#color#select_rgb(s:bg_color, 0, 6)
    let s:saturday_fg_color = calendar#color#select_rgb(s:bg_color, 2, 6)
    let s:sunday_bg_color = calendar#color#gen_color(s:sunday_fg_color, s:bg_color, 1, 4)
    let s:saturday_bg_color = calendar#color#gen_color(s:saturday_fg_color, s:bg_color, 1, 4)
    let s:today_fg_color = calendar#color#gen_color(calendar#color#select_rgb(s:fg_color, 1, 6), s:fg_color, 4, 3)
    let s:today_color = calendar#color#gen_color(s:today_fg_color, s:bg_color, 1, 3)
  endif
else
  let s:sunday_fg_color = calendar#color#select_rgb(s:is_dark ? s:fg_color : s:bg_color, 1)
  let s:saturday_fg_color = calendar#color#select_rgb(s:is_dark ? s:fg_color : s:bg_color, 4)
  let s:sunday_bg_color = calendar#color#gen_color(s:sunday_fg_color, s:is_dark ? s:fg_color : s:bg_color, 1, 3)
  let s:saturday_bg_color = calendar#color#gen_color(s:saturday_fg_color, s:is_dark ? s:fg_color : s:bg_color, 1, 3)
  let s:today_fg_color = calendar#color#gen_color(calendar#color#select_rgb(s:is_dark ? s:fg_color : s:bg_color, 2), s:is_dark ? s:bg_color : s:fg_color, 4, 3)
  let s:today_color = calendar#color#gen_color(s:today_fg_color, s:is_dark ? s:fg_color : s:bg_color, 1, 3)
endif
let s:weekday_color = calendar#color#gen_color(s:fg_color, s:bg_color, 1, 5)
let s:weekday_fg_color = calendar#color#gen_color(s:fg_color, s:bg_color, 3, 2)
let s:othermonth_fg_color = calendar#color#gen_color(s:fg_color, s:bg_color, 3, 4)
let s:sunday_title_fg_color = calendar#color#gen_color(s:sunday_fg_color, s:sunday_bg_color, 3, 1)
let s:saturday_title_fg_color = calendar#color#gen_color(s:saturday_fg_color, s:saturday_bg_color, 3, 1)

call calendar#color#syntax('Select', '', s:select_color, '')
call calendar#color#syntax('Sunday', s:sunday_fg_color, s:sunday_bg_color, '')
call calendar#color#syntax('Saturday', s:saturday_fg_color, s:saturday_bg_color, '')
call calendar#color#syntax('TodaySunday', s:sunday_fg_color, s:sunday_bg_color, 'bold')
call calendar#color#syntax('TodaySaturday', s:saturday_fg_color, s:saturday_bg_color, 'bold')
call calendar#color#syntax('Today', s:today_fg_color, s:today_color, 'bold')
call calendar#color#syntax('DayTitle', s:weekday_fg_color, s:weekday_color, '')
call calendar#color#syntax('SundayTitle', s:sunday_title_fg_color, s:sunday_bg_color, '')
call calendar#color#syntax('SaturdayTitle', s:saturday_title_fg_color, s:saturday_bg_color, '')
call calendar#color#syntax('OtherMonth', s:othermonth_fg_color, '', '')
call calendar#color#syntax('NormalSpace', s:bg_color, s:fg_color, '')
call calendar#color#syntax('SelectComment', s:comment_fg_color, s:select_color, '')

highlight link CalendarComment Comment

let b:current_syntax = 'calendar'
