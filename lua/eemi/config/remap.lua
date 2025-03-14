vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- NAVIGATION
vim.keymap.set('n', '<C-d>', '<C-d>zz') -- center after moving half page
vim.keymap.set('n', '<C-u>', '<C-u>zz') -- center after moving half page

vim.keymap.set("n", "<leader>ex", vim.cmd.Ex, { desc = 'E[x]plore (netrw)' })
-- vim.keymap.set("n", "<leader>G", ':G<CR>', { desc = 'Fu[G]itive (Git)' })

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv") -- Move selection line by line in visual mode
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv") -- Move selection line by line in visual mode

vim.keymap.set('n', '<C-S-Left>', "20<C-w>><CR>") -- Move selection line by line in visual mode

vim.keymap.set('n', ']b', ":bn<CR>", { desc = "next [b]uffer" })
vim.keymap.set('n', '[b', ":bN<CR>", { desc = "previous [b]uffer" })

-- move between spaces in command mode
vim.keymap.set('c', '<A-b>', "<C-Left>")
vim.keymap.set('c', '<A-f>', "<C-Right>")

-- CLIPBOARD
vim.keymap.set({'n', 'v'}, '<leader>y', [["+y]], { desc = "[y]ank to system clipboard" }) -- yank to system clipboard in *NORMAL* and *VISUAL* mode
vim.keymap.set('n', '<leader>Y', [["+Y]], { desc = "[Y]ank to system clipboard" }) -- yank cursor=>EOL to system clipboard in *NORMAL* mode
vim.keymap.set('n', '<leader>yy', [[_"+y$]], { desc = "[y]ank line to system clipboard" }) -- yank line to system clipboard in *NORMAL* mode
-- vim.keymap.set('n', '<leader>yy', [["+yg_]]) -- yank line to system clipboard in *NORMAL* mode
-- vim.keymap.set('n', '<leader>p', '"_dP') -- paste without changing the last yank register (useful for 'find and replacing')
vim.keymap.set('x', '<leader>p', [["_P]], { desc = "[p]aste w/o changing register" }) -- paste without changing the last yank register (useful for 'find and replacing')
vim.keymap.set({"n", "v"}, '<leader>P', [["+P]], { desc = "[P]aste from system register"})
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]], { desc = "[d]elete w/o changing register" }) -- delete without changing the last yank register in *NORMAL* and *VISUAL* mode
-- vim.keymap.set('v', '<leader>p', '"+p') -- paste from system clipboard in *VISUAL* mode
-- vim.keymap.set('v', '<leader>P', '"+P') -- paste from system clipboard in *VISUAL* mode
-- vim.keymap.set('n', '<leader>p', '"+p') -- paste from system clipboard in *NORMAL* mode
-- vim.keymap.set('n', '<leader>P', '"+P') -- paste from system clipboard in *NORMAL* mode

-- BUFFERS
vim.keymap.set("n", "<leader>B", ':%bd|e#<CR>', { desc = 'Unload [B]uffers except current'})

-- WINDOWS
vim.keymap.set("n", "<C-W>>", '50<C-w>>', { desc = 'Increase width by 50'})
vim.keymap.set("n", "<C-W><", '50<C-w><', { desc = 'Decrease width by 50'})
vim.keymap.set("n", "<C-W>m", ':vert res ', { desc = '[m]odify width'})

-- GENERATION
vim.keymap.set("n", "<leader>G", [[q:iput=range()->join(', ')<Esc>F)i<C-c>]], { desc = '[G]enerate sequence'})
-- vim.keymap.set("n", "<leader>G", [[:put=range()->join(', ')]], { desc = '[G]enerate sequence'}) -- use this with vscode emulation instead

-- RENAME
vim.keymap.set('n', '<leader>r', '*Ncgn', {desc = "[R]ename word, '.' to repeat for next"})
vim.keymap.set('x', '<leader>r', [[y/<C-r>"<CR>Ncgn]], {desc = "[R]ename word, '.' to repeat for next"}) -- TODO: better way to do it? update <pattern> inline?
vim.keymap.set('n', '<leader>R', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Replace current word in the whole file' })
vim.keymap.set('n', 'grn', vim.lsp.buf.rename, {desc = "Re[N]ame"}) -- NOTE: can have big impact
-- vim.keymap.set('n', 'gra', vim.lsp.buf.code_action, {desc = "Code [A]ction"})
-- vim.keymap.set('n', 'grr', vim.lsp.buf.references, {desc = "[R]eferences"})

