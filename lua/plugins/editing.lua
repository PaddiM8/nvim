return {
    "tpope/vim-sleuth",
    "tpope/vim-surround",
    "tpope/vim-commentary",
    "tpope/vim-eunuch",
    {
        "stevearc/oil.nvim",
        dependencies = {
            {
                "nvim-tree/nvim-web-devicons",
                opts = {},
            },
        },
        lazy = false,
        opts = {
            keymaps = require("keybinds").oil(),
            use_default_keymaps = false,
        }
    },
    {
        "cappyzawa/trim.nvim",
        opts = {
            ft_blocklist = { "oil" },
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
