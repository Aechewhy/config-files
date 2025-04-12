local profile = jimbos_metrics_require("profile.lua") --- @module "profile"

local M = {}

--- @class DebugPage
--- @field name string
--- @field draw function(self)
--- @field on_show function(self)
--- @field on_hide function(self)

local cursor_start_x = 0
local cursor_x = 0
local cursor_y = 0

local column_width = 0

local function next_column()
  cursor_y = 20
  cursor_start_x = cursor_start_x + column_width
  column_width = 0
  cursor_x = cursor_start_x
end

--- @param text string
--- @param color Rgba?
local function debug_print(text, color)
  color = color or {1, 1, 1, 1}

  local _, win_h = love.graphics.getDimensions()

  local _, num_lines = text:gsub("\n", "\n")
  num_lines = num_lines + 1

  local width = love.graphics.getFont():getWidth(text)
  local line_height = love.graphics.getFont():getHeight(text)
  local height = line_height * num_lines

  love.graphics.setColor(0, 0, 0, 0.5)
  love.graphics.rectangle("fill", cursor_x, cursor_y, width, height)

  love.graphics.setColor(color)
  love.graphics.print(text, cursor_x, cursor_y)
  cursor_x = cursor_x + width
  cursor_y = cursor_y + height - line_height

  column_width = math.max(column_width, cursor_x) --[[@as number]]

  if cursor_y > win_h - 20 then
    next_column()
  end
end

--- @param text string
--- @param color Rgba?
local function debug_println(text, color)
  color = color or {1, 1, 1, 1}

  local _, win_h = love.graphics.getDimensions()

  local _, num_lines = text:gsub("\n", "\n")
  num_lines = num_lines + 1

  local width = love.graphics.getFont():getWidth(text)
  local height = love.graphics.getFont():getHeight(text) * num_lines

  love.graphics.setColor(0, 0, 0, 0.5)
  love.graphics.rectangle("fill", cursor_x, cursor_y, width, height)

  love.graphics.setColor(color)
  love.graphics.print(text, cursor_x, cursor_y)
  cursor_y = cursor_y + height

  column_width = math.max(column_width, width) --[[@as number]]

  if cursor_y > win_h - 20 then
    next_column()
  end

  cursor_x = cursor_start_x
end

local function debug_println_mono(text)
  local _, win_h = love.graphics.getDimensions()

  for c in text:gmatch(".") do
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", cursor_x, cursor_y, 10, 12)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(c, cursor_x, cursor_y)

    if c == "\n" then
      cursor_y = cursor_y + 12

      if cursor_y > win_h - 20 then
        next_column()
      end

      cursor_x = cursor_start_x
    else
      cursor_x = cursor_x + 10
      column_width = math.max(column_width, cursor_x) --[[@as number]]
    end
  end

  cursor_x = cursor_start_x
  cursor_y = cursor_y + 12
end

local function moveable_to_string(moveable)
  if moveable:is(DynaText) then
    return "DynaText"
  elseif moveable:is(UIBox) then
    return "UIBox"
  elseif moveable:is(UIElement) then
    if moveable.UIT == G.UIT.T then
      return string.format("UIElement[Text = %s]", moveable.config.text or "REF")
    else
      return string.format("UIElement[UIT = %d]", moveable.UIT)
    end
  elseif moveable:is(AnimatedSprite) then
    return "AnimatedSprite"
  elseif moveable:is(Sprite) then
    return string.format("Sprite[Atlas = %s]", moveable.atlas.name)
  elseif moveable:is(Card) then
    return string.format("Card[Center = %s, Card = %s, Rank = %s]", moveable.config.center_key, moveable.config.card_key, moveable.rank)
  elseif moveable:is(CardArea) then
    return string.format("CardArea[Type = %s]", moveable.config.type)
  elseif moveable:is(Blind) then
    return "Blind"
  elseif moveable:is(Particles) then
    return "Particles"
  elseif moveable:is(Card_Character) then
    return "Particles"
  elseif getmetatable(moveable) == Moveable then
    return "Moveable"
  else
    return "UnknownMoveable"
  end
end

--- nop: No-operation
local function nop() end

