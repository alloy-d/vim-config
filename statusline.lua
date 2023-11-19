-- [nfnl] Compiled from statusline.fnl by https://github.com/Olical/nfnl, do not edit.
vim.o["laststatus"] = 2
vim.o["statusline"] = ("%{%&modified?'%#MyStatusLineModified#%m':'%#MyStatusLinePlain#%m'%}" .. "%#MyStatusLineFilename#%.50f " .. "%#MyStatusLineBufferType#%h%w%q " .. "%=" .. "%#MyStatusLineFiletype#%{&filetype}" .. "%#MyStatusLinePlain# - " .. "%#MyStatusLineLineCol#%l" .. "%#MyStatusLinePlain#:" .. "%#MyStatusLineLineCol#%02v" .. "%#MyStatusLinePlain# - " .. "%#MyStatusLinePercentage#%P" .. "%#MyStatusLinePlain# of " .. "%#MyStatusLinePercentage#%L")
local function set_statusline_colors()
  local groups = {StatusLine = {"ctermfg=DarkMagenta", "ctermbg=NONE", "cterm=NONE", "guifg=DarkMagenta", "guibg=NONE", "gui=NONE"}, StatusLineNC = {"ctermfg=DarkGrey", "ctermbg=NONE", "cterm=bold", "guifg=DarkGrey", "guibg=NONE", "gui=bold"}, MyStatusLinePlain = {"ctermfg=DarkGrey", "ctermbg=NONE", "cterm=NONE", "guifg=DarkGrey", "guibg=NONE", "gui=NONE"}, MyStatusLineFilename = {"ctermfg=DarkRed", "ctermbg=NONE", "cterm=NONE", "guifg=DarkRed", "guibg=NONE", "gui=NONE"}, MyStatusLineBufferType = {"ctermfg=DarkCyan", "ctermbg=NONE", "cterm=NONE", "guifg=DarkCyan", "guibg=NONE", "gui=NONE"}, MyStatusLineFiletype = {"ctermfg=DarkMagenta", "ctermbg=NONE", "cterm=italic", "guifg=DarkMagenta", "guibg=NONE", "gui=italic"}, MyStatusLinePercentage = {"ctermfg=DarkYellow", "ctermbg=NONE", "cterm=NONE", "guifg=DarkYellow", "guibg=NONE", "gui=NONE"}, MyStatusLineLineCol = {"ctermfg=DarkGreen", "ctermbg=NONE", "cterm=NONE", "guifg=DarkGreen", "guibg=NONE", "gui=NONE"}, MyStatusLineModified = {"ctermfg=Red", "ctermbg=NONE", "cterm=NONE", "guifg=Red", "guibg=NONE", "gui=NONE"}}
  for name, args in pairs(groups) do
    vim.cmd.highlight(name, unpack(args))
  end
  return nil
end
return vim.api.nvim_create_autocmd("ColorScheme", {group = vim.api.nvim_create_augroup("MyStatuslineColors", {}), callback = set_statusline_colors})
