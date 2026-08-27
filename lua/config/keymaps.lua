-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Replace LazyVim's Ctrl-/ terminal shortcut with Command-j.
pcall(vim.keymap.del, { "n", "t" }, "<C-/>")
pcall(vim.keymap.del, { "n", "t" }, "<C-_>")

local function main_editor_win()
  local current = vim.api.nvim_get_current_win()

  local function is_editor(win)
    if not vim.api.nvim_win_is_valid(win) then
      return false
    end

    local buf = vim.api.nvim_win_get_buf(win)
    local config = vim.api.nvim_win_get_config(win)
    return config.relative == ""
      and not vim.w[win].snacks_layout
      and (vim.bo[buf].buftype == "" or vim.b[buf].snacks_main or vim.w[win].snacks_main)
  end

  if is_editor(current) then
    return current
  end

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if is_editor(win) then
      return win
    end
  end

  return current
end

local terminal = {
  buf = nil,
  job = nil,
  previous = {},
}

local function terminal_running()
  if not (terminal.buf and vim.api.nvim_buf_is_valid(terminal.buf) and terminal.job) then
    return false
  end
  return vim.fn.jobwait({ terminal.job }, 0)[1] == -1
end

local function restore_editor(win)
  local previous = terminal.previous[win]
  if not (previous and vim.api.nvim_buf_is_valid(previous) and previous ~= terminal.buf) then
    previous = vim.api.nvim_create_buf(true, false)
  end

  vim.api.nvim_win_set_buf(win, previous)
  terminal.previous[win] = nil
  vim.api.nvim_set_current_win(win)
  vim.cmd.stopinsert()
end

local function toggle_terminal()
  if terminal.buf and vim.api.nvim_buf_is_valid(terminal.buf) then
    local terminal_win = vim.fn.bufwinid(terminal.buf)
    if terminal_win ~= -1 then
      restore_editor(terminal_win)
      return
    end
  end

  local win = main_editor_win()
  terminal.previous[win] = vim.api.nvim_win_get_buf(win)
  vim.api.nvim_set_current_win(win)

  if not terminal_running() then
    if terminal.buf and vim.api.nvim_buf_is_valid(terminal.buf) then
      vim.api.nvim_buf_delete(terminal.buf, { force = true })
    end

    -- Keep the terminal out of Bufferline; it is a temporary panel, not a file tab.
    terminal.buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(win, terminal.buf)
    terminal.job = vim.api.nvim_buf_call(terminal.buf, function()
      return vim.fn.termopen(vim.o.shell, { cwd = LazyVim.root() })
    end)
    vim.bo[terminal.buf].bufhidden = "hide"

    if terminal.job <= 0 then
      restore_editor(win)
      vim.notify("Failed to start terminal", vim.log.levels.ERROR)
      return
    end
  else
    vim.api.nvim_win_set_buf(win, terminal.buf)
  end

  vim.cmd.startinsert()
end

vim.keymap.set({ "n", "t" }, "<D-j>", toggle_terminal, { desc = "Toggle Full Editor Terminal" })
vim.keymap.set("n", "<leader>ft", toggle_terminal, { desc = "Toggle Full Editor Terminal" })
vim.keymap.set("n", "<leader>fT", toggle_terminal, { desc = "Toggle Full Editor Terminal" })

local map = vim.keymap.set

-- VS Code Vim: insert mode.
map("i", "jk", "<Esc>", { desc = "Exit Insert Mode" })

-- VS Code Vim: normal mode.
map("n", "<leader>-", "<C-o>", { desc = "Navigate Back" })
map("n", "[", "{", { desc = "Previous Paragraph" })
map("n", "]", "}", { desc = "Next Paragraph" })
map("n", "<S-Tab>", "<<", { desc = "Outdent Line" })

-- VS Code Vim: editor pages / buffers.
map("n", "<leader>tp", "<cmd>bprevious<cr>", { desc = "Previous Editor" })
map("n", "<leader>tn", "<cmd>bnext<cr>", { desc = "Next Editor" })
map("n", "<leader>to", "<cmd>enew<cr>", { desc = "New Editor" })
map("n", "<leader>xx", function()
  Snacks.bufdelete()
end, { desc = "Close Current Editor" })
map("n", "<leader>xa", function()
  Snacks.bufdelete.other()
end, { desc = "Close Other Editors" })

-- VS Code Vim: panes and navigation.
map("n", "<leader>v", "<C-w>v", { desc = "Split Editor Right", remap = true })
map("n", "<leader>h", "<C-w>h", { desc = "Focus Left Editor", remap = true })
map("n", "<leader>j", "<C-w>j", { desc = "Focus Lower Editor", remap = true })
map("n", "<leader>k", "<C-w>k", { desc = "Focus Upper Editor", remap = true })
map("n", "<leader>l", "<C-w>l", { desc = "Focus Right Editor", remap = true })

-- VS Code Vim: explorer, files, save and format.
map("n", "<leader>e", function()
  Snacks.explorer({ cwd = LazyVim.root() })
end, { desc = "Explorer" })
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save File" })
map("n", "<leader>f", function()
  Snacks.picker.files({ cwd = LazyVim.root() })
end, { desc = "Quick Open" })
map("n", "<leader>p", function()
  LazyVim.format({ force = true })
end, { desc = "Format Document" })

-- VS Code Vim: visual mode.
map("x", "<", "<gv", { desc = "Outdent Selection" })
map("x", ">", ">gv", { desc = "Indent Selection" })
map("x", "J", ":move '>+1<CR>gv=gv", { desc = "Move Selection Down" })
map("x", "K", ":move '<-2<CR>gv=gv", { desc = "Move Selection Up" })
map("x", "<leader>c", "gc", { desc = "Toggle Comment", remap = true })
map("x", "<Tab>", ">gv", { desc = "Indent Selection" })
map("x", "<S-Tab>", "<gv", { desc = "Outdent Selection" })

-- VS Code: cycle integrated terminals.
local function cycle_terminal(direction)
  local terminals = Snacks.terminal.list()
  if #terminals == 0 then
    return
  end

  table.sort(terminals, function(a, b)
    return a.buf < b.buf
  end)

  local current = vim.api.nvim_get_current_buf()
  local index
  for i, terminal in ipairs(terminals) do
    if terminal.buf == current then
      index = i
      break
    end
  end

  local target
  if index then
    target = terminals[((index - 1 + direction) % #terminals) + 1]
  else
    target = direction > 0 and terminals[1] or terminals[#terminals]
  end
  target:show():focus()
end

map({ "n", "t" }, "<A-l>", function()
  cycle_terminal(1)
end, { desc = "Focus Next Terminal" })
map({ "n", "t" }, "<A-h>", function()
  cycle_terminal(-1)
end, { desc = "Focus Previous Terminal" })

-- VS Code sends a literal ESC followed by Enter to the terminal.
map("t", "<S-CR>", "<Esc><CR>", { desc = "Send Escape and Enter" })
