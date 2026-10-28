-- MOVES Utilities site filter (runs after Quarto's filters, so {{< var >}} values are expanded).
-- 1. Tables: <th scope="col"> headers, first column as row headers, status words as labels,
--    word-weighted compatibility cells, and a keyboard-reachable scroll region.
-- 2. TODO(owner) markers: wrapped in a span so they stay visible but read as placeholders.

local stringify = pandoc.utils.stringify
local badges = {
  ["Open"] = "open", ["Current"] = "current", ["Fixed"] = "fixed",
  ["Limited use"] = "limited", ["Retired"] = "retired", ["Pre-release"] = "prerelease",
  ["Workaround available"] = "workaround",
}

local function add_class(cell, cls)
  cell.attr.classes:insert(cls)
end

local function process_table(tbl, label)
  local head_rows = tbl.head.rows
  local status_col, is_compat = nil, false
  if #head_rows > 0 then
    for i, cell in ipairs(head_rows[1].cells) do
      cell.attr.attributes["scope"] = "col"
      local t = stringify(cell.contents)
      if t == "Status" then status_col = i end
      if i == 1 and t == "MOVES Utilities" then is_compat = true end
    end
  end
  if is_compat then tbl.attr.classes:insert("mu-compat") end
  for _, body in ipairs(tbl.bodies) do
    body.row_head_columns = 1
    for _, row in ipairs(body.body) do
      for i, cell in ipairs(row.cells) do
        local t = stringify(cell.contents)
        if i == 1 then cell.attr.attributes["scope"] = "row" end
        if i == status_col and badges[t] then
          cell.contents = { pandoc.Plain({ pandoc.Span({ pandoc.Str(t) },
            pandoc.Attr("", { "mu-badge", "mu-badge--" .. badges[t] })) }) }
        end
        if is_compat and i > 1 then
          if t:match("^Not supported") then add_class(cell, "mu-unsupported")
          elseif t:match("^Supported") then add_class(cell, "mu-supported")
          elseif t:match("^Limited") then add_class(cell, "mu-limited") end
        end
      end
    end
  end
  local cap = stringify(tbl.caption.long or {})
  if cap == "" then cap = label or "Table" end
  return pandoc.Div({ tbl }, pandoc.Attr("", { "mu-table-wrap" },
    { role = "region", ["aria-label"] = cap, tabindex = "0" }))
end

local function todo_inlines(inlines)
  local out, changed = pandoc.List(), false
  for _, el in ipairs(inlines) do
    if el.t == "Str" and el.text:match("^TODO%(owner%)") then
      out:insert(pandoc.Span({ el }, pandoc.Attr("", { "mu-todo" })))
      changed = true
    else
      out:insert(el)
    end
  end
  if changed then return out end
end

local last_heading = nil

return {
  {
    traverse = "topdown",
    Header = function(h) last_heading = stringify(h.content) end,
    Table = function(tbl)
      if FORMAT:match("html") then return process_table(tbl, last_heading), false end
    end,
  },
  { Inlines = todo_inlines },
}
