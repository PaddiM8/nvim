return {
    {
        -- dir = "~/.local/share/nvim/riderdark.vim",
        "realbucksavage/riderdark.vim",
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
    },
    {
        "OXY2DEV/markview.nvim",
        lazy = false,
        opts = {
            preview = {
                icon_provider = "devicons",
            },
        },
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
            local hooks = require("ibl.hooks")
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, "IblIndent", { fg = "#212121" })
                vim.api.nvim_set_hl(0, "IblScope", { bg = "NONE", fg = "#757575" })
            end)

            require("ibl").setup({
                indent = {
                    char = "▏",
                },
                scope = {
                    enabled = false,
                },
            })
        end,
    },
}
