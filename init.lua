-- [nfnl] Compiled from init.fnl by https://github.com/Olical/nfnl, do not edit.
vim.cmd.runtime("colemak.vim")
vim.cmd.runtime("statusline.lua")
do end (vim.g)["maplocalleader"] = ","
vim.keymap.set("n", "<C-w>%", "<cmd>vsplit<cr>")
vim.keymap.set("n", "<C-w>\"", "<cmd>split<cr>")
vim.keymap.set("n", "<leader><space>", vim.cmd.nohlsearch)
vim.keymap.set("n", "<F4>", vim.cmd.qa)
vim.keymap.set("v", "<leader>y", "\"+y")
do end (vim.o)["relativenumber"] = true
vim.o["number"] = true
vim.o["splitright"] = true
vim.o["splitbelow"] = true
vim.o["ignorecase"] = true
vim.o["smartcase"] = true
vim.o["showmatch"] = true
vim.o["linebreak"] = true
vim.o["textwidth"] = 72
do end (vim.opt.formatoptions):append("n")
do end (vim.opt.formatoptions):append("1")
do end (vim.o)["tabstop"] = 2
vim.o["shiftwidth"] = 2
vim.o["softtabstop"] = 2
vim.o["expandtab"] = true
do end (vim.opt.wildignore):append({"*/.git/*", "*/.hg/*", "*/.svn/*", "*.so", "*/node_modules/*"})
do end (vim.o)["mouse"] = nil
do
  local base16_setter = vim.fs.normalize("~/.vimrc_background")
  if vim.fn.filereadable(base16_setter) then
    do end (vim.opt.runtimepath):append("~/.local/share/base16/vim")
    do end (vim.g)["base16colorspace"] = 256
    vim.cmd.source(base16_setter)
  else
  end
end
do
  local treesitter = require("nvim-treesitter.configs")
  treesitter.setup({ensure_installed = {"fennel", "lua"}, auto_install = true, highlight = {enable = true, additional_vim_regex_highlighting = {"fennel"}}})
end
local function on_lsp_attach(ev)
  vim["bo"][ev.buf]["omnifunc"] = "v:lua.vim.lsp.omnifunc"
  local opts = {buffer = ev.buf}
  local mappings = {gD = vim.lsp.buf.declaration, gd = vim.lsp.buf.definition, K = vim.lsp.buf.hover, gi = vim.lsp.buf.implementation, ["<C-k>"] = vim.lsp.buf.signature_help, ["<localleader>D"] = vim.lsp.buf.type_definition, ["<localleader>rn"] = vim.lsp.buf.rename, ["<localleader>ca"] = vim.lsp.buf.code_action, gr = vim.lsp.buf.references, ["<localleader>e"] = vim.diagnostic.open_float, ["<localleader>q"] = vim.diagnostic.setloclist, ["<localleader>f"] = vim.lsp.buf.formatting}
  for key, _function in pairs(mappings) do
    vim.keymap.set("n", key, _function, opts)
  end
  return nil
end
vim.api.nvim_create_autocmd("LspAttach", {group = vim.api.nvim_create_augroup("UserLspConfig", {}), callback = on_lsp_attach})
do
  local lspconfig = require("lspconfig")
  lspconfig.fennel_ls.setup({})
end
vim.g["conjure"] = {log = {wrap = true}, filetype = {python = false, sql = false}}
do
  local rainbow_delimiters = require("rainbow-delimiters")
  do end (vim.g)["rainbow_delimiters"] = {strategy = {[""] = rainbow_delimiters.strategy.global}, query = {[""] = "rainbow-delimiters"}}
end
do
  local builtin = require("telescope.builtin")
  vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
  vim.keymap.set("n", "<leader>fgf", builtin.git_files, {})
  vim.keymap.set("n", "<leader>flg", builtin.live_grep, {})
  vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
  vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
end
local function _2_()
  return vim.notify("Hey, you decided to use <leader>ff or <leader>fgf!")
end
vim.keymap.set("n", "<C-p>", _2_)
do end (vim.g)["sexp_filetypes"] = "clojure,scheme,lisp,fennel,janet"
return nil
