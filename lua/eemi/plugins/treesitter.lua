return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    branch = "main",
    dependencies = { "williamboman/mason.nvim" },
    config = function ()

        -- NOTE: supported languages: `~/.local/share/nvim/lazy/nvim-treesitter/SUPPORTED_LANGUAGES.md`
        local languages = {
            "c",
            "lua",
            "vim",
            "vimdoc",
            "query",
            "markdown",
            "markdown_inline",
            "go",
            "python",
            "bash",
            "git_config",
            "git_rebase",
            "gitattributes",
            "gitcommit",
            "gitignore",
        }

        -- nvim-treesitter (main) compiles parsers with the `tree-sitter` CLI
        if vim.fn.executable("tree-sitter") == 1 then
            require("nvim-treesitter").install(languages)
        else
            require("mason").setup() -- NOTE: puts mason's bin dir on PATH
            local registry = require("mason-registry")
            registry.refresh(function()
                local pkg = registry.get_package("tree-sitter-cli")
                pkg:install():once("closed", vim.schedule_wrap(function()
                    require("nvim-treesitter").install(languages)
                end))
            end)
        end

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("treesitter-highlight", { clear = true }),
            callback = function(args)
                -- PERF: skip treesitter highlight for large files
                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
                if ok and stats and stats.size > max_filesize then
                    return
                end
                pcall(vim.treesitter.start, args.buf)
            end,
        })
    end
}
