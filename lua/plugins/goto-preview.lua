return {
  {
    "rmagatti/goto-preview",
    event = "LspAttach",
    opts = {
      default_mappings = false,
      focus_on_open = true,
    },
    keys = {
      {
        "ge",
        function()
          require("goto-preview").close_all_win()
        end,
        desc = "Close Definition Previews",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            {
              "gd",
              function()
                require("goto-preview").goto_preview_definition()
              end,
              desc = "Preview Definition",
            },
            {
              "gm",
              function()
                require("goto-preview").goto_preview_implementation()
              end,
              desc = "Preview Implementation",
            },
          },
        },
      },
    },
  },
}
