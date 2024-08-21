vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set("n", "<leader>ex", vim.cmd.Ex, { desc = 'E[x]plore (netrw)'})

vim.keymap.set('n', '<C-d>', '<C-d>zz') -- center after moving half page
vim.keymap.set('n', '<C-u>', '<C-u>zz') -- center after moving half page

vim.keymap.set({'n', 'v'}, '<leader>y', [["+y]],
    { desc = "[y]ank to system clipboard" }
) -- yank to system clipboard in *NORMAL* and *VISUAL* mode
vim.keymap.set('n', '<leader>Y', [["+Y]],
    { desc = "[Y]ank to system clipboard" }
) -- yank cursor=>EOL to system clipboard in *NORMAL* mode
vim.keymap.set('n', '<leader>yy', [[_"+y$]],
    { desc = "[y]ank line to system clipboard" }
) -- yank line to system clipboard in *NORMAL* mode
-- vim.keymap.set('n', '<leader>yy', [["+yg_]]) -- yank line to system clipboard in *NORMAL* mode

-- vim.keymap.set('n', '<leader>p', '"_dP') -- paste without changing the last yank register (useful for 'find and replacing')
vim.keymap.set('x', '<leader>p', [["_P]],
    { desc = "[p]aste w/o changing register" }
) -- paste without changing the last yank register (useful for 'find and replacing')
vim.keymap.set({"n", "v"}, '<leader>P', [["+P]],
    { desc = "[P]aste from system register"}
)

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]],
    { desc = "[d]elete w/o changing register" }
) -- delete without changing the last yank register in *NORMAL* and *VISUAL* mode

-- vim.keymap.set('v', '<leader>p', '"+p') -- paste from system clipboard in *VISUAL* mode
-- vim.keymap.set('v', '<leader>P', '"+P') -- paste from system clipboard in *VISUAL* mode
-- vim.keymap.set('n', '<leader>p', '"+p') -- paste from system clipboard in *NORMAL* mode
-- vim.keymap.set('n', '<leader>P', '"+P') -- paste from system clipboard in *NORMAL* mode

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv") -- Move selection line by line in visual mode
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv") -- Move selection line by line in visual mode

vim.keymap.set('n', '<leader>R', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = 'Replace current word in the whole file' }
)

-- surround
vim.keymap.set('x', '<leader>s{', [[c{ }<C-c>Pa <C-c>]], { desc = 'Surround selection with {}'} )
vim.keymap.set('x', [[<leader>s(]], [[c()<C-c>P]], { desc = [[Surround selection with ()]]} )
vim.keymap.set('x', [[<leader>s']], [[c''<C-c>P]], { desc = [[Surround selection with '']]} )
vim.keymap.set('x', [[<leader>s']], [[c''<C-c>P]], { desc = [[Surround selection with '']]} )
vim.keymap.set('x', '<leader>s<', 'c<><C-c>P', { desc = 'Surround selection with <>'} )
vim.keymap.set('x', '<leader>s"', [[c""<C-c>P]], { desc = 'Surround selection with ""'} )

vim.keymap.set('n', '<leader>s{', [[ciw{ }<C-c>Pa <C-c>$]], { desc = 'Surround word with {}'} )
vim.keymap.set('n', [[<leader>s(]], [[ciw()<C-c>P]], { desc = [[Surround word with ()]]} )
vim.keymap.set('n', [[<leader>s']], [[ciw''<C-c>P]], { desc = [[Surround word with '']]} )
vim.keymap.set('n', '<leader>s<', 'ciw<><C-c>P', { desc = 'Surround word with <>'} )
vim.keymap.set('n', '<leader>s[', 'ciw[]<C-c>P', { desc = 'Surround word with []'} )
vim.keymap.set('n', '<leader>s"', [[ciw""<C-c>P]], { desc = 'Surround word with ""'} )

-- vim.keymap.set('x', '<leader>s{', [[c{}<C-c>P]], { desc = 'Surround with {}'} )
-- vim.keymap.set('x', '<leader>s}', [[c{}<C-c>P]], { desc = 'Surround with {}'} )
-- vim.keymap.set('x', '<leader>s{', [[:s/\%V\(.*\)/{\1}/]], { desc = 'Surround with {}'} )

-- !!IMPORTANT: load these last
-- NOTE: these might cause problems if something uses these symbols in insert mode
vim.keymap.set('i', '{', '{}<C-c>i') -- auto close brackets
vim.keymap.set('i', '(', '()<C-c>i') -- auto close parentheses
vim.keymap.set('i', '[', '[]<C-c>i') -- auto close brackets
vim.keymap.set('i', '<', '<><C-c>i') -- auto close angle brackets
vim.keymap.set('i', [[']], [[''<C-c>i]]) -- auto close ''
vim.keymap.set('i', [["]], [[""<C-c>i]]) -- auto close ""

