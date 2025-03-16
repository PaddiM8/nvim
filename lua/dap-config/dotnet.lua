local M = {}

--- Rebuilds the project before starting the debug session
---@param co thread
local function rebuild_project(co, path)
    local spinner = require("easy-dotnet.ui-modules.spinner").new()
    spinner:start_spinner("Building")
    vim.fn.jobstart(string.format("dotnet build %s", path), {
        on_exit = function(_, return_code)
            if return_code == 0 then
                spinner:stop_spinner("Built successfully")
            else
                spinner:stop_spinner("Build failed with exit code " .. return_code, vim.log.levels.ERROR)
                error("Build failed")
            end
            coroutine.resume(co)
        end,
    })
    coroutine.yield()
end

M.get_env = function(dll)
    local dotnet = require("easy-dotnet")
    local vars = dotnet.get_environment_variables(dll.project_name, dll.relative_project_path)

    return vars or nil
end

M.get_cwd = function(dll)
    return dll.relative_project_path
end

M.register_net_dap = function()
    local dap = require("dap")
    local dotnet = require("easy-dotnet")
    local debug_dll = nil

    local function ensure_dll()
        if debug_dll == nil then
            debug_dll = dotnet.get_debug_dll()
        end

        return debug_dll
    end

    for _, value in ipairs({ "cs", "fsharp" }) do
        dap.configurations[value] = {
            {
                type = "coreclr",
                name = "Program",
                request = "launch",
                clientID = "vscode",
                clientName = "Visual Studio Code",
                console = "integratedTerminal",
                env = function()
                    ensure_dll()
                    M.get_env(debug_dll)
                end,
                program = function()
                    local co = coroutine.running()
                    if debug_dll == nil then
                        return
                    end

                    rebuild_project(co, debug_dll.project_path)
                    return debug_dll.relative_dll_path
                end,
                cwd = function()
                    ensure_dll()
                    M.get_cwd(debug_dll)
                end,
            },
            {
                type = "coreclr",
                name = "Test",
                request = "attach",
                processId = function()
                    local res = require("easy-dotnet").experimental.start_debugging_test_project()
                    return res.process_id
                end
            }
        }
    end

    dap.listeners.before["event_terminated"]["easy-dotnet"] = function()
        debug_dll = nil
    end

    dap.adapters.coreclr = {
        type="executable",
        command = os.getenv("HOME") .. "/.vscode/extensions/ms-dotnettools.csharp-2.63.32-linux-x64/.debugger/vsdbg-ui",
        args = { "--interpreter=vscode", "--engineLogging" },
        id = "coreclr",
        options = {
            internalTerminal = true,
            --externalTerminal = true,
        },
        runInTerminal = true,
        reverse_request_handlers = {
            handshake = require("dap-config.vsdbg").RunHandshake,
        },
    }
end

return M
