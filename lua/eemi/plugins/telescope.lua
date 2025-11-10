return {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    -- or                              , branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'nvim-telescope/telescope-ui-select.nvim',
},
config = function()

    -- You dont need to set any of these options. These are the default ones. Only
    -- the loading is important
    require('telescope').setup {
        extensions = {
            fzf = {
                fuzzy = true,                    -- false will only do exact matching
                override_generic_sorter = true,  -- override the generic sorter
                override_file_sorter = true,     -- override the file sorter
                case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                -- the default case_mode is "smart_case"
            },
            ["ui-select"] = {
                require("telescope.themes").get_dropdown {
                    -- even more opts
                }

                -- pseudo code / specification for writing custom displays, like the one
                -- for "codeactions"
                -- specific_opts = {
                --   [kind] = {
                --     make_indexed = function(items) -> indexed_items, width,
                --     make_displayer = function(widths) -> displayer
                --     make_display = function(displayer) -> function(e)
                --     make_ordinal = function(e) -> string
                --   },
                --   -- for example to disable the custom builtin "codeactions" display
                --      do the following
                --   codeactions = false,
                -- }
            }
        }
    }
    -- To get fzf loaded and working with telescope, you need to call
    -- load_extension, somewhere after setup function:
    require('telescope').load_extension('fzf')
    require("telescope").load_extension("ui-select")

    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find [f]iles' })
    vim.keymap.set('n', '<leader>fF', function() builtin.find_files({ hidden = true, no_ignore = true })  end, { desc = 'Telescope find [F]iles (hidden)' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live [g]rep' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope [b]uffers' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope [h]elp tags' })
    vim.keymap.set('n', '<leader>fz', builtin.treesitter, { desc = 'Telescope Treesitter' })
    -- vim.keymap.set('n', '<leader>fr', builtin.lsp_references, { desc = 'Telescope [r]eferences' })
    vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = 'Telescope [s]ymbols' })
    vim.keymap.set('n', '<leader>fS', builtin.lsp_workspace_symbols, { desc = 'Telescope workspace [S]ymbols' })
    vim.keymap.set('n', '<leader>fD', builtin.lsp_dynamic_workspace_symbols, { desc = 'Telescope [D]ynamic workspace symbols' })
    vim.keymap.set('n', '<leader>ft', [[:TodoTelescope<CR>]], { desc = 'Telescope [t]odo list (all)' })
    vim.keymap.set('n', '<leader>fT', [[:TodoTelescope keywords=TODO,FIX,FIXME,BUG,FIXIT,ISSUE<CR>]], { desc = 'Telescope [T]odo list' })
    vim.keymap.set('n', '<leader>fm', builtin.man_pages, { desc = 'Telescope [m]an pages' })

    end,
}
