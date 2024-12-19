return {
    "tpope/vim-surround",
    "tpope/vim-commentary",
    {
        "windwp/nvim-autopairs",
        opts = {},
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        commit = "e76cb03",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
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
        keys = {
            {
                "<leader>cs",
                "<cmd>Trouble diagnostics toggle focus=true<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=true<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>ca",
                "<cmd>Trouble lsp_references toggle focus=true<cr>",
                desc = "LSP References / ... (Trouble)",
            },
        },
    }
}
