return {
    {
        "realbucksavage/riderdark.vim",
    },
    {
        "catppuccin/nvim",
    },
    {

        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                theme = "nord",
                component_separators = "",
                section_separators = "",
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
}
