return {
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("illuminate").configure({
        providers = { "lsp", "treesitter", "regex" },
        delay = 150,
        under_cursor = true,
        large_file_cutoff = 2000,
        large_file_overrides = {
          providers = { "lsp", "treesitter" },
        },
      })
    end,
  },
}
