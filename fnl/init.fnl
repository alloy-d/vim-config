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
                               :disable [:fennel]}})))

(do ;; LSP setup
    (packadd! :nvim-lspconfig)
    (local lspconfig (require :lspconfig))

    (local servers [:pyls :tsserver])

    (fn on-attach [client bufnr]
      (fn buf-set-keymap [...]
        (vim.api.nvim_buf_set_keymap bufnr ...))
      (fn buf-set-option [...]
        (vim.api.nvim_buf_set_option bufnr ...))

      (buf-set-option :omnifunc "v:lua.vim.lsp.omnifunc")

      (let [opts {:noremap true :silent true}
            mappings {"gD" "<Cmd>lua vim.lsp.buf.declaration()<CR>"
                      "gd" "<Cmd>lua vim.lsp.buf.definition()<CR>"
                      "K" "<Cmd>lua vim.lsp.buf.hover()<CR>"
                      "gi" "<cmd>lua vim.lsp.buf.implementation()<CR>"
                      "<C-k>" "<cmd>lua vim.lsp.buf.signature_help()<CR>"
                      "<localleader>wa" "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>"
                      "<localleader>wr" "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>"
                      "<localleader>wl" "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>"
                      "<localleader>D" "<cmd>lua vim.lsp.buf.type_definition()<CR>"
                      "<localleader>rn" "<cmd>lua vim.lsp.buf.rename()<CR>"
                      "<localleader>ca" "<cmd>lua vim.lsp.buf.code_action()<CR>"
                      "gr" "<cmd>lua vim.lsp.buf.references()<CR>"
                      "<localleader>e" "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>"
                      "[d" "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>"
                      "]d" "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>"
                      "<localleader>q" "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>"
                      "<localleader>f" "<cmd>lua vim.lsp.buf.formatting()<CR>"}]
        (each [key command (pairs mappings)]
          (buf-set-keymap :n key command opts))))

    (each [_ server (ipairs servers)]
      (let [server-setup (. (. lspconfig server) :setup)]
        (server-setup {:on_attach on-attach}))))
