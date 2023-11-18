;; vim: set foldmethod=marker:

;;; Basics {{{

(vim.cmd.runtime :colemak.vim)

(tset vim.g :maplocalleader ",")

(vim.keymap.set :n "<C-w>%" "<cmd>vsplit<cr>")
(vim.keymap.set :n "<C-w>\"" "<cmd>split<cr>") 

(tset vim.o :relativenumber true)
(tset vim.o :number true)

;; Open splits to the right and below, like tmux does.
(tset vim.o :splitright true)
(tset vim.o :splitbelow true)

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
     }))

;; }}}

;;; LSP {{{

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
                  "<localleader>f" vim.lsp.buf.formatting}]
      (each [key function (pairs mappings)]
        (vim.keymap.set :n key function opts))))

(vim.api.nvim_create_autocmd
  :LspAttach
  {:group (vim.api.nvim_create_augroup :UserLspConfig {})
   :callback on-lsp-attach})

(let [lspconfig (require :lspconfig)]
  (lspconfig.fennel_ls.setup {}))

;; }}}
