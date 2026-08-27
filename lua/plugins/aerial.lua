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
    },
  },
}
