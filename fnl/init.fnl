(module init
        {autoload {a aniseed.core
                   nvim aniseed.nvim}})

(macro packadd! [...]
  `(nvim.ex.packadd_ ,...))

(do ;; tree-sitter setup
    (packadd! :nvim-treesitter)

    (let [configs (require :nvim-treesitter.configs)]
      (configs.setup {:ensure_installed :maintained
                      :highlight {:enable true}
                      :indent {:enable true
                               :disable [:fennel :typescript]}}))

    (nvim.set_keymap
      :n "<F2>"
      (.. ":setlocal foldexpr=nvim_treesitter#foldexpr()<CR>"
          ":setlocal foldmethod=expr<CR>")
      {:noremap true :silent true}))

(do ;; LSP setup
    (packadd! :nvim-lspconfig)
    (local lspconfig (require :lspconfig))

    (local servers [:pyls :tsserver])

    (local border
      [["🭽" :FloatBorder]
       ["▔" :FloatBorder]
       ["🭾" :FloatBorder]
       ["▕" :FloatBorder]
       ["🭿" :FloatBorder]
       ["▁" :FloatBorder]
       ["🭼" :FloatBorder]
       ["▏" :FloatBorder]])

    (vim.cmd
      "autocmd ColorScheme * highlight NormalFloat guibg=DarkGrey")
    (vim.cmd
      "autocmd ColorScheme * highlight FloatBorder guibg=DarkGrey guifg=white")

    (fn on-attach [client bufnr]
      (fn buf-set-keymap [...]
        (vim.api.nvim_buf_set_keymap bufnr ...))
      (fn buf-set-option [...]
        (vim.api.nvim_buf_set_option bufnr ...))

      (buf-set-option :omnifunc "v:lua.vim.lsp.omnifunc")

      (let [opts {:noremap true :silent true}
            mappings {"gD" :vim.lsp.buf.declaration
                      "gd" :vim.lsp.buf.definition
                      "K" :vim.lsp.buf.hover
                      "gi" :vim.lsp.buf.implementation
                      "<C-k>" :vim.lsp.buf.signature_help
                      "<localleader>wa" :vim.lsp.buf.add_workspace_folder
                      "<localleader>wr" :vim.lsp.buf.remove_workspace_folder
                      "<localleader>D" :vim.lsp.buf.type_definition
                      "<localleader>rn" :vim.lsp.buf.rename
                      "<localleader>ca" :vim.lsp.buf.code_action
                      "gr" :vim.lsp.buf.references
                      "<localleader>e" :vim.lsp.diagnostic.show_line_diagnostics
                      "[d" :vim.lsp.diagnostic.goto_prev
                      "]d" :vim.lsp.diagnostic.goto_next
                      "<localleader>q" :vim.lsp.diagnostic.set_loclist
                      "<localleader>f" :vim.lsp.buf.formatting}]
        (each [key function-name (pairs mappings)]
          (let [command (.. "<cmd>lua " function-name "()<CR>")]
            (buf-set-keymap :n key command opts))))

      (tset vim.lsp.handlers :textDocument/hover
            (vim.lsp.with vim.lsp.handlers.hover {: border}))
      (tset vim.lsp.handlers :textDocument/signatureHelp
            (vim.lsp.with vim.lsp.handlers.hover {: border})))

    (each [_ server (ipairs servers)]
      (let [server-setup (. (. lspconfig server) :setup)]
        (server-setup {:on_attach on-attach}))))
