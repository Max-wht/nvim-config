return {
  "sphamba/smear-cursor.nvim",
  enabled = not vim.g.neovide,
  opts = {
    -- Make ordinary j/k movement visibly glide between adjacent rows.
    smear_between_neighbor_lines = true,
    stiffness = 0.45,
    trailing_stiffness = 0.35,
    damping = 0.9,
    time_interval = 8,

    -- Use the plugin's default motion, with no fire particles.
    particles_enabled = false,
    -- Override LazyVim's block-drawing workaround for Ghostty.
    hide_target_hack = false,
  },
  config = function(_, opts)
    local smear = require("smear_cursor")
    local color = require("smear_cursor.color")
    local cursor_color, text_color

    local function paint_real_cursor()
      vim.api.nvim_set_hl(0, "SmearCursorHideable", {
        bg = cursor_color,
        fg = text_color,
        blend = 0,
      })
    end

    -- This plugin version clears the real cursor's colors when unhiding it.
    -- Preserve its hiding mechanism and restore the theme colors afterward.
    local unhide_real_cursor = color.unhide_real_cursor
    color.unhide_real_cursor = function()
      unhide_real_cursor()
      paint_real_cursor()
    end

    local function update_cursor_color()
      local dark = vim.o.background == "dark"
      cursor_color = dark and "#FFF4D6" or "#707070"
      text_color = dark and "#202020" or "#FFFFFF"
      smear.cursor_color = cursor_color
      smear.cursor_color_insert_mode = cursor_color
      local hidden = vim.api.nvim_get_hl(0, { name = "SmearCursorHideable", link = false }).blend == 100
      if not hidden then
        paint_real_cursor()
      end
    end

    smear.setup(opts)
    local group = vim.api.nvim_create_augroup("SmearCursorTheme", { clear = true })
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = group,
      callback = update_cursor_color,
    })
    vim.api.nvim_create_autocmd("OptionSet", {
      group = group,
      pattern = "background",
      callback = update_cursor_color,
    })
    update_cursor_color()
  end,
}
