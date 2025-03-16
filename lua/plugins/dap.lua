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
        end
    },
}
