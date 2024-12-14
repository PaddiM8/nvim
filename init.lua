-- keymaps to remember:
-- gcc: comment/uncomment code

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.lazy")

vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.wrap = false
vim.cmd([[colorscheme riderdark]])
vim.opt.fillchars = {eob = " "}
vim.opt.buftype = ""

vim.cmd([[hi Normal guibg=NONE ctermbg=NONE]])
vim.cmd([[hi NormalFloat guibg=NONE ctermbg=NONE]])
vim.cmd([[hi NonText guibg=NONE ctermbg=NONE]])
vim.cmd([[hi CursorLine guibg=NONE ctermbg=NONE]])
vim.cmd([[hi LineNr guibg=NONE ctermbg=NONE]])

-- basic editing
vim.keymap.set("i", "jk", "<Esc>", {})
vim.keymap.set("n", "<C-a>", vim.cmd.Ex)
vim.keymap.set("n", "<C-s>", ":w<cr>")

-- lsp
vim.keymap.set("n", "gd", vim.lsp.buf.definition)

-- fzf
local fzf = require("fzf-lua")
vim.keymap.set("n", "<leader>f", fzf.files)
vim.keymap.set("n", "<leader>g", function()
    fzf.live_grep({ multiline = 2 })
end)
vim.keymap.set("n", "<leader>p", function()
    fzf.live_grep({ multiline = 2, cwd = vim.fn.expand("%:p:h") })
end)
vim.keymap.set("n", "<leader>a", fzf.oldfiles)
vim.keymap.set("n", "<leader>r", function()
    fzf.lsp_document_symbols({ multiline = 2 })
end)
vim.keymap.set("n", "<leader>t", fzf.lsp_live_workspace_symbols)
