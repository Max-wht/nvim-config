local keys = {
  {
    "<leader>ma",
    "<cmd>Grapple toggle<cr>",
    desc = "Toggle Grapple Tag",
  },
  {
    "<leader>ml",
    "<cmd>Grapple toggle_tags<cr>",
    desc = "List Grapple Tags",
  },
  {
    "<leader>mn",
    "<cmd>Grapple cycle_tags next<cr>",
    desc = "Next Grapple Tag",
  },
  {
    "<leader>mp",
    "<cmd>Grapple cycle_tags prev<cr>",
    desc = "Previous Grapple Tag",
  },
  {
    "<leader>ms",
    "<cmd>Grapple toggle_scopes<cr>",
    desc = "Select Grapple Scope",
  },
}

for index = 1, 9 do
  keys[#keys + 1] = {
    "<leader>m" .. index,
    "<cmd>Grapple select index=" .. index .. "<cr>",
    desc = "Grapple Tag " .. index,
  }
end

return {
  {
    "cbochs/grapple.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons", lazy = true },
    },
    event = { "BufReadPost", "BufNewFile" },
    cmd = "Grapple",
    keys = keys,
    opts = {
      -- Keep a separate, persistent tag list for each Git repository.
      scope = "git",
      icons = true,
      status = true,
      style = "relative",
      quick_select = "123456789",
    },
  },
}
