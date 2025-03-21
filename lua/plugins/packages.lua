return {
    "williamboman/mason.nvim",
    dependencies = {
        "jay-babu/mason-nvim-dap.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
        require("mason").setup()
        require("mason-tool-installer").setup({
            ensure_installed = {
                "prettierd",
                "xmlformatter",
                "rustfmt",
                "fixjson",
            },
        })
        require("mason-nvim-dap").setup({
            ensure_installed = { "netcoredbg" },
            handlers = {},
        })
    end,
}
