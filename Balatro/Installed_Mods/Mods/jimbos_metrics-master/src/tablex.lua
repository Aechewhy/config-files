local M = {}

--- Empty a table
---
--- @param t table
function M.clear(t)
  for k, _ in pairs(t) do
    t[k] = nil
  end
end

--- Replace the contents of `dest` with `src`
---
--- @param dest table
--- @param src table
function M.replace(dest, src)
  M.clear(dest)
  for k, v in pairs(src) do
    dest[k] = v
  end
end

--- Append a list to another list
---
--- @param dest any[]
--- @param src any[]
function M.append(dest, src)
  for _, v in ipairs(src) do
    table.insert(dest, v)
  end
end

--- Calls `func` over each element in the table, to yield an iterator (akin to `ipairs`)
---
--- @param src table
--- @param func function
---
--- @return function
--- @nodiscard
function M.imap(src, func)
  local i = 0
  return function()
    i = i + 1

    local v = src[i]
    if v == nil then
      return nil
    else
      return i, func(v)
    end
  end
end

--- Iterate `iter` and collect results in a table
---
--- Expects `iter` to return key/value pairs
---
--- @param iter function
---
--- @return table
function M.collect(iter)
  local out = {}
  for k, v in iter do
    out[k] = v
  end

  return out
end

--- @param t table
---
--- @return table
--- @nodiscard
function M.shallow_clone(t)
  local out = {}
  for k, v in pairs(t) do
    out[k] = v
  end

  return out
end

--- Check if table `t` contains value `v`
---
--- @param t table
--- @param v any
---
--- @return boolean
--- @nodiscard
function M.contains_value(t, v)
  for _, table_v in pairs(t) do
    if v == table_v then
      return true
    end
  end

  -- Not found
  return false
end

-- Thank you https://stackoverflow.com/a/42062321
function M.to_string(node)
  -- to make output beautiful
  local function tab(amt)
    local str = ""
    for _ = 1, amt do
      str = str .. "  "
    end
    return str
  end

  local cache, stack, output = {},{},{}
  local depth = 1
  local output_str = "{\n"

  while true do
    local size = 0
    for _, _ in pairs(node) do
      size = size + 1
    end

    local cur_index = 1
    for k,v in pairs(node) do
      if (cache[node] == nil) or (cur_index >= cache[node]) then

        if (string.find(output_str,"}",output_str:len())) then
          output_str = output_str .. ",\n"
        elseif not (string.find(output_str,"\n",output_str:len())) then
          output_str = output_str .. "\n"
        end

        -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
        table.insert(output,output_str)
        output_str = ""

        local key
        local is_hidden = false
        if (type(k) == "number" or type(k) == "boolean") then
          key = "["..tostring(k).."]"
        else
          key = "['"..tostring(k).."']"
          -- if k:sub(1, 1) == "_" then
          --   -- is_hidden = true
          -- end
        end

        if is_hidden then
          output_str = output_str .. tab(depth) .. key .. " = ".."... (hidden)"
        elseif (type(v) == "number" or type(v) == "boolean") then
          output_str = output_str .. tab(depth) .. key .. " = "..tostring(v)
        elseif (type(v) == "table") then
          output_str = output_str .. tab(depth) .. key .. " = {\n"
          table.insert(stack,node)
          table.insert(stack,v)
          cache[node] = cur_index+1
          break
        else
          output_str = output_str .. tab(depth) .. key .. " = '"..tostring(v).."'"
        end

        if (cur_index == size) then
          output_str = output_str .. "\n" .. tab(depth-1) .. "}"
        else
          output_str = output_str .. ","
        end
      else
        -- close the table
        if (cur_index == size) then
          output_str = output_str .. "\n" .. tab(depth-1) .. "}"
        end
      end

      cur_index = cur_index + 1
    end

    if (size == 0) then
      output_str = output_str .. "\n" .. tab(depth-1) .. "}"
    end

    if (#stack > 0) then
      node = stack[#stack]
      stack[#stack] = nil
      depth = cache[node] == nil and depth + 1 or depth - 1
    else
      break
    end
  end

  -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
  table.insert(output,output_str)
  output_str = table.concat(output)

  return output_str
end

return M
