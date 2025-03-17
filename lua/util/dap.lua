local M = {}

M.attach_dap = function()
    local pid = M.dap_pick_process()
    local dap = require("dap")
    local dap_config = require("dap-config.dotnet")
    local dotnet = require("easy-dotnet")
    if dotnet.is_dotnet_project() then
        -- local dll_path = dotnet.get_debug_dll()
        dap.run({
            type = "coreclr",
            name = "Program",
            request = "attach",
            processId = pid,
        })
    end
end

-- https://github.com/ibhagwan/nvim-lua/blob/68d04e8ecdb03ef9f4bd23c0fb30d204a2fa4bf2/lua/utils.lua#L473-L504
M.dap_pick_process = function(fzflua_opts, getproc_opts)
    local fzf = require("fzf-lua")
    return coroutine.create(function(dap_co)
        local dap_abort = function() coroutine.resume(dap_co, require("dap").ABORT) end
        local procs = require("dap.utils").get_processes(getproc_opts)

        fzf.fzf_exec(
        function(fzf_cb)
            for _, p in ipairs(procs) do
                fzf_cb(string.format("[%d] %s", p.pid, p.name))
            end
        end,
        vim.tbl_deep_extend("keep", fzflua_opts or {}, {
            winopts = {
                preview = { hidden = "hidden" },
                title = { { " DAP: Select Process to Debug ", "Cursor" } },
                title_pos = "center",
            },
            actions = {
                ["esc"] = dap_abort,
                ["ctrl-c"] = dap_abort,
                ["default"] = function(sel)
                    if not sel[1] then
                        dap_abort()
                    else
                        local pid = tonumber(sel[1]:match("^%[(%d+)%]"))
                        coroutine.resume(dap_co, pid)
                    end
                end,
            },
        }))
    end)
end

return M
