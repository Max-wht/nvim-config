return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      term_colors = true,
      auto_integrations = true,
      integrations = {
        aerial = true,
        mini = {
          enabled = true,
          indentscope_color = "",
        },
      },
    },
  },
}
