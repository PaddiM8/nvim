return {
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        "saghen/blink.cmp",
        opts = {
            sources = {
                completion = {
                    enabled_providers = { "lsp", "path", "snippets", "buffer", "lazydev" },
                },
                providers = {
                    lsp = { fallback_for = { "lazydev" } },
                    lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
                },
            },
        },
    }
}
