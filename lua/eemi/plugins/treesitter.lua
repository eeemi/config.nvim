return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    branch = "main",
    config = function ()

        -- NOTE: supported languages: `~/.local/share/nvim/lazy/nvim-treesitter/SUPPORTED_LANGUAGES.md`
        require("nvim-treesitter").install {
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
