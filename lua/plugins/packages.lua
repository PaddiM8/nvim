return {
    "williamboman/mason.nvim",
    dependencies = {
        "jay-babu/mason-nvim-dap.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
        require("mason").setup({
            registries = {
                "github:mason-org/mason-registry",
                "github:Crashdummyy/mason-registry",
            },
        })
        require("mason-tool-installer").setup({
            ensure_installed = {
                "prettierd",
                "xmlformatter",
                "fixjson",
            },
        })
        require("mason-nvim-dap").setup({
            ensure_installed = { "netcoredbg" },
            handlers = {},
        })
    end,
}
