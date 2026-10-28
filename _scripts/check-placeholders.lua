-- Post-render guard: stops an unfinished page from being published.
--
-- Scans every HTML page written by this render (drafts are not rendered, so they are never checked).
-- * Template text (X.Y.Z, YYYY-MM-DD, {{PLACEHOLDER}}, template example sentences, unresolved
--   {{< var >}} keys) always fails the build.
-- * TODO(owner) markers fail the build only when MU_REQUIRE_FILLED=1 (set by the publish workflow
--   for builds that deploy). Local and pull-request builds list them as warnings.
-- * The release note named by latest.notes in _variables.yml must exist and not be a draft
--   (draft-mode: gone leaves "Release notes" links blank). Same strictness as TODO(owner).
-- * The review profile (drafts shown) only warns.

local always = {
  { "{{PLACEHOLDER}} token", "{{[A-Z][A-Z_]*}}" },
  { "unresolved variable", "%?var:" },
  { "X.Y.Z", "X%.Y%.Z" },
  { "YYYY-MM-DD", "YYYY%-MM%-DD" },
  { "template title", "Short factual title" },
  { "template sentence", "State the main change in one or two sentences" },
  { "template hash", "paste hash here" },
}
local todo = { "TODO(owner)", "TODO%(owner%)" }

local profile = os.getenv("QUARTO_PROFILE") or ""
local review = profile:find("review", 1, true) ~= nil
local strict_todo = os.getenv("MU_REQUIRE_FILLED") == "1" and not review

local files = {}
for f in (os.getenv("QUARTO_PROJECT_OUTPUT_FILES") or ""):gmatch("[^\r\n]+") do
  if f:match("%.html$") then files[#files + 1] = f end
end

local function count(text, pat)
  local n = 0
  for _ in text:gmatch(pat) do n = n + 1 end
  return n
end

local errors, warnings = {}, {}
for _, f in ipairs(files) do
  local h = io.open(f, "rb")
  if h then
    -- Check visible text and attribute values only: drop scripts so Quarto's own JS cannot match.
    local text = h:read("a"):gsub("<script.-</script>", "")
    h:close()
    for _, p in ipairs(always) do
      local n = count(text, p[2])
      if n > 0 then table.insert(errors, string.format("%s: %s (%d)", f, p[1], n)) end
    end
    local n = count(text, todo[2])
    if n > 0 then
      table.insert(strict_todo and errors or warnings, string.format("%s: %s (%d)", f, todo[1], n))
    end
  end
end

-- The release note that latest.notes points to must be rendered (exists, not draft: true).
local vh = io.open("_variables.yml", "rb")
local notes = vh and vh:read("a"):match("\n%s+notes:%s*\"([^\"]+)\"")
if vh then vh:close() end
if notes then
  local src = notes:gsub("%.html$", ".md")
  local sh = io.open(src, "rb")
  local front = sh and (sh:read("a"):match("^%-%-%-\r?\n(.-)\n%-%-%-") or "")
  if sh then sh:close() end
  local problem = not front and "is missing" or ("\n" .. front):match("\ndraft:%s*true") and "is still draft: true"
  if problem then
    table.insert(strict_todo and errors or warnings,
      string.format("_variables.yml latest.notes: %s %s, so release-note links would be blank", src, problem))
  end
end

for _, w in ipairs(warnings) do io.stderr:write("WARNING (unfilled, blocks deploy): " .. w .. "\n") end
if review then
  for _, e in ipairs(errors) do io.stderr:write("WARNING (review profile): " .. e .. "\n") end
elseif #errors > 0 then
  for _, e in ipairs(errors) do io.stderr:write("ERROR: " .. e .. "\n") end
  io.stderr:write("Placeholder check failed: fill in or remove the text above, keep the page as draft: true, or publish the release note named by latest.notes.\n")
  os.exit(1)
end
