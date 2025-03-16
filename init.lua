-- keymaps to remember:
-- gc: comment/uncomment selected
-- gcc: comment/uncomment line

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.lazy")

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  desc = "Prevent colorscheme clearing self-defined DAP marker colors",
  callback = function()
      vim.api.nvim_set_hl(0, "DapStopped", { bg = "#2e4d3d", ctermbg = "Green" })
      vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#c23127", bg = "NONE", ctermbg = "NONE" })
      vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#888ca6", bg = "NONE", ctermbg = "NONE" })
      vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef", bg = "NONE", ctermbg = "NONE" })
  end
})

vim.cmd.colorscheme(vim.g.colors_name)

vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.wrap = false
vim.cmd([[colorscheme riderdark]])
vim.opt.fillchars = {eob = " "}
vim.opt.buftype = ""
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.cmdheight = 2
vim.opt.hidden = true -- for toggleterm.nvim

vim.cmd([[
    hi Normal guibg=NONE ctermbg=NONE
    hi NonText guibg=NONE ctermbg=NONE
    hi CursorLine guibg=NONE ctermbg=NONE
    hi LineNr guibg=NONE ctermbg=NONE
    hi PmenuSel guibg='#525252'

    hi link FzfLuaNormal NormalFloat
    hi link FzfLuaBorder FloatBorder

    hi SatelliteBar guibg=#424242

    hi link @lsp.type.extensionMethod Function
    hi DiagnosticUnderlineError guisp='#b91c1c' gui=undercurl
    hi DiagnosticUnderlineWarn guisp='#eab308' gui=undercurl
    hi SatelliteDiagnosticError guifg='#b91c1c'
    hi SatelliteDiagnosticWarn guifg='#eab308'

    highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
    highlight! CmpItemAbbrMatch guibg=NONE guifg=#569cd6
    highlight! link CmpItemAbbrMatchFuzzy CmpItemAbbrMatch

    highlight! CmpItemKindVariable guibg=NONE guifg=#9cdcfE
    highlight! link CmpItemKindInterface CmpItemKindVariable
    highlight! link CmpItemKindText CmpItemKindVariable

    highlight! CmpItemKindFunction guibg=NONE guifg=#c586c0
    highlight! link CmpItemKindMethod CmpItemKindFunction

    highlight! CmpItemKindKeyword guibg=NONE guifg=#d4d4d4
    highlight! link CmpItemKindProperty CmpItemKindKeyword
    highlight! link CmpItemKindUnit CmpItemKindKeyword

    set termguicolors
]])

-- close quickfix list on enter
vim.api.nvim_create_autocmd(
  "FileType", {
  pattern={"qf"},
  command=[[nnoremap <buffer> <CR> <CR>:cclose<CR>]]})

-- start in insert mode in terminals
vim.cmd[[autocmd BufWinEnter,WinEnter term://* startinsert]]
vim.cmd[[autocmd BufWinEnter,WinEnter [dap-terminal]* startinsert]]

-- highlight yanked text for 200ms using the "Visual" highlight group
vim.cmd[[
    augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=100})
    augroup END
]]

local keybinds = require("keybinds")
keybinds.basics()
keybinds.ui()
