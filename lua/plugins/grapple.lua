return {
    "cbochs/grapple.nvim",
    dependencies = {
        {
            "nvim-tree/nvim-web-devicons",
            lazy = true,
        },
    },
    keys = require("keybinds").grapple(),
}
