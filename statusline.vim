" Always show the status line.
set laststatus=2

function! SetModifiedSymbol(modified, modifiable) " {{{
    if a:modified == 1
        hi MyStatuslineModified ctermbg=NONE cterm=bold ctermfg=1
    elseif a:modifiable == 0
        hi MyStatuslineModified ctermbg=NONE cterm=bold ctermfg=3
    else
        hi MyStatuslineModified ctermbg=NONE cterm=bold ctermfg=8
    endif

    if a:modifiable == 1
      return '●'
    else
      return ''
    endif
endfunction
" }}}
function! SetFiletype(filetype) " {{{
  if a:filetype == ''
      return '-'
  else
      return a:filetype
  endif
endfunction
" }}}

" Statusbar items
" ====================================================================
"
set statusline=""
" Left side items
" =======================
" Modified status
set statusline+=%#MyStatuslinePlain#‹
set statusline+=%#MyStatuslineModified#%{SetModifiedSymbol(&modified,&modifiable)}
set statusline+=%#MyStatuslinePlain#›\ 
" Filename
set statusline+=%#MyStatuslineFilename#%.20f
" Buffer/window type
set statusline+=\ %#MyStatuslineBufferType#%h%w

" Right side items
" =======================
set statusline+=%=
" Filetype
set statusline+=%#MyStatuslineFiletype#%{SetFiletype(&filetype)}
" Padding
set statusline+=%#MyStatuslinePlain#\ ⋯\ 
" Line and Column
set statusline+=%#MyStatuslineLineCol#%l
set statusline+=%#MyStatuslinePlain#:
set statusline+=%#MyStatuslineLineCol#%02c
" Padding
set statusline+=%#MyStatuslinePlain#\ ⋯\ 
" Current scroll percentage and total lines of the file
set statusline+=%#MyStatuslinePercentage#%P
set statusline+=%#MyStatuslinePlain#∙
set statusline+=%#MyStatuslinePercentage#%L

" Set up the colors:
augroup statuslinecolors
  autocmd!

  autocmd ColorScheme * hi StatusLine          ctermfg=5     ctermbg=NONE     cterm=NONE
  autocmd ColorScheme * hi StatusLineNC        ctermfg=8     ctermbg=1     cterm=bold

  autocmd ColorScheme * hi MyStatuslinePlain ctermfg=8 cterm=NONE ctermbg=NONE

  autocmd ColorScheme * hi MyStatuslineFilename ctermfg=4 cterm=NONE ctermbg=NONE

  autocmd ColorScheme * hi MyStatuslineBufferType ctermfg=3 cterm=NONE ctermbg=NONE

  autocmd ColorScheme * hi MyStatuslineFiletype ctermfg=5 cterm=italic ctermbg=0

  autocmd ColorScheme * hi MyStatuslinePercentage ctermbg=NONE cterm=NONE ctermfg=6

  autocmd ColorScheme * hi MyStatuslineLineCol ctermbg=NONE cterm=NONE ctermfg=2
augroup end
