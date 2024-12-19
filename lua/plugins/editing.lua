return {
    "tpope/vim-surround",
    "tpope/vim-commentary",
    {
        "windwp/nvim-autopairs",
        opts = {},
    },
    -- {
    --     "ThePrimeagen/harpoon",
    --     branch = "harpoon2",
    --     commit = "e76cb03",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --     },
    -- },
    {
        "cbochs/grapple.nvim",
        opts = {
            scope = "git",
            icons = false,
            status = false,
        },
        keys = {
            { "<leader>F", "<cmd>Grapple toggle<cr>", desc = "Tag a file" },
            { "<leader>j", "<cmd>Grapple toggle_tags<cr>", desc = "Toggle tags menu" },

            { "<leader>w", "<cmd>Grapple select name=1<cr>", desc = "Select first tag" },
            { "<leader>d", "<cmd>Grapple select name=2<cr>", desc = "Select second tag" },
            { "<leader>s", "<cmd>Grapple select name=3<cr>", desc = "Select third tag" },
            { "<leader>a", "<cmd>Grapple select name=4<cr>", desc = "Select fourth tag" },

            { "<leader>W", "<cmd>Grapple tag name=1<cr>", desc = "Select first tag" },
            { "<leader>D", "<cmd>Grapple tag name=2<cr>", desc = "Select second tag" },
            { "<leader>S", "<cmd>Grapple tag name=3<cr>", desc = "Select third tag" },
            { "<leader>A", "<cmd>Grapple tag name=4<cr>", desc = "Select fourth tag" },
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
