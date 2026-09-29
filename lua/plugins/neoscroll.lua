return {
  {
    "karb94/neoscroll.nvim",
    enabled = not vim.g.neovide,
    opts = {
      -- Keep the movement long enough to remain visible in terminal UIs.
      duration_multiplier = 1,
      easing = "quadratic",
    },
    config = function(_, opts)
      local neoscroll = require("neoscroll")
      neoscroll.setup(opts)

      local function scroll_with_mouse(lines)
        local winid = vim.fn.getmousepos().winid
        if winid == 0 or not vim.api.nvim_win_is_valid(winid) then
          winid = 0
        end

        neoscroll.scroll(lines, {
          duration = 200,
          easing = "sine",
          move_cursor = false,
          winid = winid,
        })
      end

      vim.keymap.set({ "n", "x", "i" }, "<ScrollWheelUp>", function()
        scroll_with_mouse(-5)
      end, { desc = "Smooth scroll up" })

      vim.keymap.set({ "n", "x", "i" }, "<ScrollWheelDown>", function()
        scroll_with_mouse(5)
      end, { desc = "Smooth scroll down" })
    end,
  },
}
