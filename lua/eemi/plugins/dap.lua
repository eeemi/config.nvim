return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        { "theHamsta/nvim-dap-virtual-text",
        dependencies = { "nvim-treesitter/nvim-treesitter" }, -- NOTE: which loads first, this dep or the one in its own file?
        },
        "nvim-neotest/nvim-nio",
        { "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "williamboman/mason.nvim", }, -- NOTE: which loads first, this dep or the one in its own file?
        },
        -- language specific
        "leoluz/nvim-dap-go", -- go
        -- plenary
        "nvim-lua/plenary.nvim",
    },

    config = function ()
        local dap = require("dap")
        local dapui = require("dapui")
        local dapui_widgets = require('dap.ui.widgets')
        local nvim_dap_virtual_text = require("nvim-dap-virtual-text")
        local nio = require("nio")
        local mason_nvim_dap = require("mason-nvim-dap")
        local plenary_path = require("plenary.path")

        -- ----------------------------------------------------------------
        -- nvim_dap_virtual_text setup
        -- ----------------------------------------------------------------

        -- from https://github.com/theHamsta/nvim-dap-virtual-text
        -- NOTE: this block seems to disable inline diagnostics
        -- to manually enable them, run `lua vim.diagnostic.config({ virtual_text = true })`
        nvim_dap_virtual_text.setup({
            enabled = true,                        -- enable this plugin (the default)
            enabled_commands = true,               -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
            highlight_changed_variables = true,    -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
            highlight_new_as_changed = false,      -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
            show_stop_reason = true,               -- show stop reason when stopped for exceptions
            commented = false,                     -- prefix virtual text with comment string
            only_first_definition = true,          -- only show virtual text at first definition (if there are multiple)
            all_references = false,                -- show virtual text on all all references of the variable (not only definitions)
            clear_on_continue = false,             -- clear virtual text on "continue" (might cause flickering when stepping)
            --- A callback that determines how a variable is displayed or whether it should be omitted
            --- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
            --- @param buf number
            --- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
            --- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
            --- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
            --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
            display_callback = function(variable, buf, stackframe, node, options)
                -- by default, strip out new line characters
                if options.virt_text_pos == 'inline' then
                    return ' = ' .. variable.value:gsub("%s+", " ")
                else
                    return variable.name .. ' = ' .. variable.value:gsub("%s+", " ")
                end
            end,
            -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
            virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',

            -- experimental features:
            all_frames = false,                    -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
            virt_lines = false,                    -- show virtual lines instead of virtual text (will flicker!)
            virt_text_win_col = nil                -- position the virtual text at a fixed window column (starting from the first text column) ,
            -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
        })
        -- re-enable inline diagnostics
        -- NOTE: might cause problems with dap related virtual texts
        vim.diagnostic.config({
            virtual_text = true,
        })


        -- ----------------------------------------------------------------
        -- dap/ui setup
        -- ----------------------------------------------------------------

        local dapuiConfig = {
            controls = {
                icons = {
                    disconnect = " (C-S-F5)",
                    pause = "",
                    play = " (F5)",
                    run_last = " (F9)",
                    step_back = " (F10)",
                    step_into = " (F8)",
                    step_out = " (F6)",
                    step_over = " (F7)",
                    terminate = " (C-F5)",
                }
            },
            mappings = {
                edit = "e",
                expand = { "<CR>", "<2-LeftMouse>" },
                open = "o",
                remove = "d",
                repl = "r",
                toggle = "t"
            },
        }
        dapui.setup(dapuiConfig)

        -- ---

        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function() -- BUG: when debugging c++, debug adapter fails to notify its termination
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        -- from `:h dap-mappings`
        vim.keymap.set('n', '<leader>Dl', function() vim.cmd("DapVirtualTextForceRefresh") end, {desc = "c[l]ear dap virtual text"}) -- HACK: If debug adapter fails to notify its termination and leaves lingering dap virtual text, this can be used.
        vim.keymap.set('n', '<leader>Db', function() dap.clear_breakpoints() end, {desc = "clear [b]reakpoints"})
        vim.keymap.set('n', '<leader>Da', function() print(vim.inspect(dapuiConfig.mappings)) end, {desc = "available [a]ctions"})
        vim.keymap.set({'n', 'v'}, '<leader>DK', function() dapui.eval() end, {desc = "eval virtual text"})
        vim.keymap.set('n', '<leader>Dt', function() dapui.toggle({}) end, {desc = "[t]oggle UI"})
        vim.keymap.set('n', '<leader>Ds', function() dap.continue() end, {desc = "[S]tart (F5)"})
        vim.keymap.set('n', '<F5>', function() dap.continue() end, {desc = "Start (F5)"})
        vim.keymap.set('n', '<F29>', function() dap.terminate() end, {desc = "Terminate (C-F5)"})
        vim.keymap.set('n', '<F9>', function() dap.run_last() end)
        vim.keymap.set('n', '<F7>', function() dap.step_over() end)
        vim.keymap.set('n', '<F8>', function() dap.step_into() end)
        vim.keymap.set('n', '<F6>', function() dap.step_out() end)
        vim.keymap.set('n', '<F10>', function() dap.step_back() end) -- is this needed?
        vim.keymap.set('n', '<F41>', function() dap.disconnect() end, {desc = "Disconnect (C-S-F5)"})
        vim.keymap.set('n', '<F17>', function() dap.restart() end, {desc = "Restart (S-F5)"})
        vim.keymap.set('n', '<leader>b', function() dap.toggle_breakpoint() end, {desc = 'Toggle [b]reakpoint'})
        vim.keymap.set('n', '<leader>DB', function() dap.set_breakpoint() end, {desc = 'Set [B]reakpoint'})
        vim.keymap.set('n', '<leader>Dp', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
        vim.keymap.set('n', '<leader>Dr', function() dap.repl.open() end, {desc = 'Open [R]epl'})
        -- vim.keymap.set('n', '<leader>Dl', function() dap.run_last() end)
        vim.keymap.set({'n', 'v'}, '<leader>Dh', function() dapui_widgets.hover() end, {desc = '[H]over widgets'})
        vim.keymap.set({'n', 'v'}, '<leader>Dp', function() dapui_widgets.preview() end, {desc = '[P]review widgets'})
        vim.keymap.set('n', '<leader>Df', function() local widgets = dapui_widgets widgets.centered_float(widgets.frames) end,
        {desc = 'Centered float (frames)'})
        vim.keymap.set('n', '<leader>Ds', function() local widgets = dapui_widgets widgets.centered_float(widgets.scopes) end,
        {desc = 'Centered float (scopes)'})

        -- from (here)[https://www.lazyvim.org/extras/dap/core]. Same [here](https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/dap/core.lua)
        vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
        local dap_icons = {
            Stopped             = { "", "DiagnosticWarn", "DapStoppedLine" },
            Breakpoint          = { "", "DiagnosticError"}, -- this makes a small red circle
            BreakpointCondition = "",
            BreakpointRejected  = { "", "DiagnosticError" },
            LogPoint            = ".>",
        }
        for name, sign in pairs(dap_icons) do
            sign = type(sign) == "table" and sign or { sign }
            vim.fn.sign_define(
                "Dap" .. name,
                { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
            )
        end

        -- NOTE: this does essentially the same as above
        -- vim.fn.sign_define('DapBreakpoint',
        -- {
        --     text= '',
        --     texthl='DiagnosticError',
        -- })
        -- vim.fn.sign_define('DapStopped',
        -- {
        --     text='',
        --     texthl='DiagnosticWarn',
        --     linehl='DapStoppedLine',
        --     numhl='DapStoppedLine'
        -- })


        -- ----------------------------------------------------------------
        -- mason_nvim_dap setup
        -- ----------------------------------------------------------------

        -- from https://github.com/jay-babu/mason-nvim-dap.nvim#default-configuration 
        mason_nvim_dap.setup({
            -- A list of adapters to install if they're not already installed.
            -- This setting has no relation with the `automatic_installation` setting.
            ensure_installed = {
                'delve', -- go
                'cpptools', -- c++
                -- 'codelldb', -- c++
                -- 'debugpy', --python
            },
        })

        -- ----------------------------------------------------------------
        -- dap go
        -- ----------------------------------------------------------------

        require('dap-go').setup {
            -- Additional dap configurations can be added.
            -- dap_configurations accepts a list of tables where each entry
            -- represents a dap configuration. For more details see:
            -- |dap-configuration|
            dap_configurations = {
                -- {
                --     -- Must be "go" or it will be ignored by the plugin
                --     type = "go",
                --     name = "Attach remote",
                --     mode = "remote",
                --     request = "attach",
                -- },
                {
                    type = "go",
                    name = "Debug (Build Flags)",
                    request = "launch",
                    program = "${file}",
                    buildFlags = require("dap-go").get_build_flags,
                },
            },
            -- delve configurations
            delve = {
                -- the path to the executable dlv which will be used for debugging.
                -- by default, this is the "dlv" executable on your PATH.
                path = "dlv",
                -- time to wait for delve to initialize the debug session.
                -- default to 20 seconds
                initialize_timeout_sec = 20,
                -- a string that defines the port to start delve debugger.
                -- default to string "${port}" which instructs nvim-dap
                -- to start the process in a random available port.
                -- if you set a port in your debug configuration, its value will be
                -- assigned dynamically.
                port = "${port}",
                -- additional args to pass to dlv
                args = {},
                -- the build flags that are passed to delve.
                -- defaults to empty string, but can be used to provide flags
                -- such as "-tags=unit" to make sure the test suite is
                -- compiled during debugging, for example.
                -- passing build flags using args is ineffective, as those are
                -- ignored by delve in dap mode.
                build_flags = "",
                -- whether the dlv process to be created detached or not. there is
                -- an issue on Windows where this needs to be set to false
                -- otherwise the dlv server creation will fail.
                detached = true
            },
            -- options related to running closest test
            tests = {
                -- enables verbosity when running the test.
                verbose = false,
            },
        }

        -- dap.configurations.go = {
        --     {
        --         type = 'go',
        --         request = "launch",
        --         program = '${file}',
        --     },
        -- }

        -- dap.configurations.cpp = {
        --     {
        --         type = 'go',
        --         request = "launch",
        --         program = '${file}',
        --     },
        -- }

        -- ----------------------------------------------------------------
        -- c++ debugging
        -- ----------------------------------------------------------------

        local function load_debug_config()
            local path = vim.fn.getcwd() .. '/' .. vim.split(vim.fn.expand('%'), '/')[1]
            vim.fn.writefile({path}, '/tmp/dap-log.txt')

            local configPath = plenary_path:new(path, 'debug.json')

            if not configPath:exists() then
                vim.fn.writefile({"'debug.json' file not found."}, '/tmp/dap-log.txt')
                -- print("'debug.json' file not found.")
                return nil
            end

            local ok, config = pcall(configPath.read, configPath)
            if not ok then
                vim.fn.writefile({"Failed to read 'debug.json'."}, '/tmp/dap-log.txt')
                -- print("Failed to read 'debug.json'.")
                return nil
            end

            local json_ok, json = pcall(vim.json.decode, config)
            if not json_ok then
                vim.fn.writefile({"Failed to decode 'debug.json'."}, '/tmp/dap-log.txt')
                -- print("Failed to decode 'debug.json'.")
                return nil
            end

            return json

        end


        -- load_debug_config()

        -- `:h dap-adapter`
        dap.adapters.cppdbg = {
            name = 'cppdbg',
            type = 'executable',
            command = vim.fn.stdpath('data') .. '/mason/bin/OpenDebugAD7',
        }
        dap.configurations.cpp = {
            {
                name = "Launch",
                type = "cppdbg",
                request = "launch",
                -- program = function()
                --     -- return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                --     return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                -- end,

                -- 
                program = function()
                    local path = vim.split(vim.fn.expand('%'), '%.')[1]
                    return (path and path ~= "") and path or dap.ABORT
                end,

                cwd = '${workspaceFolder}',
                stopOnEntry = false,
                -- args = { "tests/001-simple-small.txt" }, -- this works!
                args = { function ()
                    local testPath = vim.fn.getcwd() .. '/' .. vim.split(vim.fn.expand('%'), '/')[1]
                    local config = load_debug_config()
                    if config == nil then
                        return nil
                    end
                    -- return vim.fn.input('Path to test: ', "tests/", "file")
                    -- return vim.fn.input(config.test, path .. "/tests/", "file")
                    return testPath .. '/' .. config.test
                end },
                runInTerminal = true,
                -- externalConsole = true,
            },
        }

        dap.configurations.h = dap.configurations.cpp
        dap.configurations.cc = dap.configurations.cpp
        dap.configurations.c = dap.configurations.cpp
        dap.configurations.cuda = dap.configurations.cpp

        -- dap.adapters.codelldb = {
        --     type = "server",
        --     port = "${port}",
        --     executable = {
        --         command = vim.fn.stdpath('data') .. '/mason/bin/codelldb',
        --         -- command = "codelldb",
        --         args = { "--port", "${port}" },
        --     },
        -- }
        -- dap.configurations.cpp = {
        --     {
        --         name = "Launch file",
        --         type = "codelldb",
        --         request = "launch",
        --         program = function()
        --             return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        --         end,
        --         cwd = "${workspaceFolder}",
        --         stopOnEntry = true,
        --     },
        -- }

        -- ----------------------------------------------------------------
        -- python debugging
        -- ----------------------------------------------------------------

        dap.adapters.python = {
            type = "executable",
            command = vim.fn.stdpath('data') .. '/mason/bin/debugpy-adapter'
        }
        dap.configurations.python = {
            {
                justMyCode = true;
                type = 'python';
                request = 'launch';
                name = 'Launch current file';
                program = "${file}";
                python = function()
                    local venv = os.getenv("VIRTUAL_ENV")
                    if venv then
                        return venv .. "/bin/python3"
                    end
                    return "/usr/bin/env python3"
                end
            },
            -- template for exact file
            -- {
            --     justMyCode = true;
            --     type = 'python';
            --     request = 'launch';
            --     name = 'Launch file.py';
            --     program = "/path/to/file.py";
            --     python = function()
            --         return '/path/to/.venv/bin/python3'
            --     end
            -- },
        }


    end,
}
