" =============================================================================
" Filename: autoload/calendar/autocmd.vim
" Author: itchyny
" License: MIT License
" Last Change: 2013/11/30 16:51:41.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Autocmd commands.

function! calendar#autocmd#new()

  if &l:filetype ==# 'calendar'
    return
  endif

  augroup CalendarAutoUpdate
    autocmd!
    " Update a visible calendar buffer.
    autocmd BufEnter,BufWritePost,VimResized,ColorScheme *
          \ silent! call s:update_visible(expand('<abuf>'))
  augroup END

  augroup CalendarBuffer

    " When colorscheme is changed, all the calendar syntax groups will be gone.
    " So set the filetype forcibly and load the syntax file again.
    autocmd ColorScheme <buffer>
          \ silent! call calendar#setlocal#filetype_force()

    " On entering the buffer, update the calendar.
    autocmd BufEnter,WinEnter,ColorScheme <buffer>
          \ silent! call b:calendar.update()

    " On resizing the Vim window, check the window size and update if it is changed.
    autocmd VimResized,CursorHold <buffer>
          \ silent! call b:calendar.update_if_resized()

    " When the cursor is moved, update the cursor appropriately.
    " In mapping.vim, 'gg' is mapped to '<Plug>(calendar_first_line)' on default.
    " However, if we press 'g' and 'g' slowly, '<Plug>(calendar_first_line)' will
    " not be triggerd. Pressing 'g' and '$' slowly also causes the same situation.
    " To avoid this, check the cursor position on CursorMoved and move the cursor
    " to the proper position.
    autocmd CursorMoved <buffer>
          \ silent! call b:calendar.cursor_moved()

  augroup END

endfunction

" Seach the calendar buffer and updates.
function! s:update_visible(bufnr)
  try
    let nr = -1
    let newnr = str2nr(a:bufnr)
    if bufname(newnr) ==# '[Command Line]'
      return
    endif
    for buf in tabpagebuflist()
      if type(getbufvar(buf, 'calendar')) == type({}) && buf != newnr
        let nr = buf
        break
      endif
    endfor
    if nr == -1 | return | endif
    let winnr = bufwinnr(nr)
    let newbuf = bufwinnr(str2nr(a:bufnr))
    let currentbuf = bufwinnr(bufnr('%'))
    noautocmd execute winnr 'wincmd w'
    silent! call calendar#setlocal#filetype_force()
    silent! call b:calendar.update_force()
    if winnr != newbuf && newbuf != -1
      call cursor(1, 1)
      noautocmd execute newbuf 'wincmd w'
    elseif winnr != currentbuf && currentbuf != -1
      call cursor(1, 1)
      noautocmd execute currentbuf 'wincmd w'
    endif
  catch
  endtry
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
