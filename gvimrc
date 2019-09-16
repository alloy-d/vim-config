" Use Solarized colors.
"set bg=dark
"colorscheme solarized

" Use Molokai.
"let g:molokai_original=1
"colorscheme molokai

" Use Bad Wolf.
"let g:badwolf_darkgutter=1
"colorscheme badwolf

" Use a base16 scheme.
"colorscheme base16-flat
"colorscheme base16-grayscale-light
colorscheme base16-classic-dark

" Use Monaco.
"set gfn=Monaco:h12

" Use Menlo, for Powerline
"set gfn=Menlo\ Regular\ for\ Powerline:h14
set gfn=Meslo\ LG\ M\ DZ\ Regular\ for\ Powerline:h14

" Use PT Mono
"set gfn=PT\ Mono:h18

" Use... Courier? O_o
"set gfn=Courier:h14

" Use Inconsolata
"set gfn=Inconsolata:h16

" Use Source Code Pro
"set gfn=Source\ Code\ Pro\ Light:h14
"set gfn=Sauce\ Code\ Powerline\ Light:h14

" Use Fira Code
"set gfn=Fira\ Code\ Retina:h14

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
