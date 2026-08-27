return {
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },

  {
    "nanozuki/tabby.nvim",
    lazy = false,
    dependencies = { "nvim-mini/mini.icons" },
    keys = {
      { "<leader><tab>j", "<cmd>Tabby jump_to_tab<cr>", desc = "Jump to Tab" },
      { "<leader><tab>w", "<cmd>Tabby pick_window<cr>", desc = "Pick Tab Window" },
      { "<S-h>", "<cmd>bprevious<cr>", desc = "Previous Buffer" },
      { "<S-l>", "<cmd>bnext<cr>", desc = "Next Buffer" },
      { "[b", "<cmd>bprevious<cr>", desc = "Previous Buffer" },
      { "]b", "<cmd>bnext<cr>", desc = "Next Buffer" },
      {
        "<leader>tj",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Pick Buffer",
      },
    },
    config = function()
      vim.o.showtabline = 2
      vim.opt.sessionoptions:append({ "globals", "tabpages" })

      local palette = require("catppuccin.palettes").get_palette("mocha")
      local theme = {
        fill = { fg = palette.overlay0, bg = palette.base },
        head = { fg = palette.base, bg = palette.mauve, style = "bold" },
        current_tab = { fg = palette.base, bg = palette.peach, style = "bold" },
        tab = { fg = palette.lavender, bg = palette.surface0 },
        current_win = { fg = palette.blue, bg = palette.base, style = "bold" },
        win = { fg = palette.overlay0, bg = palette.base },
        tail = { fg = palette.base, bg = palette.teal, style = "bold" },
      }

      local function tab_name(tabid)
        local ok, win = pcall(vim.api.nvim_tabpage_get_win, tabid)
        if not ok then
          return "Workspace"
        end

        local buf = vim.api.nvim_win_get_buf(win)
        local name = vim.api.nvim_buf_get_name(buf)
        if name == "" then
          return "Workspace " .. vim.api.nvim_tabpage_get_number(tabid)
        end
        return vim.fn.fnamemodify(name, ":t")
      end

      require("tabby").setup({
        line = function(line)
          local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

          return {
            {
              { "  ", hl = theme.head },
              line.sep("", theme.head, theme.fill),
            },
            line.tabs().foreach(function(tab)
              local hl = tab.is_current() and theme.current_tab or theme.tab
              return {
                line.sep("", hl, theme.fill),
                tab.in_jump_mode() and tab.jump_key() or tab.number(),
                " ",
                tab.name(),
                tab.close_btn(" 󰅖"),
                line.sep("", hl, theme.fill),
                hl = hl,
                margin = " ",
              }
            end),
            line.spacer(),
            line
              .wins_in_tab(line.api.get_current_tab())
              .filter(function(win)
                return win.buf():type() == ""
              end)
              .foreach(function(win)
                local hl = win.is_current() and theme.current_win or theme.win
                return {
                  line.sep("", hl, theme.fill),
                  win.file_icon(),
                  " ",
                  win.buf_name(),
                  win.buf().is_changed() and " ●" or "",
                  line.sep("", hl, theme.fill),
                  hl = hl,
                  margin = " ",
                }
              end),
            {
              line.sep("", theme.tail, theme.fill),
              { " 󰉋 " .. cwd .. " ", hl = theme.tail },
            },
            hl = theme.fill,
          }
        end,
        option = {
          buf_name = {
            mode = "unique",
          },
          tab_name = {
            name_fallback = tab_name,
          },
        },
      })
    end,
  },
}
