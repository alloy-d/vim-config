;; Run like this:
;; nvim --headless -c "luafile mason-setup.lua"
;;
;; it's not smart enough to quit on its own yet, so just wait until it
;; looks done. 

(local mason (require :mason))
(local mason-registry (require :mason-registry))

(mason.setup)
(mason-registry.refresh)

(let [packages (mason-registry.get_all_packages)]
  (vim.inspect packages))

(fn install-or-update [package-name]
  (let [package (mason-registry.get_package package-name)
        installed? (package:is_installed)]
    (fn install! []
      (vim.print (..  "going to install " package-name))
      (let [install (package:install)]
        (install:on :stdout vim.print)
        (install:on :stderr vim.print)
        (install:on "state:change"
                    (fn [old-state new-state]
                      (vim.inspect {: package-name : old-state : new-state})))))

    (vim.print {: package-name : installed?})
    (if (not installed?)
      (install!)
      (let [installed-version (package:get_installed_version)
            latest-version (package:get_latest_version)]
        (if (not= installed-version latest-version)
          (install!))))))

(install-or-update :eslint_d)
(install-or-update :eslint-lsp)
(install-or-update :lua-language-server)
(install-or-update :svelte-language-server)
(install-or-update :typescript-language-server)
