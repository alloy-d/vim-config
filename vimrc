" vim: set foldmethod=marker:

" Basics {{{
set shell=/bin/sh

" Don't try to be compatible with vi.
set nocompatible

" Add locally built base16 colors to the runtimepath.
set runtimepath+=~/.local/share/base16/vim,~/.local/share/base16/vim-airline-themes

" Load my key mappings for Colemak.
runtime colemak.vim

" Use , for local leader.
let maplocalleader = ","

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

" Open splits to the right and below, like tmux does.
set splitright
set splitbelow

" Enable filetype plugins.
filetype plugin on

" Instead of showing a line's absolute location in the file,
" show its distance relative to the current line.
set relativenumber
" ...but also show the number of the current line.
set number

" Highlight the current line.
"set cursorline

" Statusline
let s:enabling_airline = 0 "has('gui_running') || has('nvim')
if s:enabling_airline == 0
  runtime statusline.vim
end
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

" Miscellaneous filetype detection.
augroup extrafiletypedetect
  autocmd!

  " TypeScript + JSX
  autocmd BufEnter *.tsx,*.jsx setfiletype typescript.tsx

  " ASDF system definitions:
  autocmd BufEnter *.asd setfiletype lisp
  " LaTeX document class files:
  autocmd BufEnter *.cls setfiletype tex
  " Y86 assembly files:
  autocmd BufEnter *.ys setfiletype nasm
  " Markdown files:
  autocmd BufEnter *.md setfiletype markdown
  autocmd BufEnter PULLREQ_EDITMSG setfiletype markdown

  " Salt configuration files are YAML.
  autocmd BufEnter *.{sls} setfiletype yaml
  " Aurora files are Python.
  autocmd BufEnter *.{aurora} setfiletype python

  " Jenkinsfiles are Groovy [sic].
  autocmd BufEnter Jenkinsfile setfiletype groovy

  " JSON with comments:
  autocmd BufEnter package.json setfiletype jsonc
  autocmd BufEnter tsconfig.json setfiletype jsonc
augroup end

" These are the defaults, plus the new with-open and some extra testing macros I use.
let g:fennel_fuzzy_indent_patterns = [
      \ '^def',
      \ '^let',
      \ '^while',
      \ '^if',
      \ '^fn$',
      \ '^var$',
      \ '^case$',
      \ '^for$',
      \ '^each$',
      \ '^local$',
      \ '^global$',
      \ '^match$',
      \ '^macro',
      \ '^lambda$',
      \ '^with-open$',
      \ '^describe$',
      \ '^it$',
      \ '^context$',
      \ '^test$',
      \ '^each-root$'
      \ ]

" }}}

" Custom bindings {{{
" Make <leader><space> hide highlighting for search results.
nnoremap <leader><space> :nohlsearch<cr>

" Make Esc exit terminal mode.
tnoremap <Esc> <C-\><C-n>

" The only time you hit F1 is when you miss ESC.
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" Mirror tmux's split management bindings: {{{2
nnoremap <C-w>% :vsplit<cr>
nnoremap <C-w>" :split<cr>
" 2}}}

" }}}

" Plugin configuration {{{

" Rainbow parens {{{2
" Custom colors, mainly to get rid of black.
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]

au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
" 2}}}

" Seiya {{{2
" 1 => Automatically unset the BG for some highlights.
let g:seiya_auto_enable = 1

" Specifically, these highlights:
let g:seiya_target_highlights = [
      \ 'Normal',
      \ 'LineNr',
      \ 'SignColumn',
      \ 'CursorLineNr',
      \ 'VertSplit',
      \ 'NonText',
      \
      \ 'ALEWarningSign',
      \ 'GitGutterAdd',
      \ 'GitGutterChange',
      \ 'GitGutterChangeDelete',
      \ 'GitGutterDelete',
      \]

" 2}}}

" CtrlP {{{2
" Make CtrlP set its root directory to the Git or Hg root.
let g:ctrlp_working_path_mode = 2

" Ignore files in .gitignore.
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
" 2}}}

" tslime {{{2
vmap <C-c><C-c> <Plug>SendSelectionToTmux
nmap <C-c><C-c> <Plug>NormalModeSendToTmux
nmap <C-c>r <Plug>SetTmuxVars
" 2}}}

" ALE {{{2
" Only use fmt for terraform, not tflint.
let g:ale_linters = {
\   'python': ['flake8'],
\   'terraform': ['fmt'],
\   'typescript': ['typecheck', 'eslint'],
\}

let g:ale_fixers = {
\   'python': ['autopep8'],
\   'terraform': ['terraform'],
\   'typescript': ['eslint'],
\}
let g:ale_fix_on_save = 1
" 2}}}

" Airline {{{2
if has('nvim')
  let g:airline_theme = 'minimalist'
elseif has('gui_running')
  let g:airline_theme = 'base16'
endif

if s:enabling_airline
  let g:airline_powerline_fonts = 1
  let g:airline_left_sep = ''
  let g:airline_right_sep = ''

  packadd vim-airline
  packadd vim-airline-themes

  " Only show the status bar when split.
  set laststatus=1
endif
" 2}}}

" Vim-sexp {{{2
let g:sexp_filetypes = 'clojure,scheme,lisp,fennel,janet'
" 2}}}

" }}}

" GUI {{{

if has('gui_running')

  set guifont=Meslo\ LG\ M\ DZ\ Regular\ for\ Powerline:h14
  "colorscheme base16-harmonic-light
  "colorscheme base16-cupertino
  colorscheme base16-horizon-dark


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

  " Highlight the current line.
  set cursorline

  " Give the window 40 lines and 120 columns initially.
  set lines=40 columns=120

  " Use a visual bell instead of beeping.
  set visualbell
endif

" }}}

" Terminal {{{
if !has('gui_running')
  set bg=dark

  if filereadable(expand("~/.vimrc_background"))
    " If using base16-shell, this is set up for us.
    let base16colorspace=256
    source ~/.vimrc_background

    if s:enabling_airline
      AirlineTheme base16
    endif
  endif
endif
" }}}

" Probationary area {{{
"
" This is where I've quarantined all the cruft I suspect I don't want or
" need anymore.

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

" Use psc-ide's fast-rebuild feature to quickly check the current file.
let g:psc_ide_syntastic_mode = 1

" }}}
