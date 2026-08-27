-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local im_select = "/opt/homebrew/bin/im-select"
local default_im = "com.apple.keylayout.ABC"
local insert_im = default_im

local function get_im()
  if vim.fn.executable(im_select) ~= 1 then
    return nil
  end
  return vim.trim(vim.fn.system({ im_select }))
end

local function set_im(im)
  if im and im ~= "" then
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
