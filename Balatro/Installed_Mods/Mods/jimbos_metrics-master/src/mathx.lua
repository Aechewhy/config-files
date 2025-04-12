local M = {}

--- @class Rect
--- @field x number
--- @field y number
--- @field w number Width
--- @field h number Height
M.Rect = {}
local Rect_metatable = {__index = M.Rect}

function M.Rect.new(x, y, w, h)
  return setmetatable(
    {
      x = x,
      y = y,
      w = w,
      h = h,
    },
    Rect_metatable
  )
end

--- @return Rect
--- @nodiscard
function M.Rect:global_to_screen()
  local min_x, min_y = love.graphics.transformPoint(self.x, self.y)
  local max_x, max_y = love.graphics.transformPoint(self.x + self.w, self.y + self.h)

  return M.Rect.new(
    min_x,
    min_y,
    max_x - min_x,
    max_y - min_y
  )
end

--- @param x number
--- @param y number
---
--- @return boolean
--- @nodiscard
function M.Rect:contains_point(x, y)
  local max_x = self.x + self.w
  local max_y = self.y + self.h

  return x >= self.x and x <= max_x and y >= self.y and y <= max_y
end

--- @return number
--- @nodiscard
function M.Rect:max_x()
  return self.x + self.w
end

--- @return number
--- @nodiscard
function M.Rect:max_y()
  return self.y + self.h
end

function M.lerp(a, b, alpha)
  return ((b - a) * alpha) + a
end

function M.lerp_color(a, b, alpha)
  return {
    M.lerp(a[1], b[1], alpha),
    M.lerp(a[2], b[2], alpha),
    M.lerp(a[3], b[3], alpha),
    M.lerp(a[4], b[4], alpha),
  }
end

--- @param val number|Big
--- @param min number|Big
--- @param max number|Big
---
--- @return number|Big
--- @nodiscard
function M.clamp(val, min, max)
  return math.max(math.min(val, max), min)
end

--- Is the Talisman mod installed? (for big num support)
---
--- @return boolean
--- @nodiscard
local function has_talisman()
  -- Check for both of these functions
  -- Since some mods define `to_big` themselves, without defining `to_number`, if Talisman is not installed
  return to_big ~= nil and to_number ~= nil
end

--- Convert from a small num to a big num, if Talisman is installed
---
--- @param num number|Big
---
--- @return number|Big
--- @nodiscard
function M.big(num)
  if has_talisman() then
    return to_big(num)
  else
    return num
  end
end

--- Convert from a big num to a small num, if Talisman is installed
---
--- @param num number|Big
---
--- @return number
--- @nodiscard
function M.small(num)
  if has_talisman() then
    return to_number(num)
  else
    return num --- @diagnostic disable-line: return-type-mismatch
  end
end

function M.is_nan(num)
  -- NaNs are not equal to themselves
  return num ~= num
end

--- @param num number|Big
---
--- @return number
--- @nodiscard
function M.sign(num)
  if type(num) == "table" then
    -- Big num comparison
    local zero = M.big(0)
    if num > zero then
      return 1
    elseif num < zero then
      return -1
    else
      return 0
    end
  else
    -- float64 comparison
    if num > 0 then
      return 1
    elseif num < 0 then
      return -1
    else
      return 0
    end
  end
end

--- @diagnostic disable: undefined-field

--- @param num number|Big
---
--- @return number|Big
--- @nodiscard
function M.log(num)
  -- Talisman, for whatever reason, doesn't use Big:log in math.log
  -- So...we'll use it here
  if type(num) == "table" then
    if num.log ~= nil then
      return num:log()
    elseif num.ln ~= nil then
      return num:ln()
    end
  end

  return math.log(num)
end

--- @diagnostic enable: undefined-field

return M
