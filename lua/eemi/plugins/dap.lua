return {
    "mfussenegger/nvim-dap",

    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        "leoluz/nvim-dap-go", -- go
    },

    config = function ()
        -- ----------------------------------------------------------------
        -- dap/ui setup
        -- ----------------------------------------------------------------

        local dap = require("dap")
        local dapui = require("dapui")
        local dapui_widgets = require('dap.ui.widgets')

        dapui.setup()

        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        vim.keymap.set('n', '<F5>', function() dap.continue() end)
        vim.keymap.set('n', '<F6>', function() dap.terminate() end)
        vim.keymap.set('n', '<F10>', function() dap.step_over() end)
        vim.keymap.set('n', '<F11>', function() dap.step_into() end)
        vim.keymap.set('n', '<F12>', function() dap.step_out() end)
        vim.keymap.set('n', '<Leader>b', function() dap.toggle_breakpoint() end, {desc = 'Toggle [b]reakpoint'})
        vim.keymap.set('n', '<Leader>DB', function() dap.set_breakpoint() end, {desc = 'Set [B]reakpoint'})
        vim.keymap.set('n', '<Leader>Dp', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
        vim.keymap.set('n', '<Leader>Dr', function() dap.repl.open() end, {desc = 'Open [R]epl'})
        -- vim.keymap.set('n', '<Leader>dl', function() dap.run_last() end)
        vim.keymap.set({'n', 'v'}, '<Leader>Dh', function() dapui_widgets.hover() end, {desc = '[H]over widgets'})
        vim.keymap.set({'n', 'v'}, '<Leader>Dp', function() dapui_widgets.preview() end, {desc = '[P]review widgets'})
        vim.keymap.set('n', '<Leader>Df', function() local widgets = dapui_widgets widgets.centered_float(widgets.frames) end,
        {desc = 'Centered float (frames)'})
        vim.keymap.set('n', '<Leader>Ds', function() local widgets = dapui_widgets widgets.centered_float(widgets.scopes) end,
        {desc = 'Centered float (scopes)'})

        vim.fn.sign_define('DapBreakpoint',
        {
            text='🔴',
            texthl='DapBreakpointSymbol',
            linehl='DapBreakpoint',
            numhl='DapBreakpoint'
        })
        vim.fn.sign_define('DapStopped',
        {
            text='>',
            texthl='DapStoppedSymbol',
            linehl='DapBreakpoint',
            numhl='DapBreakpoint'
        })

        -- local set_namespace = vim.api.nvim__set_hl_ns or vim.api.nvim_set_hl_ns
        -- local namespace = vim.api.nvim_create_namespace("dap-hlng")
        -- vim.api.nvim_set_hl(namespace, 'DapBreakpoint', { fg='#eaeaeb', bg='#ffffff' })
        -- vim.api.nvim_set_hl(namespace, 'DapLogPoint', { fg='#eaeaeb', bg='#ffffff' })
        -- vim.api.nvim_set_hl(namespace, 'DapStopped', { fg='#eaeaeb', bg='#ffffff' })
        --
        -- vim.fn.sign_define('DapBreakpoint', { text='', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
        -- vim.fn.sign_define('DapBreakpointCondition', { text='ﳁ', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
        -- vim.fn.sign_define('DapBreakpointRejected', { text='', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl= 'DapBreakpoint' })
        -- vim.fn.sign_define('DapLogPoint', { text='', texthl='DapLogPoint', linehl='DapLogPoint', numhl= 'DapLogPoint' })
        -- vim.fn.sign_define('DapStopped', { text='', texthl='DapStopped', linehl='DapStopped', numhl= 'DapStopped' })

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

    end,
}
