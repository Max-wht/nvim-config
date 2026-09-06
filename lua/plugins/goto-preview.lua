local function preview_locations(source)
  Snacks.picker[source]({
    auto_confirm = false,
    include_current = true,
    focus = "list",
    layout = {
      preset = "ivy",
      layout = {
        box = "vertical",
        backdrop = false,
        row = -1,
        width = 0,
        height = 0.45,
        border = "top",
        title = " {title} {live} {flags}",
        title_pos = "left",
        {
          box = "horizontal",
          { win = "preview", title = "{preview}", width = 0.65, border = "right" },
          {
            box = "vertical",
            { win = "input", height = 1, border = "bottom" },
            { win = "list", border = "none" },
          },
        },
      },
    },
  })
end

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
              "gh",
              vim.lsp.buf.definition,
              desc = "Goto Definition",
            },
            {
              "gd",
              function()
                preview_locations("lsp_definitions")
              end,
              desc = "Preview Definitions",
            },
            {
              "gr",
              function()
                preview_locations("lsp_references")
              end,
              nowait = true,
              desc = "Preview References",
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
