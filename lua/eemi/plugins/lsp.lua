return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",

        -- pyright
        -- {'neoclide/coc.nvim', branch= 'release',}
        -- run `:CocInstall coc-pyright`

        -- notifications
        "j-hui/fidget.nvim",

        {
            "ray-x/lsp_signature.nvim",
            event = "InsertEnter",
        },

        -- blink
        dependencies = { 'saghen/blink.cmp' },
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
        -- blink
        -- ----------------------------------------------------------------

        local capabilities = require('blink.cmp').get_lsp_capabilities()

        -- ----------------------------------------------------------------
        -- LspAttach
        -- ----------------------------------------------------------------

        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
            callback = function(event)
                local map = function(keys, func, desc)
                    vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                end

                map('gd', require('telescope.builtin').lsp_definitions, '[g]oto [d]efinition')
                map('gR', require('telescope.builtin').lsp_references, '[g]oto [r]eferences')
                map('gI', require('telescope.builtin').lsp_implementations, '[g]oto [I]mplementation')
                map('gh', require('telescope.builtin').lsp_type_definitions, 'Type Definition')
                -- map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
                -- map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[d]ocument [s]ymbols')
                -- map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
                -- map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                map('<leader>ca', vim.lsp.buf.code_action, '[c]ode [a]ction')
                map('gD', vim.lsp.buf.declaration, '[g]oto [D]eclaration')
                map('<leader>k', vim.lsp.buf.signature_help, 'signature help')

                -- The following two autocommands are used to highlight references of the
                -- word under your cursor when your cursor rests there for a little while.
                --    See `:help CursorHold` for information about when this is executed
                --
                -- When you move your cursor, the highlights will be cleared (the second autocommand).
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client:supports_method('textDocument/documentHighlight', event.buf) then
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
            -- lsp_signature
            -- ----------------------------------------------------------------

            require'lsp_signature'.setup({
                bind = true,
                hint_prefix = {
                    above = "↙ ",  -- when the hint is on the line above the current line
                    current = "← ",  -- when the hint is on the same line
                    below = "↖ "  -- when the hint is on the line below the current line
                },
                timer_interval = 50, -- default (200) timer check interval set to lower value if you want to reduce latency
                -- doc_lines = 10, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
                --                 -- set to 0 if you DO NOT want any API comments be shown
                --                 -- This setting only take effect in insert mode, it does not affect signature help in normal
                --                 -- mode, 10 by default
                -- max_height = 12, -- max height of signature floating_window, if content is more than max_height, you can scroll down
                --                  -- to view the hiding contents
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

                    -- source: https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim
                    ["gopls"] = function ()
                        local lspconfig = require("lspconfig")
                        lspconfig.gopls.setup({
                            settings = {
                                gopls = {
                                    analyses = {
                                        unusedparams = true,
                                    },
                                    staticcheck = true,
                                    gofumpt = true,
                                },
                            },
                        })

                        vim.api.nvim_create_autocmd("BufWritePre", {
                            pattern = "*.go",
                            callback = function()
                                local params = vim.lsp.util.make_range_params()
                                params.context = {only = {"source.organizeImports"}}
                                -- buf_request_sync defaults to a 1000ms timeout. Depending on your
                                -- machine and codebase, you may want longer. Add an additional
                                -- argument after params if you find that you have to write the file
                                -- twice for changes to be saved.
                                -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
                                local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
                                for cid, res in pairs(result or {}) do
                                    for _, r in pairs(res.result or {}) do
                                        if r.edit then
                                            local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                                            vim.lsp.util.apply_workspace_edit(r.edit, enc)
                                        end
                                    end
                                end
                                vim.lsp.buf.format({async = false})
                            end
                        })

                    end,

                    -- source: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#clangd
                    ["clangd"] = function ()
                        local lspconfig = require("lspconfig")
                        lspconfig.clangd.setup({
                            capabilities = capabilities,
                            -- capabilities = {
                            --     offsetEncoding = { "utf-8", "utf-16" },
                            --     textDocument = {
                            --         completion = {
                            --             editsNearCursor = true
                            --         }
                            --     }
                            -- },
                            cmd = { "clangd" },
                            filetypes = { "c", "cc", "cpp", "objc", "objcpp", "cuda", "proto" },
                            -- from here: https://www.reddit.com/r/neovim/comments/127pv2v/clangd_diagnostics/
                            -- > [!quote]
                            -- > "150 is supposed to be the default debounce time anyway but this fixed it for me, now I get nice and fast diagnostics when I exit Insert mode."
                            flags = {
                                debounce_text_changes = 150,
                            },
                        })
                    end,

                    }
                })
        end,
    }
