local M = {}

local patched = false

local function regex_escape(text)
  return (text:gsub('([%(%)%.%%%+%-%*%?%[%]%^%$%{%}%|\\])', '\\%1'))
end

local function normalize_query(query)
  local trimmed = vim.trim(query or '')
  return (trimmed:gsub('%s+', ' '))
end

local function looks_like_regex(query)
  return query:find('[\\%^%$%(%)%.%[%]%*%+%?%|%{%}]') ~= nil
end

local function build_flexible_word_regex(query)
  local normalized = normalize_query(query)
  if normalized == '' or not normalized:find(' ') or looks_like_regex(normalized) then
    return nil
  end

  local parts = vim.split(normalized, ' ', { plain = true, trimempty = true })
  if #parts < 2 then
    return nil
  end

  for i, part in ipairs(parts) do
    if not part:match('^[%w_%-]+$') then
      return nil
    end
    parts[i] = regex_escape(part)
  end

  -- Allow punctuation-like separators between words so
  -- `vault token creation` matches `vault_token_creation`.
  return table.concat(parts, '[^[:alnum:]]+')
end

local function build_ordered_word_regex(query)
  local normalized = normalize_query(query)
  if normalized == '' or not normalized:find(' ') or looks_like_regex(normalized) then
    return nil
  end

  local parts = vim.split(normalized, ' ', { plain = true, trimempty = true })
  if #parts < 2 then
    return nil
  end

  for i, part in ipairs(parts) do
    if part == '' then
      return nil
    end
    parts[i] = regex_escape(part)
  end

  -- Allow any text between words so
  -- `vault token creation` also matches `vault foo token bar creation`.
  return table.concat(parts, '.*')
end

function M.patch_fff_grep()
  if patched then
    return
  end

  local grep = require('fff.grep')
  local original_search = grep.search

  grep.search = function(query, file_offset, page_size, config, grep_mode)
    local rewrite_mode = config and config.query_rewrite_mode or 'separator'
    local flexible_regex = nil

    if grep_mode == 'plain' then
      if rewrite_mode == 'ordered' then
        flexible_regex = build_ordered_word_regex(query)
      else
        flexible_regex = build_flexible_word_regex(query)
      end
    end

    if flexible_regex then
      return original_search(flexible_regex, file_offset, page_size, config, 'regex')
    end

    return original_search(query, file_offset, page_size, config, grep_mode)
  end

  patched = true
end

function M.live_grep(opts)
  M.patch_fff_grep()

  opts = opts or {}
  opts.grep = vim.tbl_deep_extend('force', {
    -- Start in literal/plain search, but still let you cycle modes.
    modes = { 'plain', 'regex', 'fuzzy' },
  }, opts.grep or {})

  return require('fff').live_grep(opts)
end

function M.live_grep_ordered(opts)
  M.patch_fff_grep()

  opts = opts or {}
  opts.grep = vim.tbl_deep_extend('force', {
    modes = { 'plain', 'regex', 'fuzzy' },
    query_rewrite_mode = 'ordered',
  }, opts.grep or {})

  return require('fff').live_grep(opts)
end

return M
