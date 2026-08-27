-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local im_select = vim.fn.exepath("im-select")
local default_im = "com.apple.keylayout.ABC"
local insert_im = default_im

local function get_im()
  if vim.fn.executable(im_select) ~= 1 then
    return nil
  end
  return vim.trim(vim.fn.system({ im_select }))
end

local function set_im(im)
  if im_select ~= "" and im and im ~= "" then
    vim.fn.jobstart({ im_select, im }, { detach = true })
  end
end

local group = vim.api.nvim_create_augroup("auto_input_method", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
  group = group,
  callback = function()
    insert_im = get_im() or default_im
    set_im(default_im)
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  group = group,
  callback = function()
    insert_im = get_im() or insert_im
    set_im(default_im)
  end,
})

vim.api.nvim_create_autocmd("InsertEnter", {
  group = group,
  callback = function()
    set_im(insert_im)
  end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = group,
  callback = function()
    set_im(insert_im)
  end,
})

local markdown_group = vim.api.nvim_create_augroup("markdown_options", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = markdown_group,
  pattern = { "markdown", "markdown.mdx" },
  callback = function()
    vim.opt_local.spell = false
  end,
})

-- Avoid stacking the Tmux status bar above Tabby while Neovim is active.
local function set_tmux_status(status)
  if not vim.env.TMUX or vim.fn.executable("tmux") ~= 1 then
    return
  end

  vim.fn.jobstart({ "tmux", "set-option", "-q", "status", status }, { detach = true })
end

local tmux_status_group = vim.api.nvim_create_augroup("tmux_status_for_neovim", { clear = true })

vim.api.nvim_create_autocmd({ "VimLeavePre", "VimSuspend" }, {
  group = tmux_status_group,
  callback = function()
    set_tmux_status("on")
  end,
})

vim.api.nvim_create_autocmd("VimResume", {
  group = tmux_status_group,
  callback = function()
    set_tmux_status("off")
  end,
})

set_tmux_status("off")
