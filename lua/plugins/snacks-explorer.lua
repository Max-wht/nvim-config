return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            -- Keep hierarchy nesting compact while preserving a stable
            -- icon/name gap.
            icons = {
              tree = {
                vertical = " ",
                middle = " ",
                last = " ",
              },
            },
            formatters = {
              file = {
                filename_only = true,
                icon_width = 3,
              },
            },
            layout = {
              preset = "sidebar",
              layout = {
                position = "right",
              },
            },
            win = {
              list = {
                wo = {
                  cursorline = true,
                  number = false,
                  relativenumber = false,
                  signcolumn = "no",
                  wrap = false,
                },
              },
            },
          },
        },
      },
    },
  },
}
