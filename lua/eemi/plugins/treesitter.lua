return {
    "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function ()
            local configs = require("nvim-treesitter.configs")

        configs.setup({
            -- ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
            -- ensure_installed = { "go", "lua", "bash", "markdown", "markdown_inline" },
            ensure_installed = {
                "c", -- always required
                "lua", -- always required
                "vim", -- always required
                "vimdoc", -- always required
                "query", -- always required
                "markdown", -- always required
                "markdown_inline", -- always required
                "go",
                "bash",
            },
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
        })
    end
}

