;; vim: set foldmethod=marker:

;; {{{ Basics

(vim.cmd.runtime :colemak.vim)

(vim.keymap.set :n "<C-w>%" "<cmd>vsplit<cr>")
(vim.keymap.set :n "<C-w>\"" "<cmd>split<cr>") 

;; }}}

;; {{{ tree-sitter

(let [treesitter (require :nvim-treesitter.configs)]
  (treesitter.setup
    {:ensure_installed [:fennel :lua]
     :auto_install true
     :highlight {:enable true
                 ; Enable traditional syntax here when languages
                 ; need a little help with indenting:
                 :additional_vim_regex_highlighting [:fennel]}
     }))

;; }}}
