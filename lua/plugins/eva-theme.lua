return {
  {
    "sharpchen/Eva-Theme.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      override_highlight = function(variant)
        if not variant:match("dark") then
          return {}
        end

        local comment = { fg = "#8B93B5", italic = true }
        return {
          Comment = comment,
          ["@comment"] = comment,
          ["@comment.documentation"] = comment,
          ["@string.documentation"] = comment,
        }
      end,
    },
  },
}
