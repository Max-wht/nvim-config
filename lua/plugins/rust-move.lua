return {
  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("sui_move_treesitter", { clear = true }),
        pattern = "TSUpdate",
        callback = function()
          require("nvim-treesitter.parsers").move = {
            install_info = {
              url = "https://github.com/MystenLabs/sui",
              revision = "85b460a63fd76a15672bbe4820bde6db78a3cfb8",
              location = "external-crates/move/tooling/tree-sitter",
              queries = "external-crates/move/tooling/tree-sitter/queries",
            },
            maintainers = { "@MystenLabs" },
            tier = 3,
          }
        end,
      })
    end,
    opts = {
      ensure_installed = { "move" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Sui ships its Move language server as the hidden `sui analyzer` command.
        move_analyzer = {
          cmd = { "sui", "analyzer" },
          mason = false,
        },
        -- Use the rustup component so it always matches the active Rust toolchain.
        rust_analyzer = {
          mason = false,
        },
      },
    },
  },
}
