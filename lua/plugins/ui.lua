return {
    {
        "aserowy/tmux.nvim",
        config = {
            resize = {
                enable_default_keybindings = false,
            },
        },
    },
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        opts = {
            highlights = {
                Normal = {
                    link = "Normal",
                },
            },
        },
    },
}
