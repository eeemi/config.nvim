return {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
        {
            -- "<leader>xx",
            "<leader>tx",
            "<cmd>Trouble diagnostics toggle<cr>",
            desc = "Diagnostics (Trouble)",
        },
        {
            -- "<leader>xX",
            "<leader>tX",
            "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
            desc = "Buffer Diagnostics (Trouble)",
        },
        {
            -- "<leader>cs",
            "<leader>ts",
            "<cmd>Trouble symbols toggle focus=false<cr>",
            desc = "Symbols (Trouble)",
        },
        {
            "<leader>tl",
            "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
            desc = "[L]SP Definitions / references / ... (Trouble)",
        },
        {
            "<leader>tL",
            "<cmd>Trouble loclist toggle<cr>",
            desc = "Location List (Trouble)",
        },
        {
            "<leader>tQ",
            "<cmd>Trouble qflist toggle<cr>",
            desc = "Quickfix List (Trouble)",
        },
        {
            "<leader>tt",
            "<cmd>Trouble todo filter = {buf = 0}<cr>",
            desc = "Buffer [t]odo (all) (Trouble)",
        },
        {
            "<leader>tT",
            "<cmd>Trouble todo filter = {buf = 0, tag = {TODO,FIX,FIXME,BUG,FIXIT,ISSUE}}<cr>",
            desc = "Buffer [T]odo       (Trouble)",
        },
        {
            "<leader>ta",
            "<cmd>Trouble todo<cr>",
            desc = "Todo (all) (Trouble)",
        },
        {
            "<leader>tA",
            "<cmd>Trouble todo filter = {tag = {TODO,FIX,FIXME,BUG,FIXIT,ISSUE}}<cr>",
            desc = "Todo       (Trouble)",
        },
    },
}
