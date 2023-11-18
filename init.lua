-- [nfnl] Compiled from init.fnl by https://github.com/Olical/nfnl, do not edit.
vim.cmd.runtime("colemak.vim")
do end (vim.g)["maplocalleader"] = ","
vim.keymap.set("n", "<C-w>%", "<cmd>vsplit<cr>")
vim.keymap.set("n", "<C-w>\"", "<cmd>split<cr>")
do end (vim.o)["relativenumber"] = true
vim.o["number"] = true
vim.o["splitright"] = true
vim.o["splitbelow"] = true
vim.o["mouse"] = nil
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
local lspconfig = require("lspconfig")
return lspconfig.fennel_ls.setup({})
