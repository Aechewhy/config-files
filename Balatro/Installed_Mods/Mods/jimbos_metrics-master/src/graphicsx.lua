local M = {}

function M.outlined_print(text, font, x, y, r, sx, sy, ox, oy, kx, ky)
  local front_color = {love.graphics.getColor()}
  local BACK_COLOR = G.C.BLACK
  local OFFSET = 0.05

  -- Outline/back
  love.graphics.setColor(adjust_alpha(BACK_COLOR, front_color[4]))
  love.graphics.print(text, font, x + OFFSET, y         , r, sx, sy, ox, oy, kx, ky)
  love.graphics.print(text, font, x + OFFSET, y + OFFSET, r, sx, sy, ox, oy, kx, ky)
  love.graphics.print(text, font, x         , y + OFFSET, r, sx, sy, ox, oy, kx, ky)
  love.graphics.print(text, font, x - OFFSET, y + OFFSET, r, sx, sy, ox, oy, kx, ky)
  love.graphics.print(text, font, x - OFFSET, y         , r, sx, sy, ox, oy, kx, ky)
  love.graphics.print(text, font, x - OFFSET, y - OFFSET, r, sx, sy, ox, oy, kx, ky)
  love.graphics.print(text, font, x         , y - OFFSET, r, sx, sy, ox, oy, kx, ky)
  love.graphics.print(text, font, x + OFFSET, y - OFFSET, r, sx, sy, ox, oy, kx, ky)

  -- Main text/front
  love.graphics.setColor(front_color)
  love.graphics.print(text, font, x, y, r, sx, sy, ox, oy, kx, ky)
end

return M
