;; vim: set foldmethod=marker:

;;; Basics {{{

(vim.cmd.runtime :colemak.vim)
(vim.cmd.runtime :statusline.lua)

(tset vim.g :maplocalleader ",")

(vim.keymap.set :n "<C-w>%" "<cmd>vsplit<cr>")
(vim.keymap.set :n "<C-w>\"" "<cmd>split<cr>") 

(vim.keymap.set :n "<leader><space>" vim.cmd.nohlsearch)
(vim.keymap.set :n "<F4>" vim.cmd.qa)

(vim.keymap.set :v "<leader>y" "\"+y")  ; yank to clipboard

;; Show relative numbers, making it easier to jump up and down.
;; But also show the absolute number of the current line.
(tset vim.o :relativenumber true)
(tset vim.o :number true)

;; Open splits to the right and below, like tmux does.
(tset vim.o :splitright true)
(tset vim.o :splitbelow true)

;; Make search case-insensitive by default if the pattern contains
;; only lower-case characters.
(tset vim.o :ignorecase true)
(tset vim.o :smartcase true)

(tset vim.o :showmatch true)

;; Put backups and swap files

;; When wrapping lines for display, don't break them in the middle of a word.
(tset vim.o :linebreak true)

;;; Formatting options {{{
(tset vim.o :textwidth 72)

(vim.opt.formatoptions:append :n) ; recognize numbered lists
(vim.opt.formatoptions:append :1) ; break before single-letter words
(vim.opt.formatoptions:append :o) ; in comment: comment leader on o or O
(vim.opt.formatoptions:append :r) ; in comment: comment leader on return

(tset vim.o :tabstop 2)
(tset vim.o :shiftwidth 2)
(tset vim.o :softtabstop 2)
(tset vim.o :expandtab true)
;; }}}

(vim.opt.wildignore:append
  ["*/.git/*"
   "*/.hg/*"
   "*/.svn/*"
   "*.so"
   "*/node_modules/*"])

;; }}}

;;; UI stuff {{{

;; Mouse support prevents me from copying stuff anywhere in the window,
;; even in a different tmux pane.
(tset vim.o :mouse nil)

;; base16-shell manages ~/.vimrc_background, which tells vim to use
;; the same base16 colorscheme as everything else.
;;
;; I keep a bunch of base16 themes in ~/.local/share/base16,
;; so I just point the vim there to find the colorschemes.
(let [base16-setter (vim.fs.normalize "~/.vimrc_background")]
  (when (vim.fn.filereadable base16-setter)
    (vim.opt.runtimepath:append "~/.local/share/base16/vim")
    (tset vim.g :base16colorspace 256)
    (vim.cmd.source base16-setter)))

;; }}}

;;; tree-sitter {{{

(let [treesitter (require :nvim-treesitter.configs)]
  (treesitter.setup
    {:ensure_installed [:fennel :lua]
     :auto_install true
     :highlight {:enable true
                 ;; Enable traditional syntax here when languages
                 ;; need a little help with indenting:
                 :additional_vim_regex_highlighting [:fennel]}
     :indent {:enable true
              :disable [:fennel]}
     }))

;; }}}

;;; LSP & formatting {{{

;; TODO: set up global bindings for diagnostics?
;; (including moving the ones below?)

(fn on-lsp-attach [ev]
  (tset vim :bo ev.buf :omnifunc "v:lua.vim.lsp.omnifunc")

  (let [opts {:buffer ev.buf}
        mappings {"gD" vim.lsp.buf.declaration
                  "gd" vim.lsp.buf.definition
                  "K" vim.lsp.buf.hover
                  "gi" vim.lsp.buf.implementation
                  "<C-k>" vim.lsp.buf.signature_help
                  "<localleader>D" vim.lsp.buf.type_definition
                  "<localleader>rn" vim.lsp.buf.rename
                  "<localleader>ca" vim.lsp.buf.code_action
                  "gr" vim.lsp.buf.references
                  "<localleader>e" vim.diagnostic.open_float
                  "<localleader>q" vim.diagnostic.setloclist
                  "<localleader>lf" vim.lsp.buf.formatting}]
      (each [key function (pairs mappings)]
        (vim.keymap.set :n key function opts))))

(vim.api.nvim_create_autocmd
  :LspAttach
  {:group (vim.api.nvim_create_augroup :UserLspConfig {})
   :callback on-lsp-attach})

(let [mason (require :mason)
      mason-lspconfig (require :mason-lspconfig)
      lspconfig (require :lspconfig)]
  ;; Mason setup needs to happen before lspconfig setup.
  (mason.setup)
  (mason-lspconfig.setup)
  ; (lspconfig.fennel_language_server.setup {})
  (lspconfig.fennel_ls.setup {})
  (lspconfig.lua_ls.setup {})
  (lspconfig.tsserver.setup {}))

(let [formatter (require :formatter)
      formatter-fish (require :formatter.filetypes.fish)]
  (formatter.setup
    {:filetype {:fish formatter-fish.fishindent}})

  (vim.keymap.set :n "<localleader>f" vim.cmd.Format {}))

(let [lint (require :lint)]
  (tset lint :linters_by_ft
        {:fish [:fish]})

  (vim.api.nvim_create_autocmd
    :BufWritePost
    {:group (vim.api.nvim_create_augroup :UserLint {})
     :callback (fn [] (lint.try_lint))}))

;; }}}

;;; Various Plugins {{{

;; Conjure {{{2
(tset vim.g :conjure
      {:log {:wrap true}
       :filetype {:python false
                  :sql false}})
;; 2}}}

;; rainbow delimiters {{{2
(let [rainbow-delimiters (require :rainbow-delimiters)]
  (tset vim.g :rainbow_delimiters
        {:strategy {"" (. rainbow-delimiters.strategy :global)}
         :query {"" :rainbow-delimiters}}))
;; 2}}}

;; telescope {{{2
(let [builtin (require :telescope.builtin)]
  (vim.keymap.set :n "<leader>ff" builtin.find_files {})
  (vim.keymap.set :n "<leader>fgf" builtin.git_files {})
  (vim.keymap.set :n "<leader>flg" builtin.live_grep {})
  (vim.keymap.set :n "<leader>b" builtin.buffers {})
  (vim.keymap.set :n "<leader>fh" builtin.help_tags {}))

(vim.keymap.set :n "<C-p>" (fn [] (vim.notify "Hey, you decided to use <leader>ff or <leader>fgf!")))
;; 2}}}

;; vim-sexp {{{2
(tset vim.g :sexp_filetypes "clojure,scheme,lisp,fennel,janet")
;; 2}}}

;; }}}

;;; File type overrides {{{

(let [group (vim.api.nvim_create_augroup :ExtraFiletypeDetect {})
      types {".envrc"           :sh       ; direnv files
             "*.do"             :bash     ; redo files
             "PULLREQ_EDITMSG"  :markdown ; hub pull requests
             "Brewfile"         :ruby     ; DSL for `brew bundle`
             }]
  (each [pattern filetype (pairs types)]
    (vim.api.nvim_create_autocmd
      :BufEnter
      {: group
       : pattern
       :callback (fn []
                   (vim.cmd.setfiletype filetype))})))

;;; }}}
