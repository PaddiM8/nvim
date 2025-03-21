local function configure_dotnet()
    return require("neotest-dotnet")({
        dap = {
            args = { justMyCode = false },
            adapter_name = "coreclr",
        },
        discovery_root = "solution",
    })
end

---@diagnostic disable: missing-fields
return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "Issafalcon/neotest-dotnet",
        },
        config = function()
            local neotest = require("neotest")
            neotest.setup({
                adapters = {
                    configure_dotnet(),
                },
            })

            require("keybinds").neotest()
        end
    },
}
