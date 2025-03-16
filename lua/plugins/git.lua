return {
    {
        "tpope/vim-fugitive",
    },
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            on_attach = function(bufnr)
                local gitsigns = require("gitsigns")
                require("keybinds").gitsigns(bufnr)
            end
        },
    },
}
