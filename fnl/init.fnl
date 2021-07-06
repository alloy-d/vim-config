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

    (each [_ server (ipairs servers)]
      (let [server-setup (. (. lspconfig server) :setup)]
        (server-setup {}))))
