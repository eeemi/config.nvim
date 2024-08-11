return {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    -- or                              , branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },

    config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind files'})
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live [G]rep' })
        vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[B]uffers' })
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[H]elp tags' })
    end
}

