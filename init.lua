-- [nfnl] Compiled from init.fnl by https://github.com/Olical/nfnl, do not edit.
vim.cmd.runtime("colemak.vim")
vim.keymap.set("n", "<C-w>%", "<cmd>vsplit<cr>")
vim.keymap.set("n", "<C-w>\"", "<cmd>split<cr>")
local treesitter = require("nvim-treesitter.configs")
return treesitter.setup({ensure_installed = {"fennel", "lua"}, auto_install = true, highlight = {enable = true, additional_vim_regex_highlighting = {"fennel"}}})
