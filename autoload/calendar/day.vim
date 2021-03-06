" =============================================================================
" Filename: autoload/calendar/day.vim
" Author: itchyny
" License: MIT License
" Last Change: 2013/12/28 12:44:55.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Day object switching the calendar based on the user's setting.
function! calendar#day#new(y, m, d)
  return calendar#day#{calendar#setting#get('calendar')}#new(a:y, a:m, a:d)
endfunction

" Day object from mjd.
function! calendar#day#new_mjd(mjd)
  return calendar#day#{calendar#setting#get('calendar')}#new_mjd(a:mjd)
endfunction

" Today.
function! calendar#day#today()
  return calendar#day#new_mjd(calendar#day#today_mjd())
endfunction

" Today's mjd.
function! calendar#day#today_mjd()
  if exists('*strftime')
    let [y, m, d] = [strftime('%Y') * 1, strftime('%m') * 1, strftime('%d') * 1]
  else
    let [y, m, d] = [system('date "+%Y"') * 1, system('date "+%m"') * 1, system('date "+%d"') * 1]
  endif
  if has_key(s:, 'today_ymd') && s:today_ymd == [y, m, d]
    return s:today_mjd
  endif
  let s:today_ymd = [y, m, d]
  let s:today_mjd = calendar#day#gregorian#new(y, m, d).mjd
  return s:today_mjd
endfunction

" Join the year, month and day using the endian, separator settings.
function! calendar#day#join_date(ymd)
  let endian = calendar#setting#get('date_endian')
  let use_month_name = calendar#setting#get('date_month_name')
  let sep1 = calendar#setting#get('date_separator')
  let sep2 = use_month_name ? '' : sep1
  let ymd = a:ymd
  if len(a:ymd) == 3
    let [y, m, d] = a:ymd
    let mm = use_month_name ? calendar#message#get('month_name')[m - 1] : m
    if endian ==# 'big'
      let ymd = [y, sep1, mm, sep2, d]
    elseif endian ==# 'middle'
      let ymd = [mm, sep2, d, sep1, y]
    else
      let ymd = [d, sep2, mm, sep1, y]
    endif
  elseif len(a:ymd) == 2
    let [m, d] = a:ymd
    let mm = use_month_name ? calendar#message#get('month_name')[m - 1] : m
    if endian ==# 'big' || endian ==# 'middle'
      let ymd = [mm, sep2, d]
    else
      let ymd = [d, sep2, mm]
    endif
  endif
  return join(ymd, '')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
