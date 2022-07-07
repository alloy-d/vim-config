" Adam Lloyd <adam@alloy-d.net>
"
" Vim-friendly keybindings for Colemak.
"
" Remaps as few commands as possible with a goal of keeping the most
" important keys (the movement keys) in the same physical place.


" Searching {{{1
" Use k to go to the next match.
nnoremap k n
vnoremap k n


" Movement {{{1

" Normal mode:
nnoremap n j
nnoremap e k
nnoremap i l

" Visual mode:
vnoremap n j
vnoremap e k
vnoremap i l

" Moving among splits:
nnoremap <C-w>n <C-w>j
nnoremap <C-w>e <C-w>k
nnoremap <C-w>i <C-w>l


" Insertion {{{1
" Use s to enter insert mode, rather than i.
vnoremap s i
vnoremap S I
nnoremap s i
nnoremap S I
omap s i
omap S I

" vi:fdm=marker
