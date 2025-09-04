local oil_opts = {
    keymaps = require("keybinds").oil(),
    skip_confirm_for_simple_edits = false,
    use_default_keymaps = false,
}

return {
    {
        "stevearc/oil.nvim",
        dependencies = {
            {
                "nvim-tree/nvim-web-devicons",
                opts = {},
            },
        },
    },
    {
        "rmagatti/auto-session",
        lazy = false,
        opts = {
            lazy_support = true,
            suppressed_dirs = {
                "~/",
                "~/projects",
                "~/downloads",
                "/",
            },
            bypass_session_save_file_types = {
                "dap-view",
                "dap-view-term",
                "dap-repl",
                "dap-terminal",
            },
            no_restore_cmds = {
                function()
                    require("oil").setup(oil_opts)
                end,
            },
            post_restore_cmds = {
                function()
                    require("oil").setup(oil_opts)
                end,
            },
        },
    },
}
