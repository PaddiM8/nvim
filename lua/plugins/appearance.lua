return {
    {
        dir = "~/.local/share/nvim/riderdark.vim",
    },
    {
        "catppuccin/nvim",
    },
    {
        "lewis6991/satellite.nvim",
        opts = {
            winblend = 0,
            handlers = {
                diagnostic = {
                    enable = true,
                    signs = { "-", "━", "▬" },
                    min_severity = vim.diagnostic.severity.WARN,
                },
                gitsigns = {
                    enable = false,
                },
            },
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                theme = "nord",
                component_separators = "",
                section_separators = "",
                disabled_filetypes = { "toggleterm" },
            },
            sections = {
                lualine_a = {"mode"},
                lualine_b = {"branch", "diff", "diagnostics"},
                lualine_c = {"filename"},
                lualine_x = {},
                lualine_y = {"progress"},
                lualine_z = {"location"},
            },
        },
    },
    {
        "akinsho/toggleterm.nvim",
        opts = {
            start_in_insert_mode = true,
            close_on_exit = true,
        },
    }
}
