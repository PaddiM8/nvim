local M = {}

--- Rebuilds the project before starting the debug session
local function rebuild_project()
    vim.cmd("silent make")

    -- Check for any error quickfix list entries
    local qflist = vim.fn.getqflist()
    local error_count = 0
    for _, item in ipairs(qflist) do
        if item.type == "e" then
            error_count = error_count + 1
        end
    end

    if error_count > 0 then
        if error_count > 1 then
            vim.cmd("copen")
        end

        return false
    end

    return true
end

M.get_env = function(dll)
    local dotnet = require("easy-dotnet")
    local vars = dotnet.get_environment_variables(dll.project_name, dll.relative_project_path)

    return vars or nil
end

M.get_cwd = function(dll)
    return dll.relative_project_path
end

M.get_args = function(dll)
    local launch_settings = dll.relative_project_path .. "/Properties" .. "/launchSettings.json"
      local stat = vim.loop.fs_stat(launch_settings)
      if stat == nil then
          return nil
      end

      local success, result = pcall(vim.fn.json_decode, vim.fn.readfile(launch_settings, ""))
      if not success then
          return nil
      end

      local launch_profile = result.profiles[project_name]
      if launch_profile == nil then
          return nil
      end

      return vim.split(launch_profile.commandLineArgs, " +")
end

M.register_net_dap = function()
    local dap = require("dap")
    local dotnet = require("easy-dotnet")
    local debug_dll = nil

    local function ensure_dll()
        if debug_dll == nil then
            debug_dll = dotnet.get_debug_dll(true)
        end

        return debug_dll
    end

    for _, value in ipairs({ "cs", "fsharp" }) do
        dap.configurations[value] = {
            {
                type = "vsdbg",
                name = "Program",
                request = "launch",
                clientID = "vscode",
                clientName = "Visual Studio Code",
                console = "integratedTerminal",
                env = function()
                    ensure_dll()
                    return M.get_env(debug_dll)
                end,
                program = function()
                    ensure_dll()
                    if debug_dll == nil then
                        return
                    end

                    if not rebuild_project() then
                        return dap.ABORT
                    end

                    return debug_dll.relative_dll_path
                end,
                cwd = function()
                    ensure_dll()
                    return M.get_cwd(debug_dll)
                end,
                args = function()
                    ensure_dll()
                    return M.get_args(debug_dll)
                end,
            },
        }
    end

    dap.listeners.before["event_terminated"]["easy-dotnet"] = function()
        debug_dll = nil
    end

    -- netcoredbg (for neotest)
    dap.adapters.netcoredbg = {
        type = "executable",
        command = "netcoredbg",
        args = {"--interpreter=vscode"}
    }

    -- vsdbg
    local config_dir = vim.fn.stdpath("config")
    local get_vsdbg_path = config_dir .. "/resources/get-vsdbg-path.elk"
    local vsdbg_path = vim.fn.system("elk " .. get_vsdbg_path)
    dap.adapters.vsdbg = {
        type="executable",
        command = vsdbg_path,
        args = { "--interpreter=vscode", "--engineLogging" },
        id = "coreclr",
        options = {
            internalTerminal = true,
        },
        runInTerminal = true,
        reverse_request_handlers = {
            handshake = require("dap-config.vsdbg").RunHandshake,
        },
    }
end

return M
