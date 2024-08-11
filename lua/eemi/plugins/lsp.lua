return {
    --It's important that you set up the plugins in the following order:
    -- 1 mason.nvim
    -- 2 mason-lspconfig.nvim
    -- 3 neovim/nvim-lspconfig

    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },

    config = function()
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = { "lua_ls", },
        })

        print("Hello!!!!!")

        -- -- ========================
        -- -- NOT WORKING
        -- -- ========================
        -- vim.api.nvim_create_autocmd('LspAttach', {
        --     group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        --     callback = function(event)
        --         local map = function(keys, func, desc)
        --             vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        --         end
        --
        --         map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        --         map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        --         map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        --         -- map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        --         -- map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        --         -- map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        --         -- map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        --         -- map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        --         map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        --
        --         -- The following two autocommands are used to highlight references of the
        --         -- word under your cursor when your cursor rests there for a little while.
        --         --    See `:help CursorHold` for information about when this is executed
        --         --
        --         -- When you move your cursor, the highlights will be cleared (the second autocommand).
        --         local client = vim.lsp.get_client_by_id(event.data.client_id)
        --         if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
        --             local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
        --             vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        --                 buffer = event.buf,
        --                 group = highlight_augroup,
        --                 callback = vim.lsp.buf.document_highlight,
        --             })
        --
        --             vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        --                 buffer = event.buf,
        --                 group = highlight_augroup,
        --                 callback = vim.lsp.buf.clear_references,
        --             })
        --
        --             vim.api.nvim_create_autocmd('LspDetach', {
        --                 group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
        --                 callback = function(event2)
        --                     vim.lsp.buf.clear_references()
        --                     vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
        --                 end,
        --             })
        --         end
        --
        --         -- The following code creates a keymap to toggle inlay hints in your
        --         -- code, if the language server you are using supports them
        --         --
        --         -- This may be unwanted, since they displace some of your code
        --         if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
        --             map('<leader>th', function()
        --                 vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
        --             end, '[T]oggle Inlay [H]ints')
        --         end
        --     end,
        -- })

    end,
}
