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
      (let [install (package:install)]
        ; (install:on :stdout vim.print)
        ; (install:on :stderr vim.print)
        (install:on "state:change"
                    (fn [old-state new-state]
                      (vim.print {: package-name : old-state : new-state})))))

    (vim.print {: package-name : installed?})
    (if (not installed?)
      (install!)
      (package:check_new_version
        (fn [success new-version]
          (if success
            (install!)
            (vim.print package-name new-version)))))))

(install-or-update :fennel-language-server)
(install-or-update :lua-language-server)
