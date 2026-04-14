-- [nfnl] init.fnl
vim.cmd.runtime("colemak.vim")
vim.cmd.runtime("statusline.lua")
vim.g["maplocalleader"] = ","
vim.keymap.set("n", "<C-w>%", "<cmd>vsplit<cr>")
vim.keymap.set("n", "<C-w>\"", "<cmd>split<cr>")
vim.keymap.set("n", "<leader><space>", vim.cmd.nohlsearch)
vim.keymap.set("n", "<F4>", vim.cmd.qa)
vim.keymap.set("v", "<leader>y", "\"+y")
vim.o["relativenumber"] = true
vim.o["number"] = true
vim.o["splitright"] = true
vim.o["splitbelow"] = true
vim.o["ignorecase"] = true
vim.o["smartcase"] = true
vim.o["showmatch"] = true
vim.o["linebreak"] = true
vim.o["textwidth"] = 72
vim.opt.formatoptions:append("n")
vim.opt.formatoptions:append("1")
vim.opt.formatoptions:append("o")
vim.opt.formatoptions:append("r")
vim.o["tabstop"] = 2
vim.o["shiftwidth"] = 2
vim.o["softtabstop"] = 2
vim.o["expandtab"] = true
vim.opt.wildignore:append({"*/.git/*", "*/.hg/*", "*/.svn/*", "*.so", "*/node_modules/*"})
vim.opt.lispwords:append({"foreign-lambda", "foreign-lambda*", "module", "collect", "icollect", "each", "with-open"})
vim.o["mouse"] = nil
do
  local base24_setter = vim.fs.normalize("~/.vimrc_background")
  if (1 == vim.fn.filereadable(base24_setter)) then
    vim.opt.runtimepath:append("~/.local/share/base24/vim")
    vim.g["base16colorspace"] = 256
    vim.cmd.source(base24_setter)
  else
  end
end
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {})
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {})
local function on_lsp_attach(ev)
  vim["bo"][ev.buf]["omnifunc"] = "v:lua.vim.lsp.omnifunc"
  local opts = {buffer = ev.buf}
  local mappings = {gD = vim.lsp.buf.declaration, gd = vim.lsp.buf.definition, K = vim.lsp.buf.hover, gi = vim.lsp.buf.implementation, ["<C-k>"] = vim.lsp.buf.signature_help, ["<localleader>D"] = vim.lsp.buf.type_definition, ["<localleader>rn"] = vim.lsp.buf.rename, ["<localleader>ca"] = vim.lsp.buf.code_action, gr = vim.lsp.buf.references, ["<localleader>df"] = vim.diagnostic.open_float, ["<localleader>dq"] = vim.diagnostic.setloclist, ["<localleader>lf"] = vim.lsp.buf.format}
  for key, _function in pairs(mappings) do
    vim.keymap.set("n", key, _function, opts)
  end
  return nil
end
vim.api.nvim_create_autocmd("LspAttach", {group = vim.api.nvim_create_augroup("UserLspConfig", {}), callback = on_lsp_attach})
do
  local mason = require("mason")
  local mason_lspconfig = require("mason-lspconfig")
  mason.setup()
  mason_lspconfig.setup({automatic_enable = false})
  vim.lsp.enable("denols")
  vim.lsp.enable("fennel_ls")
  vim.lsp.enable("sourcekit")
end
do
  local formatter = require("formatter")
  local formatter_fish = require("formatter.filetypes.fish")
  formatter.setup({filetype = {fish = formatter_fish.fishindent}})
  vim.keymap.set("n", "<localleader>f", vim.cmd.Format, {})
end
do
  local lint = require("lint")
  lint.linters_by_ft = {fish = {"fish"}}
  local function _2_()
    return lint.try_lint()
  end
  vim.api.nvim_create_autocmd("BufWritePost", {group = vim.api.nvim_create_augroup("UserLint", {}), callback = _2_})
