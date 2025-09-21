return {
    {
        dir = "~/.local/share/nvim/elk",
    },
    {
        "seblj/roslyn.nvim",
        ft = "cs",
        config = function()
            vim.api.nvim_set_hl(0, "@lsp.type.stringEscapeCharacter.cs", { link = "Delimiter" })

            vim.api.nvim_set_hl(0, "@lsp.type.jsonComment.cs", { link = "Comment" })
            vim.api.nvim_set_hl(0, "@lsp.type.jsonNumber.cs", { link = "Number" })
            vim.api.nvim_set_hl(0, "@lsp.type.jsonString.cs", { link = "String" })
            vim.api.nvim_set_hl(0, "@lsp.type.jsonKeyword.cs", { link = "Keyword" })
            vim.api.nvim_set_hl(0, "@lsp.type.jsonOperator.cs", { link = "Operator" })
            vim.api.nvim_set_hl(0, "@lsp.type.jsonArray.cs", { link = "Delimiter" })
            vim.api.nvim_set_hl(0, "@lsp.type.jsonObject.cs", { link = "Delimiter" })
            vim.api.nvim_set_hl(0, "@lsp.type.jsonPropertyName.cs", { link = "@variable" })

            vim.api.nvim_set_hl(0, "@lsp.type.regexComment.cs", { link = "Comment" })
            vim.api.nvim_set_hl(0, "@lsp.type.regexCharacterClass.cs", { link = "SpecialChar" })
            vim.api.nvim_set_hl(0, "@lsp.type.regexAnchor.cs", { link = "Delimiter" })
            vim.api.nvim_set_hl(0, "@lsp.type.regexQuantifier.cs", { link = "Number" })
            vim.api.nvim_set_hl(0, "@lsp.type.regexGrouping.cs", { link = "Delimiter" })
            vim.api.nvim_set_hl(0, "@lsp.type.regexAlternation.cs", { link = "Operator" })
            vim.api.nvim_set_hl(0, "@lsp.type.regexText.cs", { link = "String" })
            vim.api.nvim_set_hl(0, "@lsp.type.regexSelfEscapedCharacter.cs", { link = "SpecialChar" })
            vim.api.nvim_set_hl(0, "@lsp.type.regexOtherEscape.cs", { link = "SpecialChar" })

            local roslyn = require("roslyn")
            roslyn.setup()

            vim.lsp.config("roslyn", {
                settings = {
                    ["csharp|completion"] = {
                        dotnet_show_completion_items_from_unimported_namespaces = true,
                        dotnet_show_name_completion_suggestions = true,
                    },
                    ["csharp|background_analysis"] = {
                        dotnet_analyzer_diagnostics_scope = "openFiles",
                        dotnet_compiler_diagnostics_scope = "fullSolution",
                    },
                },
            })
        end,
    },
    {
        "GustavEikaas/easy-dotnet.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local config_dir = vim.fn.stdpath("config")
            local get_vsdbg_path = config_dir .. "/resources/get-vsdbg-path.elk"
            local vsdbg_path = vim.fn.system("elk " .. get_vsdbg_path)

            local dotnet = require("easy-dotnet")
            dotnet.setup({
                picker = "fzf",
                debugger = {
                    bin_path = vsdbg_path,
                },
                auto_bootstrap_namespace = {
                    type = "file_scoped",
                    enabled = true
                },
            })

            local dap = require("dap")
            local dotnet = require("easy-dotnet")
            local debugger_conf = dap.configurations["cs"] or {}
            vim.list_extend(debugger_conf, {
                {
                    type = "easy-dotnet",
                    name = "easy-dotnet",
                    request = "attach",
                    select_project = dotnet.prepare_debugger,
                    clientID = "vscode",
                    clientName = "Visual Studio Code",
                    console = "integratedTerminal",
                }
            })
            dap.configurations["cs"] = debugger_conf

            -- vsdbg
            dap.adapters["easy-dotnet"] = function(callback) callback({
                type = "server",
                host = "127.0.0.1",
                port = 8086,

                id = "coreclr",
                options = {
                    internalTerminal = true,
                },
                runInTerminal = true,
                reverse_request_handlers = {
                    handshake = require("dap-config.vsdbg").RunHandshake,
                },
            }) end

            -- netcoredbg (for neotest)
            dap.adapters.netcoredbg = {
                type = "executable",
                command = "netcoredbg",
                args = {
                    "--interpreter=vscode"
                },
            }
        end,
    },
}
