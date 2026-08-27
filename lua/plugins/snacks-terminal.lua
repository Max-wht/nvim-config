return {
  {
    "folke/snacks.nvim",
    opts = {
      terminal = {
        win = {
          position = "bottom",
          -- Split only the active editor window, so the left explorer keeps
          -- its full height instead of being compressed by the terminal.
          relative = "win",
          height = 0.95, -- 占编辑区域的 85%
          border = "top",
        },
      },
    },
  },
}
