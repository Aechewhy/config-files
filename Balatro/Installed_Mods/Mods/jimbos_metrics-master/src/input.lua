local M = {}

M.wheel_delta_x = 0
M.wheel_delta_y = 0

--- Set to true for one frame when the user left-clicks
M.lmb_clicked = false

--- @param x number
--- @param y number
local function wheel_moved(x, y)
  M.wheel_delta_x = M.wheel_delta_x + x
  M.wheel_delta_y = M.wheel_delta_y + y
end

local function mouse_pressed(_, _, button, _, _)
  if button == 1 then
    M.lmb_clicked = true
  end
end

function M.init()
  local orig_wheelmoved = love.wheelmoved
  if orig_wheelmoved ~= nil then
    love.wheelmoved = function(x, y)
      orig_wheelmoved(x, y)
      wheel_moved(x, y)
    end
  else
    love.wheelmoved = wheel_moved
  end

  local orig_mousepressed = love.mousepressed
  love.mousepressed = function(x, y, button, is_touch, presses) --- @diagnostic disable-line: duplicate-set-field
    orig_mousepressed(x, y, button, is_touch, presses)
    mouse_pressed(x, y, button, is_touch, presses)
  end

  local orig_draw = love.draw
  love.draw = function() --- @diagnostic disable-line: duplicate-set-field
    orig_draw()

    M.wheel_delta_x = 0
    M.wheel_delta_y = 0

    M.lmb_clicked = false
  end
end

function M.__on_reload()
  M.init()
end

return M
