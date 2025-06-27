return {
    "tpope/vim-sleuth",
    "tpope/vim-surround",
    "tpope/vim-commentary",
    "tpope/vim-eunuch",
    {
        "stevearc/oil.nvim",
        ---@module 'oil'
        opts = {},
        dependencies = {
            {
                "nvim-tree/nvim-web-devicons",
                opts = {},
            },
        },
        lazy = false,
    },
    {
        "cappyzawa/trim.nvim",
        opts = {
            notifications = false,
            highlight = true,
        },
    },
    {
        "folke/trouble.nvim",
        opts = {},
        cmd = "Trouble",
        keys = require("keybinds").trouble(),
    },
    {
        "stevearc/conform.nvim",
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    rust = { "rustfmt", lsp_format = "fallback" },
                    javascript = { "prettierd", "prettier", stop_after_first = true },
                    html = { "xmlformatter" },
                    xml = { "xmlformatter" },
                    json = { "fixjson" },
                },
            })

            require("keybinds").conform()
        end
    },
}
