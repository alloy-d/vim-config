" Use a base16 scheme.
"colorscheme base16-grayscale-light
colorscheme base16-classic-dark

" Use Menlo, for Powerline
"set gfn=Menlo\ Regular\ for\ Powerline:h14
set gfn=Meslo\ LG\ M\ DZ\ Regular\ for\ Powerline:h14

" Highlight the current line.
set cursorline

" Remove the menubar.
set guioptions-=m

" Remove the toolbar.
set guioptions-=T

" Remove the right scrollbar.
set guioptions-=r

" Remove the left scrollbar in split windows.
set guioptions-=L

" Use console dialogs instead of popups.
set guioptions+=c

" Give the window 40 lines and 120 columns initially.
set lines=40 columns=120

" Use a visual bell instead of beeping.
set visualbell

" Instead of showing a line's absolute location in the file,
" show its distance relative to the current line.
set relativenumber
" ...but also show the number of the current line.
set number

" Show the status bar all the time, for Powerline
set laststatus=2

" Use a transparent background
"set transparency=2

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
