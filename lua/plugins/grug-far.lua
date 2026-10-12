return {
  {
    "MagicDuck/grug-far.nvim",
    keys = {
      {
        "<leader>sr",
        function()
          local path = vim.api.nvim_buf_get_name(0)
          if path == "" then
            vim.notify("Current buffer is not a file", vim.log.levels.WARN)
            return
          end

          require("grug-far").open({
            transient = true,
            prefills = {
              paths = vim.fn.fnameescape(path),
            },
          })
        end,
        mode = { "n", "x" },
        desc = "Search and Replace in Current File",
      },
    },
  },
}
