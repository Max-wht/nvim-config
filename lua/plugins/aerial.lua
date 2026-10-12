local annotation_kinds = {
  Audit = true,
  Follow = true,
  Note = true,
}

local annotations = {
  { tag = "follow", kind = "Follow" },
  { tag = "note", kind = "Note" },
  { tag = "audit", kind = "Audit" },
}

local function deepest_symbol_at(items, lnum)
  for _, item in ipairs(items) do
    if not annotation_kinds[item.kind] and item.lnum <= lnum and lnum <= item.end_lnum then
      return deepest_symbol_at(item.children or {}, lnum) or item
    end
  end
end

local function add_annotation_symbols(bufnr, items)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return items
  end

  for lnum, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
    for _, annotation in ipairs(annotations) do
      local start_col, end_col = line:find("//@" .. annotation.tag .. "%f[%W]")
      if start_col then
        local description = vim.trim(line:sub(end_col + 1))
        local parent = deepest_symbol_at(items, lnum)
        local target = items
        if parent then
          parent.children = parent.children or {}
          target = parent.children
        end
        local col = start_col - 1
        local symbol = {
          kind = annotation.kind,
          name = description ~= "" and description or "@" .. annotation.tag,
          level = parent and parent.level + 1 or 0,
          parent = parent,
          lnum = lnum,
          col = col,
          end_lnum = lnum,
          end_col = #line,
          selection_range = {
            lnum = lnum,
            col = col,
            end_lnum = lnum,
            end_col = #line,
          },
        }

        table.insert(target, symbol)
        table.sort(target, function(a, b)
          return a.lnum == b.lnum and a.col < b.col or a.lnum < b.lnum
        end)
      end
    end
  end

  return items
end

return {
  {
    "stevearc/aerial.nvim",
    cmd = {
      "AerialClose",
      "AerialCloseAll",
      "AerialInfo",
      "AerialNavClose",
      "AerialNavOpen",
      "AerialNavToggle",
      "AerialOpen",
      "AerialOpenAll",
      "AerialToggle",
    },
    keys = {
      {
        "<leader>o",
        "<cmd>AerialToggle! left<cr>",
        desc = "Toggle Symbol Outline",
      },
    },
    opts = {
      attach_mode = "global",
      icons = {
        Audit = "󰒃",
        Follow = "󰁔",
        Note = "󰍨",
      },
      get_highlight = function(symbol)
        if symbol.kind == "Follow" then
          return "DiagnosticWarn"
        elseif symbol.kind == "Note" then
          return "AnnotationNote"
        elseif symbol.kind == "Audit" then
          return "AnnotationAudit"
        end
      end,
      post_add_all_symbols = add_annotation_symbols,
      layout = {
        default_direction = "left",
        placement = "edge",
        width = 30,
        win_opts = {
          statuscolumn = "",
        },
      },
      show_guides = true,
      -- Match the spacing used by the file Explorer so both sidebars have a
      -- consistent, VS Code-like visual density.
      guides = {
        mid_item = "├─ ",
        last_item = "└─ ",
        nested_top = "│  ",
        whitespace = "   ",
      },
    },
  },
}
