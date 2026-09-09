return {
  {
    "nvim-mini/mini.hipatterns",
    event = "BufReadPost",
    opts = {
      highlighters = {
        note = {
          pattern = "//@note%f[%W].*",
          group = "DiagnosticInfo",
        },
        follow = {
          pattern = "//@follow%f[%W].*",
          group = "DiagnosticWarn",
        },
      },
    },
  },
}
