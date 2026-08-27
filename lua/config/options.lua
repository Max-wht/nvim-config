-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

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

-- detectIndentation=false + tabWidth=8 + useTabs=false
opt.expandtab = true
opt.tabstop = 8
opt.softtabstop = 8
opt.shiftwidth = 8

-- vim.timeout = 1000
opt.timeoutlen = 1000

-- workbench.statusBar.visible = false;;;
opt.laststatus = 0
