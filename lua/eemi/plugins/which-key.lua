return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
    },
    config = function()

        local wk = require("which-key")
        wk.add({
            { "<leader>g", desc = '[g]it' },
            { "<leader>gt", desc = '[t]oggle' },
            { "<leader>e", desc = '[e]xplore (netrw)' },
            { "<leader>f", desc = 'Telescope' },
            { "<leader>h", desc = '[h]arpoon' },
            { "<leader>t", desc = '[t]rouble' },
            { "<leader>D", desc = '[D]ebugger' },
            { "<leader>c", desc = '[c]ode' },
            { "<leader>i", desc = '[i]ron' },
            { "gr", desc = '[r]ename' },

            -- { "<leader>f", group = "file" }, -- group
            -- { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File", mode = "n" },
            -- { "<leader>fb", function() print("hello") end, desc = "Foobar" },
            -- { "<leader>fn", desc = "New File" },
            -- { "<leader>f1", hidden = true }, -- hide this keymap
            -- { "<leader>w", proxy = "<c-w>", group = "windows" }, -- proxy to window mappings
            -- { "<leader>b", group = "buffers", expand = function()
            --     return require("which-key.extras").expand.buf()
            -- end
            -- },
            {
                -- Nested mappings are allowed and can be added in any order
                -- Most attributes can be inherited or overridden on any level
                -- There's no limit to the depth of nesting
                -- mode = { "n", "v" }, -- NORMAL and VISUAL mode
                -- { "<leader>q", "<cmd>q<cr>", desc = "Quit" }, -- no need to specify mode since it's inherited
                -- { "<leader>w", "<cmd>w<cr>", desc = "Write" },
            }
        })
    end,
    -- keys = {
    --   {
    --     "<leader>?",
    --     function()
    --       require("which-key").show({ global = false })
    --     end,
    --     desc = "Buffer Local Keymaps (which-key)",
    --   },
    -- },
}
