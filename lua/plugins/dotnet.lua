--- @param client vim.lsp.Client the LSP client
function Monkey_patch_semantic_tokens(client)
    -- make sure this happens once per client, not per buffer
    if client.is_hacked then
        return
    end

    client.is_hacked = true

    -- let the runtime know the server can do semanticTokens/full now
    if client.server_capabilities.semanticTokensProvider then
        client.server_capabilities = vim.tbl_deep_extend("force", client.server_capabilities, {
            semanticTokensProvider = {
                full = true,
            },
        })
    end

    -- monkey patch the request proxy
    local request_inner = client.request
    client.request = function(method, params, handler)
        if method ~= vim.lsp.protocol.Methods.textDocument_semanticTokens_full then
            return request_inner(method, params, handler)
        end

        local function find_buf_by_uri(search_uri)
            local bufs = vim.api.nvim_list_bufs()
            for _, buf in ipairs(bufs) do
                local name = vim.api.nvim_buf_get_name(buf)
                local uri = "file://" .. name
                if uri == search_uri then
                    return buf
                end
            end
        end

        local doc_uri = params.textDocument.uri

        local target_bufnr = find_buf_by_uri(doc_uri)
        local line_count = vim.api.nvim_buf_line_count(target_bufnr)
        local last_line = vim.api.nvim_buf_get_lines(target_bufnr, line_count - 1, line_count, true)[1]

        return request_inner("textDocument/semanticTokens/range", {
                textDocument = params.textDocument,
                range = {
                    ["start"] = {
                        line = 0,
                        character = 0,
                    },
                    ["end"] = {
                    line = line_count - 1,
                    character = string.len(last_line) - 1,
                },
            },
        }, handler)
    end
end

function attach_dap(dll_path, pid)
    local pgrep_result = vim.system(
        {"pgrep", "-P", pid},
        { text = true }
    ):wait()

    local dap = require("dap")
    local dap_config = require("dap-config.dotnet")
    dap.run({
        type = "coreclr",
        name = "Program",
        request = "attach",
        processId = tonumber(pgrep_result.stdout),
        env = function()
            dap_config.get_env(dll_path)
        end,
        cwd = function()
            dap_config.get_cwd(dll_path)
        end,
    })
end

local function run_debug(csproj_path)
    local dotnet = require("easy-dotnet")
    local project = require("easy-dotnet.parsers.csproj-parse")
        .get_project_from_project_file(csproj_path)
    local dll_path = {
        project_name = project.name,
        dll = project.get_dll_path(),
        relative_project_path = vim.fs.dirname(project.path),
    }

    local toggleterm = require("toggleterm")
    local toggleterm_terminal = require("toggleterm.terminal")

    -- hide all terminals
    for _, open_terminal in ipairs(toggleterm_terminal.get_all(false)) do
        open_terminal:close()
    end

    -- create a new terminal running the program
    local terminal = toggleterm_terminal.Terminal:new({
        cmd = "dotnet " .. dll_path.dll,
        count = 2,
        direction = "horizontal",
        display_name = "DebugTerminal",
    })
    terminal:toggle(nil, "horizontal")

    local buffer_name = vim.api.nvim_buf_get_name(0)
    local buffer_name_start = string.match(buffer_name, "term://.+/%d+")
    local pid = string.match(buffer_name_start, "%d+$")

    -- attach the dap
    vim.defer_fn(function()
        attach_dap(dll_path, pid)
    end, 1750)
end

return {
    {
        dir = "~/.local/share/nvim/elk",
    },
    {
        "seblj/roslyn.nvim",
        ft = "cs",
        opts = {
            config = {
                on_attach = function(client)
                    Monkey_patch_semantic_tokens(client)
                end
            }
        }
    },
    {
        "GustavEikaas/easy-dotnet.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {
            picker = "fzf",
            terminal = function(path, action, args)
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

                local relative_solution_path = require("easy-dotnet")
                    .try_get_selected_solution()
                    .path
                local solution_path = vim.fn.getcwd() .. "/" .. vim.fs.dirname(relative_solution_path)

                local command = commands[action]() .. "\r"
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
                    cwd = solution_path,
                    components = {
                        { "on_complete_dispose", timeout = 30 },
                        "default",
                        { "unique", replace = true },
                    },
                })
                task:start()
            end,
        },
    },
}
