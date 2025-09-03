return {
    {
        "dcampos/nvim-snippy",
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "onsails/lspkind.nvim",
            "windwp/nvim-autopairs",
            "dcampos/cmp-snippy",
            {
                "xzbdmw/colorful-menu.nvim",
                opts = {
                    max_width = 35,
                },
            },
        },
        config = function()
            local cmp = require("cmp")
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")

            cmp.event:on(
                "confirm_done",
                cmp_autopairs.on_confirm_done()
            )

            --- https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/plugins/nvim-cmp.lua
            require("cmp.entry").get_documentation = function(self)
                local item = self.completion_item

                if item.documentation then
                    local documentation = vim.lsp.util.convert_input_to_markdown_lines(item.documentation)
                    if #documentation > 0 then
                        documentation[1] = string.gsub(documentation[1], "```csharp", "```cs", 1)
                    end

                    return documentation
                end

                -- Use the item's detail as a fallback if there's no documentation.
                if item.detail then
                    local ft = self.context.filetype
                    local dot_index = string.find(ft, '%.')
                    if dot_index ~= nil then
                        ft = string.sub(ft, 0, dot_index - 1)
                    end
                    return (vim.split(('```%s\n%s```'):format(ft, vim.trim(item.detail)), '\n'))
                end

                return {}
            end

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("snippy").expand_snippet(args.body)
                    end,
                },
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                view = {
                    docs = {
                        auto_open = true,
                    },
                },
                sources = {
                    { name = "path" },
                    { name = "snippy" },
                    { name = "nvim_lsp_signature_help" },
                    { name = "nvim_lsp", keyword_length = 1 },
                },
                formatting = {
                    expandable_indicator = true,
                    fields = { "kind", "abbr", "menu" },
                    format = (function()
                        return function(entry, vim_item)
                            local highlights_info = require("colorful-menu").cmp_highlights(entry)
                            if highlights_info then
                                vim_item.abbr_hl_group = highlights_info.highlights
                                vim_item.abbr = highlights_info.text
                            end

                            local kind = require("lspkind").cmp_format({ mode = "symbol", maxwidth = 35 })(entry, vim_item)
                            local strings = vim.split(kind.kind, "%s", { trimempty = true })
                            kind.kind = " " .. (strings[1] or "") .. " "
                            kind.menu = ""

                            return kind
                        end
                    end)(),
                },
                mapping = require("keybinds").cmp(),
            })
        end,
    },
}
