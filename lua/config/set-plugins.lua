-- ========================
--  which-key
-- ========================
local wk = require("which-key")
wk.add({
    { "<leader>g", desc = '[G]o to' },
    -- { "<leader>g", group = "[G]o to" },
    { "<leader>e", desc = '[E]xplore (netrw)' },
    { "<leader>f", desc = 'Telescope' },
    { "<leader>h", desc = 'Harpoon' },

  -- DEFAULTS START 
  -- { "<leader>f", group = "file" }, -- group
  -- { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File", mode = "n" },
  -- { "<leader>fb", function() print("hello") end, desc = "Foobar" },
  -- { "<leader>fn", desc = "New File" },
  -- { "<leader>f1", hidden = true }, -- hide this keymap
  -- { "<leader>w", proxy = "<c-w>", group = "windows" }, -- proxy to window mappings
  -- { "<leader>b", group = "buffers", expand = function()
  --     return require("which-key.extras").expand.buf()
  --   end
  -- },
  -- {
  --   -- Nested mappings are allowed and can be added in any order
  --   -- Most attributes can be inherited or overridden on any level
  --   -- There's no limit to the depth of nesting
  --   mode = { "n", "v" }, -- NORMAL and VISUAL mode
  --   { "<leader>q", "<cmd>q<cr>", desc = "Quit" }, -- no need to specify mode since it's inherited
  --   { "<leader>w", "<cmd>w<cr>", desc = "Write" },
  -- }
  -- DEFAULTS END 
})

-- ========================
-- telescope
-- ========================
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind files'})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live [G]rep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[B]uffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[H]elp tags' })

-- ========================
-- undotree
-- ========================
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = '[U]ndotree Toggle' })

-- ========================
-- harpoon
-- ========================
local harpoon = require('harpoon')
harpoon:setup({})

-- basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end

vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
    { desc = "Open harpoon window" })

vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = 'Harpoon [A]dd' })
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "<leader>hl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, {desc = "Harpoon [L]ist (Ctrl+e)"} )

-- vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
-- vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
-- vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
-- vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-k>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-j>", function() harpoon:list():next() end)
-- vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
-- vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)


