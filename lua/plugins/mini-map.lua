return {
  {
    "nvim-mini/mini.map",
    version = false,
    config = function()
      local map = require("mini.map")

      map.setup({
        integrations = {
          map.gen_integration.builtin_search(),
          map.gen_integration.diagnostic({
            error = "DiagnosticFloatingError",
            warn = "DiagnosticFloatingWarn",
            info = "DiagnosticFloatingInfo",
            hint = "DiagnosticFloatingHint",
          }),
          map.gen_integration.gitsigns(),
        },
        window = {
          side = "right",
          width = 10,
          winblend = 0,
          show_integration_count = false,
        },
      })

      vim.keymap.set("n", "<leader>mm", map.toggle, {
        desc = "Toggle Minimap",
      })

      vim.keymap.set("n", "<leader>mf", map.toggle_focus, {
        desc = "Focus Minimap",
      })
    end,
  },
}
