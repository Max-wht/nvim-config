local function set_annotation_highlights()
  vim.api.nvim_set_hl(0, "AnnotationNote", { fg = "#ffffff", bold = true })
  vim.api.nvim_set_hl(0, "AnnotationAudit", { fg = "#ff0000", bold = true })
end

return {
  {
    "nvim-mini/mini.hipatterns",
    event = "BufReadPost",
    init = function()
      set_annotation_highlights()
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("annotation_highlights", { clear = true }),
        callback = set_annotation_highlights,
      })
    end,
    opts = {
      highlighters = {
        note = {
          pattern = "//@note%f[%W].*",
          group = "AnnotationNote",
        },
        follow = {
          pattern = "//@follow%f[%W].*",
          group = "DiagnosticWarn",
        },
        audit = {
          pattern = "//@audit%f[%W].*",
          group = "AnnotationAudit",
        },
      },
    },
  },
}
