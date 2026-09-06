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

      -- Keep syntax colors visible instead of filling the word with the theme's background.
      local function highlight_words()
        for _, group in ipairs({ "IlluminatedWordText", "IlluminatedWordRead", "IlluminatedWordWrite" }) do
          vim.api.nvim_set_hl(0, group, { underline = true })
        end
      end

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("illuminate_word_style", { clear = true }),
        callback = highlight_words,
      })
      highlight_words()
    end,
  },
}
