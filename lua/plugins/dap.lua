return {
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")

            require("keybinds").dap()
            require("dap-config.dotnet").register_net_dap()

            vim.fn.sign_define("DapBreakpoint", {
                text = "",
                texthl = "DapBreakpoint",
                linehl = "",
                numhl = "",
            })
            vim.fn.sign_define("DapStopped", {
                text='',
                texthl = "DapStopped",
                linehl = "DapStopped",
                numhl= "DapStopped",
            })
            vim.fn.sign_define("DapBreakpointRejected", {
                text="",
                texthl = "DapBreakpointRejected",
                linehl = "DapBreakpointRejected",
                numhl = "DapBreakpointRejected",
            })
            vim.fn.sign_define("DapBreakpointCondition", {
                text="",
                texthl = "DapBreakpoint",
                linehl = "",
                numhl = "",
            })

            -- use toggleterm as integrated terminal
            dap.defaults.fallback.terminal_win_cmd = function()
                require("util.toggleterm").open_terminal(2, "DebugTerminal")

                return vim.api.nvim_get_current_buf(), vim.api.nvim_get_current_win()
            end

            -- automatically close the integrated terminal on program exit
            dap.listeners.after.event_initialized["custom.terminal-autoclose"] = function(session)
                session.on_close["custom.terminal-autoclose"] = function()
                    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                        local bufname = vim.api.nvim_buf_get_name(buf)
                        if string.find(bufname, "%[dap%-terminal%]") then
                            vim.api.nvim_buf_delete(buf, { force = true })
                        end
                    end
                end
            end
        end
    },
}
