--- @param client vim.lsp.Client the LSP client
function Monkey_patch_semantic_tokens(client)
    -- make sure this happens once per client, not per buffer
    if client.is_hacked then
        return
    end

    client.is_hacked = true

    -- let the runtime know the server can do semanticTokens/full now
    if client.server_capabilities.semanticTokensProvider then
        client.server_capabilities = vim.tbl_deep_extend("force", client.server_capabilities, {
            semanticTokensProvider = {
                full = true,
            },
        })
    end

    -- monkey patch the request proxy
    local request_inner = client.request
    client.request = function(method, params, handler)
        if method ~= vim.lsp.protocol.Methods.textDocument_semanticTokens_full then
            return request_inner(method, params, handler)
        end

        local function find_buf_by_uri(search_uri)
            local bufs = vim.api.nvim_list_bufs()
            for _, buf in ipairs(bufs) do
                local name = vim.api.nvim_buf_get_name(buf)
                local uri = "file://" .. name
                if uri == search_uri then
                    return buf
                end
            end
        end

        local doc_uri = params.textDocument.uri

        local target_bufnr = find_buf_by_uri(doc_uri)
        local line_count = vim.api.nvim_buf_line_count(target_bufnr)
        local last_line = vim.api.nvim_buf_get_lines(target_bufnr, line_count - 1, line_count, true)[1]

        return request_inner("textDocument/semanticTokens/range", {
                textDocument = params.textDocument,
                range = {
                    ["start"] = {
                        line = 0,
                        character = 0,
                    },
                    ["end"] = {
                    line = line_count - 1,
                    character = string.len(last_line) - 1,
                },
            },
        }, handler)
    end
end

return {
    {
        dir = "~/.local/share/nvim/elk",
    },
    {
        "seblj/roslyn.nvim",
        ft = "cs",
        opts = {
            config = {
                on_attach = function(client)
                    Monkey_patch_semantic_tokens(client)
                end
            }
        }
    },
}
