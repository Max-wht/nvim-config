return {
  {
    "MattesGroeger/vim-bookmarks",
    -- The plugin registers its restore routine on VimEnter, so it must be
    -- sourced during startup rather than after VimEnter has already fired.
    lazy = false,
    init = function()
      -- Define mappings through lazy.nvim below so they are documented and
      -- do not depend on the plugin's anonymous default mappings.
      vim.g.bookmark_no_default_key_mappings = 1

      -- Keep bookmark state with Neovim's data instead of creating files in
      -- project repositories.
      vim.g.bookmark_auto_save = 1
      vim.g.bookmark_auto_save_file = vim.fn.stdpath("data") .. "/vim-bookmarks"

      vim.g.bookmark_auto_close = 1
      vim.g.bookmark_center = 1
      vim.g.bookmark_location_list = 1
      vim.g.bookmark_display_annotation = 1
      vim.g.bookmark_highlight_lines = 0

      vim.g.bookmark_sign = "⚑"
      vim.g.bookmark_annotation_sign = "☰"
    end,
    keys = {
      { "mm", "<Plug>BookmarkToggle", desc = "Toggle Bookmark" },
      { "mi", "<Plug>BookmarkAnnotate", desc = "Annotate Bookmark" },
      { "mn", "<Plug>BookmarkNext", desc = "Next Bookmark" },
      { "mp", "<Plug>BookmarkPrev", desc = "Previous Bookmark" },
      { "ma", "<Plug>BookmarkShowAll", desc = "List Bookmarks" },
      { "mc", "<Plug>BookmarkClear", desc = "Clear Buffer Bookmarks" },
      { "mx", "<Plug>BookmarkClearAll", desc = "Clear All Bookmarks" },
    },
  },
}