local function print_ui_summary()
  debug_println("#G.MOVEABLES: " .. tostring(#G.MOVEABLES))
  debug_println("#G.I.NODE: " .. tostring(#G.I.NODE))
  debug_println("#G.I.MOVEABLE: " .. tostring(#G.I.MOVEABLE))
  debug_println("#G.I.SPRITE: " .. tostring(#G.I.SPRITE))
  debug_println("#G.I.UIBOX: " .. tostring(#G.I.UIBOX))
  debug_println("#G.I.POPUP: " .. tostring(#G.I.POPUP))
  debug_println("#G.I.CARD: " .. tostring(#G.I.CARD))
  debug_println("#G.I.CARDAREA: " .. tostring(#G.I.CARDAREA))
  debug_println("#G.I.ALERT: " .. tostring(#G.I.ALERT))
end

--- @type DebugPage[]
local pages = {
  {
    name = "UI summary",
    draw = function(_)
      print_ui_summary()
    end,
    on_show = nop,
    on_hide = nop,
  },
  {
    name = "All moveables",
    draw = function(_)
      print_ui_summary()

      debug_println("======== All moveables ========")

      -- Print all moveables
      -- Duplicate moveables show up in orange
      local seen_moveables = {}
      for _, moveable in ipairs(G.MOVEABLES) do
        if seen_moveables[moveable] ~= nil then
          -- Duplicate! Oh no
          debug_println(moveable_to_string(moveable), {1, 0.5, 0.5, 1})
        else
          -- Not a duplicate
          debug_println(moveable_to_string(moveable))
          seen_moveables[moveable] = true
        end
      end
    end,
    on_show = nop,
    on_hide = nop,
  },
  {
    name = "Last UIElement in G.MOVEABLES",
    draw = function(_)
      print_ui_summary()

      debug_println("======== Last UIElement in G.MOVEABLES ========")

      if G.MOVEABLES[1] ~= nil then
        local last_moveable = G.MOVEABLES[#G.MOVEABLES]
        while last_moveable ~= nil and last_moveable:is(UIElement) do
          debug_println(last_moveable:print_topology(0))

          if last_moveable.parent ~= nil then
            debug_println("-------- Parent --------")
            last_moveable = last_moveable.parent
          end
        end
      end
    end,
    on_show = nop,
    on_hide = nop,
  },
  {
    name = "G.OVERLAY_MENU",
    draw = function(_)
      print_ui_summary()

      debug_println("======== G.OVERLAY_MENU ========")

      if G.OVERLAY_MENU ~= nil then
        local topology = G.OVERLAY_MENU:print_topology(0)
        for line in topology:gmatch("([^\n]*)\n?") do
          debug_println(line)
        end
      end
    end,
    on_show = nop,
    on_hide = nop,
  },
  {
    name = "Events",
    draw = function(_)
      for queue, events in pairs(G.E_MANAGER.queues) do
        debug_println(string.format("%s: %d events", queue, #events))
      end
    end,
    on_show = nop,
    on_hide = nop,
  },
  {
    name = "Profiler",
    draw = function(self)
      self._frames_since_last_report = self._frames_since_last_report + 1
      if self._frames_since_last_report == 100 then
        self._frames_since_last_report = 0
        self._profile_report = profile.report(60)
        profile.reset()
      end

      debug_println_mono(self._profile_report)
    end,
    on_show = function()
      profile.start()
    end,
    on_hide = function()
      profile.stop()
    end,

    _profile_report = "Waiting for profiler...",
    _frames_since_last_report = 0,
  },
}

--- @type number?
local page_index = nil

function M.next_page()
  if page_index == nil then
    page_index = 1
    pages[1]:on_show()
  else
    pages[page_index]:on_hide()
    page_index = page_index + 1
    if page_index > #pages then
      page_index = nil
    else
      pages[page_index]:on_show()
    end
  end
end

local function draw()
  if page_index == nil then
    return
  end
  local page = pages[page_index]

  cursor_x = 0
  cursor_start_x = 0
  cursor_y = 0

  love.graphics.reset()

  debug_print("debugx page: ", {0, 1, 0, 1})
  for k, v in ipairs(pages) do
    debug_print(v.name, k == page_index and {0, 1, 0, 1} or {0.75, 0.75, 0.75, 1})
    debug_print(" | ")
  end

  local love_major, love_minor, love_revision, love_codename = love.getVersion()
  debug_println(
    string.format(
      "Love %d.%d.%d (%s) | %s | Mem: %.2f Kbytes",
      love_major,
      love_minor,
      love_revision,
      love_codename,
      jit.version,
      collectgarbage("count")
    ),
    {0, 1, 0, 1}
  )
  debug_println("")

  -- Ignore the first line of text for tracking where the next column should start
  column_width = 0

  page:draw()
end

local enable_hook = true

function M.init()
  G.FUNCS.craftedcart_jimbos_metrics_debugx_next_page = function()
    M.next_page()
  end

  local old_draw = love.draw
  love.draw = function() --- @diagnostic disable-line: duplicate-set-field
    old_draw()
    if enable_hook then
      draw()
    end
  end
end

function M.__pre_reload()
  enable_hook = false
  profile.stop()
end

function M.__on_reload()
  M.init()
end

return M
