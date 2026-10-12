-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- Save without formatting; use <leader>p to format non-Markdown files manually.
vim.g.autoformat = false

-- editor.lineNumbers = off
opt.number = true
opt.relativenumber = true

-- editor.cursorSurroundingLines = 8
opt.scrolloff = 8
opt.sidescrolloff = 0

-- editor.wordWrap = on
opt.wrap = true
opt.linebreak = true
opt.breakindent = true

-- detectIndentation=false + tabWidth=4 + useTabs=false
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4

-- vim.timeout = 1000
opt.timeoutlen = 1000

-- Use one global statusline so sidebar buffers do not render their own [No Name] bars.
opt.laststatus = 3

-- Hide the idle command-line row below the statusline.
opt.cmdheight = 0

-- Match the visual settings used by Ghostty when running inside Neovide.
if vim.g.neovide then
  -- Ghostty: JetBrains Mono 15 with Noto Sans CJK SC fallback.
  vim.o.guifont = "JetBrainsMono Nerd Font Mono,Noto Sans CJK SC:h15"

  -- Keep the fullscreen grid flush with the bottom edge. Extra line spacing
  -- makes Neovide round the grid down and leaves an almost row-sized gap.
  opt.linespace = 0

  vim.g.neovide_padding_top = 0
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_padding_left = 0
  vim.g.neovide_padding_right = 0

  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_input_macos_option_key_is_meta = "both"
  vim.g.neovide_fullscreen = true
  vim.g.neovide_window_blurred = true

  -- Native, pixel-level animation. Keep the whole page animated on large jumps.
  vim.g.neovide_refresh_rate = 120
  vim.g.neovide_refresh_rate_idle = 5
  vim.g.neovide_scroll_animation_length = 0.12
  vim.g.neovide_scroll_animation_far_lines = 4
  vim.g.neovide_position_animation_length = 0.08
  vim.g.neovide_cursor_animation_length = 0.05
  vim.g.neovide_cursor_short_animation_length = 0.025
  vim.g.neovide_cursor_trail_size = 0.2
end
