return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            local lspconfig = require("lspconfig")
            require("mason-lspconfig").setup_handlers({
                function(server_name)
                    lspconfig[server_name].setup({
                        capabilities = capabilities,
                    })
                end,
            })
        end,
    },
    {
        "artemave/workspace-diagnostics.nvim",
        opt = {},
    }
}
