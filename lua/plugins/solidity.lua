-- lua/plugins/solidity.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        solidity_ls = { enabled = false },
        solidity_ls_nomicfoundation = {},
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        solidity = { "forge_fmt" },
      },
      formatters = {
        prettier = {
          prepend_args = {
            "--no-editorconfig",
            "--tab-width",
            "4",
            "--no-use-tabs",
          },
        },
      },
    },
  },
}
