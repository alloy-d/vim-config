(module init
  {autoload {a aniseed.core
             nvim aniseed.nvim}})

(macro packadd! [...]
  `(nvim.ex.packadd_ ,...))

;; Point neovim to a special python virtualenv just for it.
;; This allows working within python codebases' virtualenvs without
;; having to mangle them with neovim-specific stuff.
(let [nvim-venv-bin (nvim.fn.expand "~/.config/nvim/neovim-venv/bin/")]
  (tset nvim.g :python3_host_prog (.. nvim-venv-bin "python"))
  (tset nvim.env :PATH (.. nvim-venv-bin ":" nvim.env.PATH)))

(do ;; tree-sitter setup
  (packadd! :nvim-treesitter)

  (let [configs (require :nvim-treesitter.configs)]
    (configs.setup {:ensure_installed :all
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
  (packadd! :rust-tools.nvim)

  (local lspconfig (require :lspconfig))
  (local cmp-nvim-lsp (require :cmp_nvim_lsp))

  (local servers {:denols {:autostart false
                           :init_options {:enable true :lint true}
                           :root_dir (lspconfig.util.root_pattern "deno.json" "deno.jsonc")}
                  ; :pylsp {:settings {:pylsp {:configurationSources [:flake8 :mypy]
                  ;                            :plugins {:flake8 {:config ".flake8" :enabled true}
                  ;                                      :black {:enabled true}
                  ;                                      :pycodestyle {:enabled false}
                  ;                                      :pylint {:enabled false}}
                  ;                            :formatCommand [:black]}}}
                  :pyright {}
                  ;:rust_analyzer => set up separately below because rust-tools is "helpful"
                  :tsserver {:root_dir (lspconfig.util.root_pattern "tsconfig.json" "package.json")}})

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
                       (vim.lsp.protocol.make_client_capabilities))
        make-config (fn [?extra-config]
                      (let [config {:on_attach on-attach
                                  :capabilities capabilities}]
                        (when ?extra-config
                          (each [key value (pairs ?extra-config)]
                            (tset config key value)))

                        config))]

    (each [server extra-config (pairs servers)]
      (let [server-setup (. (. lspconfig server) :setup)
            server-config (make-config extra-config)]
        ; This lovely hack removes the ambiguity of whether I want to
        ; format with tsserver or null-ls.  I never want tsserver.
        (when (= server :tsserver)
          (let [default-on-attach server-config.on_attach
                hacked-on-attach (fn [client bufnr]
                                   (tset client.resolved_capabilities :document_formatting false)
                                   (tset client.resolved_capabilities :document_range_formatting false)
                                   (default-on-attach client bufnr))]
            (tset server-config :on_attach hacked-on-attach)))
        (server-setup server-config)))

    ;; rust-tools configures rust-analyzer, so we have to set it up here.
    (let [rust-tools (require :rust-tools)]
      (rust-tools.setup
        {:server (make-config)}))))

(do ;; null-ls setup
  (packadd! :plenary.nvim)
  (packadd! :null-ls.nvim)
  (local null-ls (require :null-ls))
  (local sources
    [null-ls.builtins.formatting.prettier])

  (null-ls.setup { : sources }))

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
