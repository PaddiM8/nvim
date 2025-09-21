return {
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")

            require("keybinds").dap()
            -- require("dap-config.dotnet").register_net_dap()

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
        end
    },
    {
        "igorlfs/nvim-dap-view",
        config = function()
            require("keybinds").dap_view()

            local dap_view = require("dap-view")
            dap_view.setup({
                winbar = {
                    show = true,
                    sections = { "console", "watches", "scopes", "exceptions", "threads", "repl" },
                    default_section = "console",
                    base_sections = {
                        console = {
                            keymap = "C",
                            label = "Console [C]",
                            short_label = "󰆍 [C]",
                            action = function()
                                require("dap-view.term").show()
                            end,
                        },
                        scopes = {
                            keymap = "S",
                            label = "Scopes [S]",
                            short_label = "󰂥 [S]",
                            action = function()
                                require("dap-view.views").switch_to_view("scopes")
                            end,
                        },
                        exceptions = {
                            keymap = "E",
                            label = "Exceptions [E]",
                            short_label = "󰢃 [E]",
                            action = function()
                                require("dap-view.views").switch_to_view("exceptions")
                            end,
                        },
                        watches = {
                            keymap = "W",
                            label = "Watches [W]",
                            short_label = "󰛐 [W]",
                            action = function()
                                require("dap-view.views").switch_to_view("watches")
                            end,
                        },
                        threads = {
                            keymap = "T",
                            label = "Threads [T]",
                            short_label = "󱉯 [T]",
                            action = function()
                                require("dap-view.views").switch_to_view("threads")
                            end,
                        },
                        repl = {
                            keymap = "R",
                            label = "REPL [R]",
                            short_label = "󰯃 [R]",
                            action = function()
                                require("dap-view.repl").show()
                            end,
                        },
                        sessions = {
                            keymap = "K",
                            label = "Sessions [K]",
                            short_label = " [K]",
                            action = function()
                                require("dap-view.views").switch_to_view("sessions")
                            end,
                        },
                    },
                },
            })
        end,
    },
}
