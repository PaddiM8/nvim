function _G.set_terminal_keymaps()
    vim.keymap.set("t", "<C-b>", "<cmd>ToggleTerm<cr>")
    vim.keymap.set("t", "<C-x>", "<cmd>ToggleTerm<cr>")
    vim.keymap.set("t", "<C-z>", "<cmd>ToggleTerm<cr>")

    vim.keymap.set("t", "jk", "<C-\\><C-n>")
    vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>")
    vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>")
    vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>")
    vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>")
end

return {
    basics = function()
        vim.keymap.set("i", "jk", "<Esc>", {})
        vim.keymap.set("n", "<C-a>", vim.cmd.Ex)
        vim.keymap.set("n", "<C-s>", ":w<cr>")
        vim.keymap.set("n", "<C-q>", ":tabclose<cr>")

        -- lsp
        vim.keymap.set("n", "<leader>2", vim.lsp.buf.rename)
        vim.keymap.set("n", "Q", vim.lsp.buf.hover)
        vim.keymap.set("i", "<C-e>", vim.lsp.buf.signature_help)
        vim.keymap.set("n", "W", vim.diagnostic.open_float)

        vim.diagnostic.config({
            underline = {
                severity = { min = vim.diagnostic.severity.INFO }
            },
            virtual_text = false,
            update_in_insert = true,
        })
    end,
    fzf = function()
        local function current_file_dir()
            return vim.fn.expand("%:p:h")
        end

        local function current_git_repo_dir()
            local command = string.format("git -C %s rev-parse --show-toplevel", current_file_dir())
            return string.gsub(vim.fn.system(command), "%s+$", "")
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
                    cmd = "git ls-files -c -o --exclude-standard",
                    fzf_opts = {
                        ["--tiebreak"] = "end",
                    }
                })
            else
                fzf.files()
            end
        end)
        vim.keymap.set("n", "<leader>d", function()
            if file_is_in_git_repo() then
                fzf.git_files({
                    prompt = "GitFolders❯ ",
                    cwd = current_git_repo_dir(),
                    cmd = "git ls-tree -d -r HEAD --name-only",
                })
            else
                fzf.files({
                    prompt = "Folders❯ ",
                    fd_opts = "--color=never --type directory --hidden --follow --exclude .git",
                })
            end
        end)
        vim.keymap.set("n", "<leader>F", fzf.files)
        vim.keymap.set("n", "<leader>'", fzf.lsp_code_actions)
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
        vim.keymap.set("n", "<leader>T", fzf.lsp_document_symbols)

        vim.api.nvim_create_user_command("Glog", function()
            fzf.git_commits({ cwd = current_git_repo_dir() })
        end, { desc = "Fzf git commit log" })

        vim.api.nvim_create_user_command("Glogb", function()
            fzf.git_bcommits({ cwd = current_git_repo_dir() })
        end, { desc = "Fzf git commit log (current buffer)" })
    end,
    cmp = function()
        local cmp = require("cmp")
        local select_opts = { behavior = cmp.SelectBehavior.Select }

        return {
            ["<C-p>"] = cmp.mapping.select_prev_item(select_opts),
            ["<C-n>"] = cmp.mapping.select_next_item(select_opts),
            ["<Tab>"] = cmp.mapping.confirm({ select = true }),
        }
    end,
    grapple = function()
        return {
            { "<leader>F", "<cmd>Grapple toggle<cr>", desc = "Tag a file" },
            { "<leader>j", "<cmd>Grapple toggle_tags<cr>", desc = "Toggle tags menu" },

            { "<leader>q", "<cmd>Grapple select name=q<cr>", desc = "Select tag q" },
            { "<leader>w", "<cmd>Grapple select name=w<cr>", desc = "Select tag w" },
            -- { "<leader>d", "<cmd>Grapple select index=2<cr>", desc = "Select tag d" },
            { "<leader>s", "<cmd>Grapple select name=s<cr>", desc = "Select tag s" },

            { "<leader>Q", "<cmd>Grapple tag name=q<cr>", desc = "Set tag q" },
            { "<leader>W", "<cmd>Grapple tag name=w<cr>", desc = "Set tag w" },
            -- { "<leader>D", "<cmd>Grapple tag index=2<cr>", desc = "Set tag d" },
            { "<leader>S", "<cmd>Grapple tag name=s<cr>", desc = "Set tag s" },
        }
    end,
    trouble = function()
        return {
            {
                "<leader>cs",
                "<cmd>Trouble diagnostics toggle focus=true<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "gd",
                "<cmd>Trouble lsp_definitions toggle focus=true<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "gr",
                "<cmd>Trouble lsp_references toggle focus=true<cr>",
                desc = "LSP References / ... (Trouble)",
            },
            {
                "go",
                "<cmd>Trouble lsp_implementations toggle focus=true<cr>",
                desc = "LSP References / ... (Trouble)",
            },
        }
    end,
    gitsigns = function(bufnr)
        local gitsigns = require("gitsigns")

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "<leader>z", function()
            if vim.wo.diff then
                vim.cmd.normal({"]c", bang = true})
            else
                gitsigns.nav_hunk("next")
            end
        end)

        map("n", "<leader>x", function()
            if vim.wo.diff then
                vim.cmd.normal({"[c", bang = true})
            else
                gitsigns.nav_hunk("prev")
            end
        end)

        -- Actions
        map("n", "<leader>hs", gitsigns.stage_hunk)
        map("n", "<leader>hr", gitsigns.reset_hunk)
        map("v", "<leader>hs", function()
            gitsigns.stage_hunk {
                vim.fn.line("."),
                vim.fn.line("v"),
            }
        end)
        map("v", "<leader>hr", function()
            gitsigns.reset_hunk {
                vim.fn.line("."),
                vim.fn.line("v"),
            }
        end)

        -- restore hunk in diff mode:
        --   `do` in normal mode
        --   `:diffget` in visual mode

        map("n", "<leader>hS", gitsigns.stage_buffer)
        map("n", "<leader>hR", gitsigns.reset_buffer)
        map("n", "<leader>hp", gitsigns.preview_hunk)
        map("n", "<leader>hb", function()
            gitsigns.blame_line {
                full = true,
            }
        end)
        map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
        map("n", "<leader>hd", gitsigns.diffthis)
        map("n", "<leader>hD", function()
            gitsigns.diffthis("~")
        end)
        map("n", "<leader>hH", gitsigns.preview_hunk_inline)

        -- Text object
        map({"o", "x"}, "ih", ":<C-U>Gitsigns select_hunk<CR>")
    end,
    diffview = function()
        local diffview = require("diffview")
        vim.keymap.set("n", "<leader>hv", function()
            vim.cmd("write")
            diffview.open({})
        end)
        vim.keymap.set("n", "<leader>hf", function()
            vim.cmd("write")
            diffview.file_history(nil, {"%"})
        end)
        vim.keymap.set("n", "<leader>hF", function()
            vim.cmd("write")
            diffview.file_history(nil, {})
        end)

        -- useful keybinds:
        --   zn: show entire file content
    end,
    dap = function()
        local dap = require("dap")
        local dap_widgets = require("dap.ui.widgets")
        local fzf = require("fzf-lua")

        vim.cmd([[
            autocmd FileType dap-float nnoremap <buffer><silent> q <cmd>close!<CR>
        ]])

        vim.keymap.set("n", "§", dap.continue)
        vim.keymap.set("n", "<C-§>", function()
            require("util.dap").attach_dap()
        end)
        vim.keymap.set("n", "!", dap.step_over)
        vim.keymap.set("n", '"', dap.step_into)
        vim.keymap.set("n", "#", dap.step_out)
        vim.keymap.set("n", "¤", dap.pause)
        vim.keymap.set("n", "<leader>§", dap.terminate)
        vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
        vim.keymap.set("n", "<leader>ep", dap.repl.toggle)
        vim.keymap.set("n", "<leader>er", dap.run_last)

        vim.keymap.set("n", "<leader>eb", fzf.dap_breakpoints)
        vim.keymap.set("n", "<leader>ef", fzf.dap_frames)

        vim.keymap.set({"n", "v"}, "+", dap_widgets.hover)

        vim.keymap.set("n", "<leader>es", function()
          dap_widgets.centered_float(dap_widgets.scopes)
        end)
        vim.keymap.set("n", "<leader>et", function()
          dap_widgets.centered_float(dap_widgets.threads)
        end)
    end,
    ui = function()
        local term_util = require("util.toggleterm")
        vim.keymap.set("n", "<C-b>", function()
            term_util.open_terminal(1, "Terminal")
        end)
        vim.keymap.set("n", "<C-x>", function()
            term_util.open_terminal(2, "DebugTerminal")
        end)
        vim.keymap.set("n", "<C-z>", "<cmd>ToggleTerm count=1 direction=float<cr>")

        vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')

        vim.keymap.set("n", "<C-h>", "<cmd>wincmd h<cr>")
        vim.keymap.set("n", "<C-j>", "<cmd>wincmd j<cr>")
        vim.keymap.set("n", "<C-k>", "<cmd>wincmd k<cr>")
        vim.keymap.set("n", "<C-l>", "<cmd>wincmd l<cr>")
    end,
    neotest = function()
        local neotest = require("neotest")

        -- summary view
        vim.keymap.set("n", "<leader>jv", neotest.summary.toggle)

        -- output for all tests
        vim.keymap.set("n", "<leader>jp", function()
            neotest.output_panel.toggle()
        end)

        -- output for nearest test
        vim.keymap.set("n", "<leader>jo", function()
            neotest.output.open({
                enter = true,
            })
        end)

        -- run all
        vim.keymap.set("n", "<leader>ja", function()
            neotest.run.run({
                suite = true,
            })
        end)

        -- run the current file
        vim.keymap.set("n", "<leader>js", function()
            neotest.run.run({
                vim.fn.expand("%"),
                suite = false,
            })
        end)

        -- debug the nearest test
        vim.keymap.set("n", "<leader>jd", function()
            neotest.run.run({
                strategy = "dap",
                suite = false,
            })
        end)

        -- stop all
        vim.keymap.set("n", "<leader>jq", function()
            neotest.run.stop({
                adapter = "dap",
                interactive = false,
            })
        end)
    end,
    conform = function()
        local conform = require("conform")
        vim.keymap.set("n", "<leader>=", conform.format)
    end,
}
