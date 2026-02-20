return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below

        vim.keymap.set("n", "]t", function()
            require("todo-comments").jump_next()
        end, { desc = "Next [t]odo comment (all)" }),
        vim.keymap.set("n", "]T", function()
            require("todo-comments").jump_next({keywords = {"TODO","FIX","FIXME","BUG","FIXIT","ISSUE"}})
        end, { desc = "Next [T]odo comment" }),
        vim.keymap.set("n", "[t", function()
            require("todo-comments").jump_prev()
        end, { desc = "Previous [t]odo comment" })
        vim.keymap.set("n", "]T", function()
            require("todo-comments").jump_prev({keywords = {"TODO","FIX","FIXME","BUG","FIXIT","ISSUE"}})
        end, { desc = "Previous [T]odo comment (all)" })

    },
}
