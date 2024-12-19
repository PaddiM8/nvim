-- keymaps to remember:
-- gc: comment/uncomment selected
-- gcc: comment/uncomment line

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
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.cmdheight = 2

vim.cmd([[
    hi Normal guibg=NONE ctermbg=NONE
    hi NonText guibg=NONE ctermbg=NONE
    hi CursorLine guibg=NONE ctermbg=NONE
    hi LineNr guibg=NONE ctermbg=NONE

    hi link FzfLuaNormal NormalFloat
    hi link FzfLuaBorder FloatBorder

    hi SatelliteBar guibg=#424242

    hi link @lsp.type.extensionMethod Function
    hi DiagnosticUnderlineError guisp='#b91c1c' gui=undercurl
    hi DiagnosticUnderlineWarn guisp='#eab308' gui=undercurl
    hi SatelliteDiagnosticError guifg='#b91c1c'
    hi SatelliteDiagnosticWarn guifg='#eab308'

    set termguicolors
]])

-- basic editing
vim.keymap.set("i", "jk", "<Esc>", {})
vim.keymap.set("n", "<C-a>", vim.cmd.Ex)
vim.keymap.set("n", "<C-s>", ":w<cr>")
vim.keymap.set("n", "<C-j>", vim.cmd.pop)
vim.keymap.set("n", "<C-k>", vim.cmd.tag)

-- lsp
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("i", "<C-q>", vim.lsp.buf.signature_help)
vim.keymap.set("n", "W", vim.diagnostic.open_float)
vim.keymap.set("n", "<C-p>", function()
    vim.diagnostic.goto_next({ severity = "ERROR" })
end)
vim.keymap.set("n", "<C-å>", function()
    vim.diagnostic.goto_prev({ severity = "ERROR" })
end)

vim.diagnostic.config({
    underline = {
        severity = { min = vim.diagnostic.severity.INFO }
    },
    virtual_text = false,
    update_in_insert = true,
})

-- harpoon
local harpoon = require("harpoon")
harpoon:setup({})
vim.keymap.set("n", "<leader>F", harpoon:list().add)
vim.keymap.set("n", "<leader>w", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<leader>d", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<leader>s", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<leader>a", function() harpoon:list():select(4) end)
vim.keymap.set("n", "<leader>W", function() harpoon:list():replace_at(1) end)
vim.keymap.set("n", "<leader>D", function() harpoon:list():replace_at(2) end)
vim.keymap.set("n", "<leader>S", function() harpoon:list():replace_at(3) end)
vim.keymap.set("n", "<leader>A", function() harpoon:list():replace_at(4) end)
vim.keymap.set("n", "<leader>j", function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
end)

-- fzf
local function current_file_dir()
    return vim.fn.expand("%:p:h")
end

local function current_git_repo_dir()
    local command = string.format("git -C %s rev-parse --show-toplevel", current_file_dir())
    return string.gsub(vim.fn.system(command), "%s*$", "")
end

local function file_is_in_git_repo()
    local command = string.format("git -C %s rev-parse", current_file_dir())
    vim.fn.system(command)
    return vim.v.shell_error == 0
end

local fzf = require("fzf-lua")
vim.keymap.set("n", "<leader>f", function()
    if file_is_in_git_repo() then
        fzf.git_files({
            cwd = current_git_repo_dir(),
            cmd = "git ls-files -c -o",
        })
    else
        fzf.files()
    end
end)
vim.keymap.set("n", "<leader>F", fzf.files)
vim.keymap.set("n", "<C-.>", fzf.lsp_code_actions)
vim.keymap.set("n", "<leader>g", function()
    if file_is_in_git_repo() then
        fzf.live_grep({
            multiline = 2,
            cmd = "git grep --line-number --column --color=always",
            cwd = current_git_repo_dir(),
        })
    else
        fzf.live_grep({ multiline = 2 })
    end
end)
vim.keymap.set("n", "<leader>p", function()
    fzf.live_grep({ multiline = 2, cwd = current_file_dir() })
end)
vim.keymap.set("n", "<leader>a", fzf.buffers)
vim.keymap.set("n", "<leader>r", function()
    fzf.lsp_document_symbols({ multiline = 2 })
end)
vim.keymap.set("n", "<leader>t", fzf.lsp_live_workspace_symbols)

vim.api.nvim_create_user_command("Glog", function()
    fzf.git_commits({ cwd = current_git_repo_dir() })
end, { desc = "Fzf git commit log" })

vim.api.nvim_create_user_command("Glogb", function()
    fzf.git_bcommits({ cwd = current_git_repo_dir() })
end, { desc = "Fzf git commit log (current buffer)" })
