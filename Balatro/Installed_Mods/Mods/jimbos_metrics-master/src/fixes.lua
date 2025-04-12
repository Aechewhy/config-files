-- Fixes for stuff that appears to be broken in the main game

--- @diagnostic disable: duplicate-set-field
--- @diagnostic disable: inject-field
--- @diagnostic disable: undefined-field
--- @diagnostic disable: need-check-nil

local M = {}

function M.init()
  -- Moveables sometimes get their init() function called twice, during calculate_xywh
  -- This causes G.MOVEABLES to contain duplicate entries, which can really slow down the game after a while
  -- Text nodes seem to be particularly prone to this - no idea what causes it
  -- But we'll work around it by not causing init() to be called again if it's already been called, from
  -- UIElement.set_values
  local old_moveable_init = Moveable.init
  Moveable.init = function(self, x, y, w, h)
    old_moveable_init(self, x, y, w, h)
    self.__craftedcart_jimbos_metrics_already_initialized = true
  end

  local old_uielement_set_values = UIElement.set_values
  UIElement.set_values = function(self, t, recalculate)
    if self.__craftedcart_jimbos_metrics_already_initialized then
      -- Prevent old_uielement_set_values from trying to re-initialize if we've already been initialized
      recalculate = true
    end

    old_uielement_set_values(self, t, recalculate)
  end
end

return M
