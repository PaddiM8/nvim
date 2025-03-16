local M = {}
M.open_terminal = function(count, name)
    -- hide other terminals first
    local toggleterm_terminal = require("toggleterm.terminal")
    for _, open_terminal in ipairs(toggleterm_terminal.get_all(false)) do
        if open_terminal.count ~= count then
            open_terminal:close()
        end
    end

    local toggleterm = require("toggleterm")
    toggleterm.toggle(count, nil, nil, "horizontal", "Terminal")
end

return M
