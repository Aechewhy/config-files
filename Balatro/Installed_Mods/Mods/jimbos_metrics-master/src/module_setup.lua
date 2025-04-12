-- This file defines two globals
-- - `jimbos_metrics_require()`, that works akin to `require()` in regular Lua
--   `jimbos_metrics_require` needs to take a filepath `like/this.lua`, it will not accept paths `like.this`
-- - `jimbos_metrics_reload_all()`, that just reloads all modules

--- @class ReloadableModule
--- @field __pre_reload function?
--- @field __on_reload function?

--- @type { [string]: ReloadableModule }
local loaded_modules = {}

local function require(path)
  local loaded_module = loaded_modules[path]
  if loaded_module == nil then
    loaded_module = setmetatable(
      {},
      {__index = assert(SMODS.load_file("src/" .. path, "jimbos_metrics"))()}
    )
    loaded_modules[path] = loaded_module
  end

  return loaded_module
end

local function reload_all()
  for _, v in pairs(loaded_modules) do
    if type(v) == "table" and v.__pre_reload ~= nil then
      v.__pre_reload()
    end
  end

  for k, v in pairs(loaded_modules) do
    sendInfoMessage("Reloading " .. k)
    setmetatable(v, {__index = assert(SMODS.load_file("src/" .. k, "jimbos_metrics"))()})
  end

  for _, v in pairs(loaded_modules) do
    if type(v) == "table" and v.__on_reload ~= nil then
      v.__on_reload()
    end
  end
end

-- Globals
jimbos_metrics_require = require
jimbos_metrics_reload_all = reload_all
