local M = {}
local utils = require("dap.utils")
local rpc = require("dap.rpc")

M.RunHandshake = function(self, request_payload)
    local signResult = io.popen("node " .. vim.fn.stdpath("config") .. "/resources/sign-vsdbg.js " .. request_payload.arguments.value)
    if signResult == nil then
        utils.notify("error while signing handshake", vim.log.levels.ERROR)
        return
    end

    local signature = signResult:read("*a")
    signature = string.gsub(signature, "\n", "")

    local response = {
        type = "response",
        seq = 0,
        command = "handshake",
        request_seq = request_payload.seq,
        success = true,
        body = {
            signature = signature,
        },
    }

    local msg = rpc.msg_with_content_length(vim.json.encode(response))
    self.client.write(msg)
end

return M
