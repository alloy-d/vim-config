-- [nfnl] Compiled from mason-setup.fnl by https://github.com/Olical/nfnl, do not edit.
local mason = require("mason")
local mason_registry = require("mason-registry")
mason.setup()
mason_registry.refresh()
do
  local packages = mason_registry.get_all_packages()
  vim.inspect(packages)
end
local function install_or_update(package_name)
  local package = mason_registry.get_package(package_name)
  local installed_3f = package:is_installed()
  local function install_21()
    vim.print("going to install", package_name)
    local install = package:install()
    install:on("stdout", vim.print)
    install:on("stderr", vim.print)
    local function _1_(old_state, new_state)
      return vim.inspect({["package-name"] = package_name, ["old-state"] = old_state, ["new-state"] = new_state})
    end
    return install:on("state:change", _1_)
  end
  vim.print({["package-name"] = package_name, ["installed?"] = installed_3f})
  if not installed_3f then
    return install_21()
  else
    local function _2_(success, new_version)
      if success then
        return install_21()
      else
        return vim.print(package_name, new_version)
      end
    end
    return package:check_new_version(_2_)
  end
end
install_or_update("eslint_d")
install_or_update("eslint-lsp")
install_or_update("lua-language-server")
install_or_update("fennel-language-server")
return install_or_update("typescript-language-server")
