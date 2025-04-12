local M = {}

--- @class Signal
--- @field private _weak_callbacks { [any]: function }
--- @field private _strong_callbacks { [any]: function }
M.Signal = {}
local Signal_metatable = {__index = M.Signal}
local weak_keys = {__mode = "k"}

function M.Signal.new()
  return setmetatable(
    {
      _strong_callbacks = {},
      _weak_callbacks = setmetatable({}, weak_keys),
    },
    Signal_metatable
  )
end

--- @param func function
function M.Signal:bind(func)
  self._strong_callbacks[func] = func
end

--- @param func function
function M.Signal:bind_weak(func)
  self._weak_callbacks[func] = func
end

--- `func` will be invoked as long as `lifetime_obj` remains alive
---
--- @param func function
function M.Signal:bind_with_lifetime(lifetime_obj, func)
  self._weak_callbacks[lifetime_obj] = func
end

--- Invoke all callbacks with the given args
function M.Signal:emit(...)
  for _, v in pairs(self._strong_callbacks) do
    v(...)
  end
  for _, v in pairs(self._weak_callbacks) do
    v(...)
  end
end

return M
