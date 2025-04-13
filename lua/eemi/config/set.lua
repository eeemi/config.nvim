vim.opt.nu = true
vim.opt.relativenumber = true


vim.opt.updatetime = 50
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

-- vim.opt.swapfile = false
-- vim.opt.backup = false
-- vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
-- vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

-- vim.opt.termguicolors = true

vim.opt.scrolloff = 12
-- vim.opt.signcolumn = "yes"
-- vim.opt.isfname:append("@-@")

-- vim.opt.colorcolumn = "80"

vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('highlight_yank', {}),
    desc = 'Highlight on yank',
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- local options for `c` filetypes
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'cpp', 'cc' },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})

