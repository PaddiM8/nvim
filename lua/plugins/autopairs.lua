function auto_space(a1, ins, a2, lang)
    local npairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")
    local cond = require("nvim-autopairs.conds")

    npairs.add_rule(
        Rule(ins, ins, lang)
            :with_pair(function(opts)
                return a1 .. a2 == opts.line:sub(opts.col - #a1, opts.col + #a2 - 1)
            end)
            :with_move(cond.none())
            :with_cr(cond.none())
            :with_del(function(opts)
                local col = vim.api.nvim_win_get_cursor(0)[2]
                return a1 .. ins .. ins .. a2 == opts.line:sub(col - #a1 - #ins + 1, col + #ins + #a2)
            end)
    )
end

function on_new_line(a1, a2, lang)
    local npairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")
    local cond = require("nvim-autopairs.conds")

    npairs.add_rule(
        Rule(a1, a2, lang)
            :use_key("<Cr>")
            :replace_endpair(function() return "<BS><Cr>{<Cr><Up><Right><Cr>" end, true)
    )
end

function on_same_line(a1, a2, lang)
    local npairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")
    local cond = require("nvim-autopairs.conds")

    npairs.add_rule(
        Rule(a1, a2, lang)
            :use_key("<Cr>")
            :replace_endpair(function() return "<C-g>u<CR><C-c>O" end, true)
    )
end

function fix_parenthesis_indentation(lang)
    local npairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")
    local cond = require("nvim-autopairs.conds")

    npairs.add_rule(
        Rule("(", ")", lang)
            :use_key("<Cr>")
            :replace_endpair(function() return "<C-g>u<CR><C-c><<O" end, true)
    )
end

return {
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup()
            auto_space("{", " ", "}")
            on_new_line("{", "}", "cs")
            on_same_line("[", "]", "cs")
            fix_parenthesis_indentation("cs")
        end,
    },
}
