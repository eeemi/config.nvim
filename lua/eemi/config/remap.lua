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
vim.keymap.set("n", "<C-W>M", ':res ', { desc = '[M]odify height'})

vim.keymap.set("n", "<S-Right>", ':vert res +10<CR>', { desc = 'Increase width by 10', silent = true })
vim.keymap.set("n", "<S-Left>", ':vert res -10<CR>', { desc = 'Decrease width by 10', silent = true })
vim.keymap.set("n", "<S-Down>", ':res +5<CR>', { desc = 'Increase height by 5', silent = true })
vim.keymap.set("n", "<S-Up>", ':res -5<CR>', { desc = 'Decrease height by 5', silent = true })

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

-- AUTO DELETION
--
-- EXAMPLE: 
-- If in insert mode between quotation marks `""`, 
-- pressing back space removes both characters.
--
vim.keymap.set('i', '<BS>', function ()
    local line = vim.fn.getline(".")
    local col = vim.fn.col(".")
    if 1 < col and col <= #line then
        local pair = line:sub(col-1, col)
        if
            pair == [[""]] or
            pair == [['']] or
            pair == [[``]] or
            pair == [[<>]] or
            pair == [[()]] or
            pair == [[{}]] or
            pair == '[]'
            then
                return [[<Del><BS>]]
            end
        end
        return [[<BS>]]
    end, { expr = true }
)

-- NOTE: 
-- ====================================================================================
-- everything after this line should be at the bottom in this file, in this order
-- ====================================================================================

-- AUTOCOMPLETE
vim.keymap.set('i', '(', '()<Left>')
vim.keymap.set('i', '[', '[]<Left>')
vim.keymap.set('i', '{', '{}<Left>')
vim.keymap.set('i', [[']], [[''<Left>]])
vim.keymap.set('i', [["]], [[""<Left>]])
vim.keymap.set('i', [[`]], [[``<Left>]])

-- AUTOSKIP 
local chars = {
    ['"'] = '"',
    ["'"] = "'",
    ["`"] = "`",
    ["("] = ")",
    ["["] = "]",
    ["{"] = "}",
}
for first, last in pairs(chars) do
    vim.keymap.set("i", first, function()
        local line = vim.fn.getline(".")
        local col = vim.fn.col(".")
        -- If cursor is before a closing quote of the same type, skip it
        -- BUG: possible bug
        -- Why does `first == last` pass the first if???
        if first == last and col <= #line and line:sub(col, col) == last then
            return "<Right>"
        end
        -- If it's a quote, insert both
        if first == last then
            return first .. last .. "<Left>"
        end
        -- Otherwise (brackets/braces/parens), insert first+last
        return first .. last .. "<Left>"
    end, { expr = true })
    -- For asymmetric pairs (brackets/braces/parens), add skip logic
    if first ~= last then
        vim.keymap.set("i", last, function()
            local col = vim.fn.col(".")
            local line = vim.fn.getline(".")
            if col <= #line and line:sub(col, col) == last then
                return "<Right>"
            else
                return last
            end
        end, { expr = true })
    end
end


