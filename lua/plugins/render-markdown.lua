return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
    config = function(_, opts)
      local render_markdown = require("render-markdown")

      render_markdown.setup(opts)
      Snacks.toggle({
        name = "Render Markdown",
        get = render_markdown.get,
        set = render_markdown.set,
      }):map("<leader>um")
    end,
  },
}
