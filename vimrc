" vim: set foldmethod=marker:

" Basics {{{
set shell=/bin/sh

" Don't try to be compatible with vi.
set nocompatible

" Load my key mappings for Colemak.
runtime colemak.vim

" Use utf-8 by default.
set encoding=utf-8

" Don't unload buffers when they're abandoned.
set hidden

" Show commands in progress.
set showcmd

" Show completion options above the command line.
set wildmenu

" When using tab completion:
" first complete to the options' longest common substring,
" then complete each option in full.
set wildmode=longest,full

" Send more data when redrawing the window.
set ttyfast

" Put location information in the status line.
set ruler

" Don't redraw during macros.
set lazyredraw

" Allow backspacing over indentations, ends of lines,
" and the start of insertion.
set backspace=indent,eol,start

" Make search case-insensitive if the search term is lower-case.
" Otherwise, make the search case-sensitive.
set ignorecase
set smartcase

" Apply substitutions globally.
set gdefault

" Do incremental searching as you type.
set incsearch

" Highlight search matches.
set hlsearch

" Jump to matching bracket when inserting its pair.
set showmatch

" Wrap long lines to display them, if needed.
set wrap

" ...at sensible, not-in-the-middle-of-a-word points.
set linebreak

" Use 72-character lines as our ideal.
set textwidth=72

" Put backups and swap files somewhere else.
set backup
set swapfile
set backupdir=~/.vim-tmp
set directory=~/.vim-tmp

" Do not automatically reformat lines that were too long before
" insert mode was started.
set formatoptions+=l

" Recognize numbered lists when formatting text.
set formatoptions+=n

" Don't break lines after a single-letter word if possible.
set formatoptions+=1

" Don't automatically format text by default.
" (More often than not, I write code, so it makes sense
" to tune this for text files instead.)
set formatoptions-=t

" Remove comment leaders when joining comment lines.
set formatoptions+=j

" *Do* automatically format text for plaintext files.
"autocmd BufEnter *.{txt} setlocal formatoptions+=ta
"
" Save buffers when hidden.
set autowrite

" Ignore some common files when globbing.
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*.so,*/node_modules/*
" }}}

" Indentation {{{
"
" Use two-space-wide tabs by default, and indent with spaces.
set tabstop=2
" These commented-out settings are managed by vim-sleuth:
"set shiftwidth=2
"set softtabstop=2
"set expandtab

" Do automatic indenting.
set autoindent
" Also do smart indenting.
set smartindent

" ...but not in plaintext or Markdown files.
autocmd BufEnter *.{txt,md,markdown} setlocal nosmartindent

" For C files, use cindent.
autocmd BufEnter *.{c,h} setlocal cindent

" For lispy languages, use lisp indenting.
autocmd BufEnter *.{lisp,scheme,ss,scm,el} setlocal lisp
" }}}

" File type overrides {{{
" Salt configuration files are YAML.
autocmd BufEnter *.{sls} setlocal filetype=yaml

" Aurora files are Python.
autocmd BufEnter *.{aurora} setlocal filetype=python


" Miscellaneous filetype detection.
augroup filetypedetect

" LaTeX document class files:
autocmd BufEnter *.cls setfiletype tex
" Y86 assembly files:
autocmd BufEnter *.ys setfiletype nasm
" Markdown files:
autocmd BufEnter *.md setfiletype markdown

augroup end
" }}}

" Custom bindings {{{
" Make <leader><space> hide highlighting for search results.
nnoremap <leader><space> :nohlsearch<cr>

" The only time you hit F1 is when you miss ESC.
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>
" }}}

" Plugin configuration {{{

" Rainbow parens {{{2
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
" 2}}}

" CtrlP {{{2
" Make CtrlP set its root directory to the Git or Hg root.
let g:ctrlp_working_path_mode = 2
" 2}}}

" ALE {{{2
" Only use fmt for terraform, not tflint.
let g:ale_linters = {
\   'terraform': ['fmt'],
\}

let g:ale_fixers = {
\   'terraform': ['terraform'],
\   'typescript': ['prettier'],
\}
let g:ale_fix_on_save = 1
" 2}}}

" }}}

" Probationary area {{{
"
" This is where I've quarantined all the cruft I suspect I don't want or
" need anymore.

" Add some mappings for fugitive's git commands.
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gd :Gdiff<CR>

" Add a mapping for ack.
nnoremap <leader>a :Ack

" Save everything when Vim loses focus.
autocmd FocusLost * :wa

"Abolish com{apn,pna}{y,ies} com{pan}{}

let g:vimclojure#FuzzyIndent=1


" Use tmux instead of screen with slime.
let g:slime_target = "tmux"


" Use JSX in all the JavaScript files!
let g:jsx_ext_required = 0

" Use syntastic's recommended defaults.
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Enable integration with Merlin.
let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"
let g:syntastic_ocaml_checkers = ['merlin']

" Use psc-ide's fast-rebuild feature to quickly check the current file.
let g:psc_ide_syntastic_mode = 1

" }}}
