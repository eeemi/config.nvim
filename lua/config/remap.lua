vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set("n", "<leader>ex", vim.cmd.Ex, { desc = 'E[x]plore (netrw)'})

vim.keymap.set('n', '<C-d>', '<C-d>zz') -- center after moving half page
vim.keymap.set('n', '<C-u>', '<C-u>zz') -- center after moving half page

vim.keymap.set({'n', 'v'}, '<leader>y', [["+y]]) -- yank to system clipboard in *NORMAL* and *VISUAL* mode
vim.keymap.set('n', '<leader>Y', [["+Y]]) -- yank cursor=>EOL to system clipboard in *NORMAL* mode
vim.keymap.set('n', '<leader>yy', [[_"+y$]]) -- yank line to system clipboard in *NORMAL* mode
-- vim.keymap.set('n', '<leader>yy', [["+yg_]]) -- yank line to system clipboard in *NORMAL* mode

-- vim.keymap.set('n', '<leader>p', '"_dP') -- paste without changing the last yank register (useful for 'find and replacing')
vim.keymap.set('x', '<leader>p', [["_P]]) -- paste without changing the last yank register (useful for 'find and replacing')

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]]) -- delete without changing the last yank register in *NORMAL* and *VISUAL* mode

-- vim.keymap.set('v', '<leader>p', '"+p') -- paste from system clipboard in *VISUAL* mode
-- vim.keymap.set('v', '<leader>P', '"+P') -- paste from system clipboard in *VISUAL* mode
-- vim.keymap.set('n', '<leader>p', '"+p') -- paste from system clipboard in *NORMAL* mode
-- vim.keymap.set('n', '<leader>P', '"+P') -- paste from system clipboard in *NORMAL* mode

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv") -- Move selection line by line in visual mode
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv") -- Move selection line by line in visual mode

vim.keymap.set('n', '<leader>R', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Replace current word in the whole file' })

