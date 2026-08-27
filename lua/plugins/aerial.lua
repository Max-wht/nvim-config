return {
  {
    "stevearc/aerial.nvim",
    cmd = {
      "AerialClose",
      "AerialCloseAll",
      "AerialInfo",
      "AerialNavClose",
      "AerialNavOpen",
      "AerialNavToggle",
      "AerialOpen",
      "AerialOpenAll",
      "AerialToggle",
    },
    keys = {
      {
        "<leader>o",
        "<cmd>AerialToggle! left<cr>",
        desc = "Toggle Symbol Outline",
      },
    },
    opts = {
      attach_mode = "global",
      layout = {
        default_direction = "left",
        placement = "edge",
        width = 30,
      },
      show_guides = true,
      -- Match the spacing used by the file Explorer so both sidebars have a
      -- consistent, VS Code-like visual density.
      guides = {
        mid_item = "├─ ",
        last_item = "└─ ",
        nested_top = "│  ",
        whitespace = "   ",
      },
    },
  },
}
