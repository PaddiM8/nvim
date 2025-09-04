local function configure_terminal(path, action, args)
    local dotnet = require("easy-dotnet")
    local project = require("easy-dotnet.parsers.csproj-parse")
        .get_project_from_project_file(path)
    local dll_path = {
        project_name = project.name,
        dll = project.get_dll_path(),
        relative_project_path = vim.fs.dirname(project.path),
    }

    local commands = {
        run = function()
            return string.format("dotnet run --project %s %s", path, args)
        end,
        test = function()
            return string.format("dotnet test %s %s", path, args)
        end,
        restore = function()
            return string.format("dotnet restore %s %s", path, args)
        end,
        build = function()
            return string.format("dotnet build %s %s", path, args)
        end
    }

    -- local relative_solution_path = require("easy-dotnet")
    --     .try_get_selected_solution()
    --     .path
    -- local solution_path = vim.fn.getcwd() .. "/" .. vim.fs.dirname(relative_solution_path)

    local command = commands[action]() .. "\r"
    command = command:gsub("%s+$", "")
    local task = require("overseer").new_task({
        strategy = {
            "toggleterm",
            use_shell = false,
            count = 2,
            direction = "horizontal",
            open_on_start = true,
        },
        name = action,
        cmd = command,
        cwd = dll_path.relative_project_path,
        components = {
            { "on_complete_dispose", timeout = 30 },
            "default",
            { "unique", replace = true },
        },
    })
    task:start()
end

return {
    {
        dir = "~/.local/share/nvim/elk",
    },
    {
        "seblj/roslyn.nvim",
        ft = "cs",
        config = function()
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
        opts = {
            picker = "fzf",
            auto_bootstrap_namespace = {
                type = "file_scoped",
                enabled = true
            },
        },
    },
}
