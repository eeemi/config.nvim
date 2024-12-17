return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",

        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-cmdline",

        -- luasnip
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",

        -- pyright
        -- {'neoclide/coc.nvim', branch= 'release',}
        -- run `:CocInstall coc-pyright`

        "j-hui/fidget.nvim",
    },

    -- TODO: Fix messy structure. Split some of the chunks to their own config files?

    config = function()
        -- ----------------------------------------------------------------
        -- conform
        -- ----------------------------------------------------------------

        require("conform").setup({
            formatters_by_ft = {
                -- lua = { "stylua" },
                -- -- Conform will run multiple formatters sequentially
                -- python = { "isort", "black" },
                -- -- You can customize some of the format options for the filetype (:help conform.format)
                -- rust = { "rustfmt", lsp_format = "fallback" },
                -- -- Conform will run the first available formatter
                -- javascript = { "prettierd", "prettier", stop_after_first = true },
            },
        })

        -- ----------------------------------------------------------------
        -- cmp
        -- ----------------------------------------------------------------

        local cmp = require('cmp')
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        cmp.setup({
            snippet = {
                expand = function(args)
                    -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                    -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                    -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                    -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
                end,
            },
            window = {
                -- completion = cmp.config.window.bordered(),
                -- documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                -- { name = 'vsnip' }, -- For vsnip users.
                { name = 'luasnip' }, -- For luasnip users.
                -- { name = 'ultisnips' }, -- For ultisnips users.
                -- { name = 'snippy' }, -- For snippy users.
            }, {
                { name = 'buffer' },
            })
        })

        -- ----------------------------------------------------------------
        -- LspAttach
        -- ----------------------------------------------------------------

        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
            callback = function(event)
                local map = function(keys, func, desc)
                    vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                end

                map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
                map('gR', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
                map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
                map('gh', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
                -- map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
                map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
                -- map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
                -- map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                -- map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
                map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                -- The following two autocommands are used to highlight references of the
                -- word under your cursor when your cursor rests there for a little while.
                --    See `:help CursorHold` for information about when this is executed
                --
                -- When you move your cursor, the highlights will be cleared (the second autocommand).
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                    local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
                    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight,
                    })

                    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references,
                    })

                    vim.api.nvim_create_autocmd('LspDetach', {
                        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
                        callback = function(event2)
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
                        end,
                    })
                end

                -- -- The following code creates a keymap to toggle inlay hints in your
                -- -- code, if the language server you are using supports them
                -- --
                -- -- This may be unwanted, since they displace some of your code
                -- if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                --     map('<leader>th', function()
                    --         vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
                    --     end, '[T]oggle Inlay [H]ints')
                    -- end
                end,
            })

            -- ----------------------------------------------------------------
            -- mason
            -- ----------------------------------------------------------------

            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "gopls",
                    "pyright",
                },
                handlers = {
                    -- The first entry (without a key) will be the default handler
                    -- and will be called for each installed server that doesn't have
                    -- a dedicated handler.
                    function (server_name) -- default handler (optional)
                        require("lspconfig")[server_name].setup {
                            capabilities = capabilities
                        }
                    end,
                    -- Next, you can provide targeted overrides for specific servers.
                    ["lua_ls"] = function ()
                        local lspconfig = require("lspconfig")
                        lspconfig.lua_ls.setup {
                            on_init = function(client)
                                if client.workspace_folders then
                                    local path = client.workspace_folders[1].name
                                    if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
                                        return
                                    end
                                end

                                client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                                    runtime = {
                                        -- Tell the language server which version of Lua you're using
                                        -- (most likely LuaJIT in the case of Neovim)
                                        version = 'LuaJIT'
                                    },
                                    -- Make the server aware of Neovim runtime files
                                    workspace = {
                                        checkThirdParty = false,
                                        library = {
                                            vim.env.VIMRUNTIME
                                            -- Depending on the usage, you might want to add additional paths here.
                                            -- "${3rd}/luv/library"
                                            -- "${3rd}/busted/library",
                                        }
                                        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
                                        -- library = vim.api.nvim_get_runtime_file("", true)
                                    }
                                })
                            end,
                            settings = {
                                Lua = {}
                            }
                        }
                    end,
                }
            })
        end,
    }
