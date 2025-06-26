---@diagnostic disable: missing-fields
return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function ()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                highlight = {
                    enable = true,
                },
                indent = {
                    enable = true,
                },
                ensure_installed = {
                    "c",
                    "lua",
                    "vim",
                    "html",
                    "css",
                    "javascript",
                    "typescript",
                    "c_sharp",
                    "markdown",
                },
            })
        end
    },
}
