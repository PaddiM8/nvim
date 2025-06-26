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
vim.opt.shellredir = "| append "
vim.opt.shellpipe = "| write "
vim.opt.hidden = true -- for toggleterm.nvim
vim.opt.cinoptions = "(s,m1" -- prevent odd indentation for closing parentheses
vim.opt.smartindent = false
vim.g.netrw_keepdir = 1

-- vim.cmd[[set messagesopt=wait:5000,history:500]]

-- highlight yanked text for 100ms using the "Visual" highlight group
vim.cmd[[
    augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=100})
    augroup END
]]

-- auto save
vim.opt.autowrite = true
vim.cmd([[au BufLeave * silent! wall]])

vim.api.nvim_create_autocmd("FileType", {
    pattern = "cs",
    callback = function()
        vim.cmd("compiler dotnet")
    end,
})

vim.cmd([[
    hi Normal guibg=NONE ctermbg=NONE
    hi NonText guibg=NONE ctermbg=NONE
    hi CursorLine guibg=NONE ctermbg=NONE
    hi LineNr guibg=NONE ctermbg=NONE
    hi! Pmenu guibg=#212121 guifg=#eeeeee
    hi! PmenuSel guifg=#525252
    hi! PmenuSbar guibg=#525252
    hi! link NormalFloat Pmenu

    hi link FzfLuaNormal NormalFloat
    hi link FzfLuaBorder FloatBorder

    hi SatelliteBar guibg=#424242
    hi WinSeparator guifg=#313131
    hi TabLineFill guibg=#212121
    hi DiffDelete guibg=#181818 guifg=#424242
    hi DiffText guibg=#757575
    hi Folded guibg=NONE

    highlight LspCodeLens guifg=#555555
    hi link @lsp.type.extensionMethod @lsp.type.function
    hi link @lsp.type.recordClass @lsp.type.class
    hi link @lsp.type.property Constant
    hi link @lsp.type.controlKeyword Keyword
    hi DiagnosticUnderlineError guisp=#b91c1c gui=undercurl
    hi DiagnosticUnderlineWarn guisp=#eab308 gui=undercurl
    hi SatelliteDiagnosticError guifg=#b91c1c
    hi SatelliteDiagnosticWarn guifg=#eab308

    hi! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
    hi! CmpItemAbbrMatch guibg=NONE guifg=#569cd6
    hi! link CmpItemAbbrMatchFuzzy CmpItemAbbrMatch

    hi! CmpItemKindVariable guibg=NONE guifg=#9cdcfE
    hi! link CmpItemKindInterface CmpItemKindVariable
    hi! link CmpItemKindText CmpItemKindVariable

    hi! CmpItemKindFunction guibg=NONE guifg=#c586c0
    hi! link CmpItemKindMethod CmpItemKindFunction

    hi! CmpItemKindKeyword guibg=NONE guifg=#d4d4d4
    hi! link CmpItemKindProperty CmpItemKindKeyword
    hi! link CmpItemKindUnit CmpItemKindKeyword

    set termguicolors
]])

-- close quickfix list on enter
vim.api.nvim_create_autocmd(
  "FileType", {
  pattern={"qf"},
  command=[[nnoremap <buffer> <CR> <CR>:cclose<CR>]]})

-- start in insert mode in terminals
vim.cmd[[autocmd BufWinEnter,WinEnter term://* startinsert]]
vim.cmd[[autocmd BufWinEnter,WinEnter \[dap-terminal\]* startinsert]]

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
