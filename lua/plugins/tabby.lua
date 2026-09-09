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
      vim.o.winbar = ""
      vim.opt.sessionoptions:append({ "globals", "tabpages" })

      -- Resolve theme groups each redraw, so ColorScheme changes do not leave stale colors.
      local function current_theme()
        local function hl(name)
          return vim.api.nvim_get_hl(0, { name = name, link = false })
        end
        return {
          fill = hl("TabLineFill"),
          head = hl("TabLine"),
          current_tab = hl("TabLineSel"),
          tab = hl("TabLine"),
          tail = hl("TabLine"),
        }
      end

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("TabbyThemeRefresh", { clear = true }),
        callback = function()
          vim.schedule(vim.cmd.redrawtabline)
        end,
      })

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

      local function add_tab_buffer(tabid, bufnr)
        if vim.bo[bufnr].buftype ~= "" then
          return
        end

        -- Keep the editing buffer selected when a sidebar takes focus.
        vim.api.nvim_tabpage_set_var(tabid, "tabby_current_buffer", bufnr)

        local ok, buffers = pcall(vim.api.nvim_tabpage_get_var, tabid, "tabby_buffers")
        buffers = ok and buffers or {}
        if not vim.tbl_contains(buffers, bufnr) then
          table.insert(buffers, bufnr)
          vim.api.nvim_tabpage_set_var(tabid, "tabby_buffers", buffers)
        end
      end

      for _, tabid in ipairs(vim.api.nvim_list_tabpages()) do
        for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(tabid)) do
          add_tab_buffer(tabid, vim.api.nvim_win_get_buf(winid))
        end
        add_tab_buffer(tabid, vim.api.nvim_win_get_buf(vim.api.nvim_tabpage_get_win(tabid)))
      end

      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("TabbyTabBuffers", { clear = true }),
        callback = function(args)
          add_tab_buffer(vim.api.nvim_get_current_tabpage(), args.buf)
          vim.cmd.redrawtabline()
        end,
      })

      require("tabby").setup({
        line = function(line)
          local theme = current_theme()
          local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
          local current_tab_bufs = {}
          local ok, buffers = pcall(vim.api.nvim_tabpage_get_var, vim.api.nvim_get_current_tabpage(), "tabby_buffers")
          for _, bufnr in ipairs(ok and buffers or {}) do
            current_tab_bufs[bufnr] = true
          end

          return {
            {
              { "  ", hl = theme.head },
              line.sep("", theme.head, theme.fill),
            },
            line
              .bufs()
              .filter(function(buf)
                return current_tab_bufs[buf.id] and buf:type() == ""
              end)
              .foreach(function(buf)
                local selected = buf.id == vim.t.tabby_current_buffer
                local hl = selected and theme.current_tab or theme.tab
                return {
                  line.sep("", hl, theme.fill),
                  buf.file_icon(),
                  buf.name(),
                  buf.is_changed() and " ●" or "",
                  line.sep("", hl, theme.fill),
                  hl = hl,
                  margin = " ",
                }
              end),
            line.spacer(),
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
