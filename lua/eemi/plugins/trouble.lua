return {
  "folke/trouble.nvim",
  opts = {}, -- for default options, refer to the configuration section for custom setup.
  cmd = "Trouble",
  keys = {
    {
      -- "<leader>xx", -- ORIGINAL
      "<leader>tx",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      -- "<leader>xX", -- ORIGINAL
      "<leader>tX",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      -- "<leader>cs", -- ORIGINAL
      "<leader>ts",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Symbols (Trouble)",
    },
    -- {
    --   "<leader>cl",
    --   "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
    --   desc = "LSP Definitions / references / ... (Trouble)",
    -- },
    -- {
    --   -- "<leader>xL",
    --   "<leader>tL",
    --   "<cmd>Trouble loclist toggle<cr>",
    --   desc = "Location List (Trouble)",
    -- },
    -- {
    --   "<leader>xQ",
    --   "<cmd>Trouble qflist toggle<cr>",
    --   desc = "Quickfix List (Trouble)",
    -- },
  },
}