end
vim.g["conjure#log#wrap"] = true
vim.g["conjure#filetypes"] = {"clojure", "fennel", "janet"}
vim.g["conjure#filetype#fennel"] = "conjure.client.fennel.stdio"
do
  local oil = require("oil")
  oil.setup()
end
do
  local rainbow_delimiters = require("rainbow-delimiters")
  vim.g["rainbow_delimiters"] = {strategy = {[""] = rainbow_delimiters.strategy.global}, query = {[""] = "rainbow-delimiters"}}
end
vim.g["seiya_auto_enable"] = true
vim.g["seiya_target_highlights"] = {"Normal", "LineNr", "SignColumn", "CursorLineNr", "VertSplit", "NonText", "ALEWarningSign", "GitGutterAdd", "GitGutterChange", "GitGutterChangeDelete", "GitGutterDelete"}
do
  local builtin = require("telescope.builtin")
  vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
  vim.keymap.set("n", "<leader>fgf", builtin.git_files, {})
  vim.keymap.set("n", "<leader>flg", builtin.live_grep, {})
  vim.keymap.set("n", "<leader>b", builtin.buffers, {})
  vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
end
local function _3_()
  return vim.notify("Hey, you decided to use <leader>ff or <leader>fgf!")
end
vim.keymap.set("n", "<C-p>", _3_)
vim.g["sexp_filetypes"] = "clojure,scheme,lisp,fennel,janet"
local function binding(keys, command, description)
  if (nil == description) then
    _G.error("Missing argument description on /Users/awl/.config/nvim/init.fnl:238", 2)
  else
  end
  if (nil == command) then
    _G.error("Missing argument command on /Users/awl/.config/nvim/init.fnl:238", 2)
  else
  end
  if (nil == keys) then
    _G.error("Missing argument keys on /Users/awl/.config/nvim/init.fnl:238", 2)
  else
  end
  return {"n", ("<localleader>" .. keys), ("<cmd>" .. command .. "<cr>"), {desc = description}}
end
do
  local xcodebuild = require("xcodebuild")
  local local_keys = {binding("X", "XcodebuildPicker", "Show Xcodebuild actions"), binding("xf", "XcodebuildProjectManager", "Show Xcode Project Manager actions"), binding("xb", "XcodebuildBuild", "Build Xcode project"), binding("xB", "XcodebuildBuildForTesting", "Build Xcode project for testing"), binding("xr", "XcodebuildBuildRun", "Build and run Xcode project"), binding("xt", "XcodebuildTest", "Run Xcode project tests"), binding("xl", "XcodebuildToggleLogs", "Toggle Xcode logs"), binding("xd", "XcodebuildSelectDevice", "Select Xcode target device")}
  xcodebuild.setup()
  for _, setting in ipairs(local_keys) do
    vim.keymap.set(unpack(setting))
  end
end
vim.filetype.add({filename = {[".envrc"] = "sh", Appfile = "ruby", Brewfile = "ruby", Gemfile = "ruby", Fastfile = "ruby", PULLREQ_EDITMSG = "markdown"}, extension = {["do"] = "bash", etlua = "etlua", fnlm = "fennel", tf = "terraform", tfvars = "terraform"}})
local function _7_()
  vim.bo.commentstring = "-- %s"
  return nil
end
vim.api.nvim_create_autocmd("FileType", {pattern = "sql", callback = _7_})
do
  local non_wrapping = {"svelte", "swift", "terraform", "toml"}
  for _, pattern in ipairs(non_wrapping) do
    local function _8_()
      return vim.opt.formatoptions:remove("t")
    end
    vim.api.nvim_create_autocmd("FileType", {pattern = pattern, callback = _8_})
  end
end
local function _9_()
  vim.bo.expandtab = false
  vim.bo.tabstop = 4
  vim.bo.shiftwidth = 4
  return nil
end
return vim.api.nvim_create_autocmd("FileType", {pattern = "swift", callback = _9_})
