return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "Saghen/blink.cmp",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            local capabilities = require("blink.cmp").get_lsp_capabilities()
            local lspconfig = require("lspconfig")

            require("mason-lspconfig").setup_handlers({
                function(server_name)
                    lspconfig[server_name].setup({
                        capabilities = capabilities,
                    })
                end,
            })
        end
    }
}
