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
                             :disable []}}))

  (nvim.set_keymap
    :n "<F2>"
    (.. ":setlocal foldexpr=nvim_treesitter#foldexpr()<CR>"
        ":setlocal foldmethod=expr<CR>")
    {:noremap true :silent true}))

(do ;; LSP setup
  (packadd! :nvim-lspconfig)
  (packadd! :cmp-nvim-lsp)

  (local lspconfig (require :lspconfig))
  (local cmp-nvim-lsp (require :cmp_nvim_lsp))

  (local servers [:rust_analyzer
                  :tsserver])

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
          (vim.lsp.with vim.lsp.handlers.hover {:border :rounded}))
    (tset vim.lsp.handlers :textDocument/signatureHelp
          (vim.lsp.with vim.lsp.handlers.hover {:border :rounded})))

  (let [capabilities (cmp-nvim-lsp.update_capabilities
                       (vim.lsp.protocol.make_client_capabilities))]

    (each [_ server (ipairs servers)]
      (let [server-setup (. (. lspconfig server) :setup)]
        (server-setup {:on_attach on-attach
                       :capabilities capabilities})))))

(do ;; cmp setup
  (packadd! :nvim-cmp)
  (packadd! :nvim-snippy)
  (packadd! :cmp-snippy)
  (local cmp (require :cmp))
  (local snippy (require :snippy))

  (cmp.setup
    {:completion {:autocomplete false}
     :snippet {:expand (fn [args]
                         (snippy.expand_snippet args.body))}
     :mapping {"<C-p>" (cmp.mapping.select_prev_item)
               "<C-n>" (cmp.mapping.select_next_item)
               "<CR>" (cmp.mapping.confirm
                        {:behavior cmp.ConfirmBehavior.Replace
                         :select true})
               "<Tab>" (fn [fallback]
                         (if (cmp.visible)
                           (cmp.confirm)
                           (fallback)))
               "<localleader><Tab>" (cmp.mapping.complete)
               }
     :sources (cmp.config.sources [{:name :nvim_lsp}]
                                  [{:name :buffer}])
     :experimental {:ghost_text true}}))
