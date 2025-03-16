return {
    "tpope/vim-surround",
    "tpope/vim-commentary",
    {
        "windwp/nvim-autopairs",
        opts = {},
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
    }
}
