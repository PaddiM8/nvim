return {
    "tpope/vim-surround",
    "tpope/vim-commentary",
    {
        "windwp/nvim-autopairs",
        opts = {},
    },
    {
        "Saghen/blink.cmp",
        version = 'v0.*',
        lazy = false,
        opts = {
            keymap = { preset = "super-tab" },
        },
    },
    {
        "cappyzawa/trim.nvim",
        opts = {
            notifications = false,
            highlight = true,
        },
    }
}
