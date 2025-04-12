local ui_common = jimbos_metrics_require("ui/common.lua") --- @module "ui.metrics"
local ui_metrics = jimbos_metrics_require("ui/metrics.lua") --- @module "ui.metrics"
local ui_win_play = jimbos_metrics_require("ui/win_play.lua") --- @module "ui.win_play"
local stats = jimbos_metrics_require("stats.lua") --- @module "stats"
local input = jimbos_metrics_require("input.lua") --- @module "input"
local signal = jimbos_metrics_require("signal.lua") --- @module "signal"
local mathx = jimbos_metrics_require("mathx.lua") --- @module "mathx"
local graphicsx = jimbos_metrics_require("graphicsx.lua") --- @module "graphicsx"
local tablex = jimbos_metrics_require("tablex.lua") --- @module "tablex"

local Rect = mathx.Rect

local M = {}

local BAR_WIDTH = 0.5
local COMPACT_BAR_WIDTH = 0.1
local BAR_GAP = 0.1
local COMPACT_BAR_GAP = 0.05
local SCROLLBAR_THICKNESS = 0.25
local SCROLLBAR_PADDING = 0.1
local MIN_SCROLLBAR_THUMB_LENGTH = 0.5
local GROUP_HEIGHT = 0.6
local GROUP_PADDING = 0.1

local DEG90_AS_RAD = 1.5708
local BIG0 = mathx.big(0)
local BIG1 = mathx.big(1)
local BIG_NEG1 = mathx.big(-11)

--- @alias EGroupBy "Hands" | "Rounds"

--- @class GraphBar
--- @field value number|Big
--- @field value_percent_linear number `value` as a percentage of `max_value` - because big-nums chomp performance so we
---                                    cache it here
--- @field value_percent_log number
--- @field draw_on_bar function(rect: Rect, compact_ease: number)
--- @field get_sidebar_uielems function(): table
--- @field on_click function()

--- @class GraphLine
--- @field values number[]|Big[]
--- @field values_percent_linear number[]
--- @field values_percent_log number[]
--- @field color Rgba
--- @field max_value number|Big

--- @class GraphBars
--- @field bars GraphBar[]
--- @field lines GraphLine[]
--- @field max_value number|Big
--- @field groups GraphGroup[]

--- @class GraphGroup
--- @field items GraphGroupItem[]

--- @class GraphGroupItem
--- @field from number Bar index the group starts at (inclusive)
--- @field to number Bar index the group ends at (inclusive)
--- @field labels string[] Labels in decreasing length

--- @class Graph: Moveable
---
--- @field scroll_offset number Eases towards target_scroll_offset
--- @field target_scroll_offset number
---
--- @field data GraphBars
---
--- @field logarithmic boolean
--- @field private _logarithmic_ease number Eases between 0 and 1 depending on `logarithmic`
---
--- @field compact boolean
--- @field private _compact_ease number Eases between 0 and 1 depending on `compact`
---
--- @field hovered_bar_changed Signal Emits with the new bar index, or nil if no bar is hovered
--- @field private _hovered_bar_index number?
M.Graph = Moveable:extend()

local disable_hover_state_metatable = {
  __index = function(_, k)
    if k == "is" then
      return false
    else
      return nil
    end
  end,
  __newindex = function(t, k, v)
    if k ~= "is" then
      rawset(t, k, v)
    end
  end,
}

--- Disable hover behaviour for a node
---
--- @param node Node
local function disable_hover(node)
  node.hover = function() end --- @diagnostic disable-line: duplicate-set-field
  node.stop_hover = function() end --- @diagnostic disable-line: duplicate-set-field

  -- Fake our hover state to always be false
  local hover_state = node.states.hover
  hover_state.is = nil
  node.states.hover = setmetatable(hover_state, disable_hover_state_metatable)
end

--- Almost like math.log, but faking it a bit so we can support negative numbers
---
--- For values
---
--- @param num number|Big
---
--- @return number|Big
--- @nodiscard
local function logish(num)
  num = mathx.big(num)
  if num > BIG_NEG1 and num < BIG1 then
    -- Values between -1 and 1 are displayed linearly
    return num
  elseif num < BIG0 then
    -- Negative numbers are inverted
    -- And offset by 1 to account for our -1 to 1 linear space
    return -mathx.log(-num) - 1
  else
    -- Offset by 1 to account for our -1 to 1 linear space
    return mathx.log(num) + 1
  end
end

  --- @return GraphBars
--- @nodiscard
local function gather_bars_grouped_by_hands()
  -- Figure out how much space the longest bits of chips/mult/etc. text take up
  -- So we can draw all that text nice and aligned
  local max_chips_len = 0
  local max_mult_len = 0
  local max_total_chips_len = 0
  for _, round in ipairs(stats.StatsRoot.get_current().rounds) do
    for _, play in ipairs(round.plays) do
      max_chips_len = math.max(max_chips_len, G.LANG.font.FONT:getWidth(number_format(play.chips)))
      max_mult_len = math.max(max_mult_len, G.LANG.font.FONT:getWidth(number_format(play.mult)))
      max_total_chips_len = math.max(max_total_chips_len, G.LANG.font.FONT:getWidth(number_format(play:get_total_chips())))
    end
  end

  --- @type GraphBar[]
  local bars = {}

  --- @type GraphLine
  local blind_chips = {
    values = {},
    values_percent_linear = {},
    values_percent_log = {},
    color = G.C.RED,
    max_value = 0,
  }

  --- @type GraphLine
  local dollars = {
    values = {},
    values_percent_linear = {},
    values_percent_log = {},
    color = G.C.GOLD,
    max_value = 0,
  }

  --- @type GraphGroup
  local round_group = {items = {}}

  --- @type GraphGroup
  local ante_group = {items = {}}

  local current_ante = nil
  local current_ante_start = nil

  local max_value = mathx.big(0)

  for round_i, round in ipairs(stats.StatsRoot.get_current().rounds) do
    local current_round_start = #bars + 1

    for _, play in ipairs(round.plays) do
      local total_chips = play:get_total_chips()
      table.insert(
        bars,
        {
          value = total_chips,
          value_percent_linear = nil, -- Filled in later
          value_percent_log = nil, -- Filled in later
          draw_on_bar = function(rect, compact_ease)
            local function print_offset(text, y_offset)
              graphicsx.outlined_print(
                text,
                G.LANG.font.FONT,
                rect.x + 0.04,
                rect.y + rect.h - 0.1 + (y_offset * 0.002),
                -DEG90_AS_RAD,
                0.002,
                0.002
                )
            end

            local y_offset = -max_chips_len
            local chips_text = number_format(play.chips)
            love.graphics.setColor(adjust_alpha(G.C.CHIPS, 1 - compact_ease))
            print_offset(chips_text, y_offset + G.LANG.font.FONT:getWidth(chips_text))

            love.graphics.setColor(1, 1, 1, 1 - compact_ease)
            print_offset(" X ", y_offset)

            y_offset = y_offset - G.LANG.font.FONT:getWidth(" X ") - max_mult_len
            local mult_text = number_format(play.mult)
            love.graphics.setColor(adjust_alpha(G.C.MULT, 1 - compact_ease))
            print_offset(mult_text, y_offset + G.LANG.font.FONT:getWidth(mult_text))

            love.graphics.setColor(1, 1, 1, 1 - compact_ease)
            print_offset(" = ", y_offset)

            y_offset = y_offset - G.LANG.font.FONT:getWidth(" = ") - max_total_chips_len
            local total_chips_text = number_format(total_chips)
            print_offset(total_chips_text, y_offset + G.LANG.font.FONT:getWidth(total_chips_text))
          end,
          get_sidebar_uielems = function()
            -- Make play card area
            local play_card_area = CardArea(0, 0, ui_metrics.SIDEBAR_WIDTH, G.CARD_H / 2, {card_limit = #play.play_cards, card_w = G.CARD_W / 2, type = "play"})
            for _, v in tablex.imap(play.play_cards, stats.JmCard.to_card) do
              v.T.scale = 0.5
              v:remove_UI()
              disable_hover(v)
              play_card_area:emplace(v, nil, true)
            end

            -- Make joker card area
            local joker_card_area = CardArea(0, 0, ui_metrics.SIDEBAR_WIDTH, G.CARD_H / 2, {card_limit = #play.joker_cards, card_w = G.CARD_W / 2, type = "play"})
            for _, v in tablex.imap(play.joker_cards, stats.JmCard.to_card) do
              v.T.scale = 0.5
              v:remove_UI()
              disable_hover(v)
              joker_card_area:emplace(v, nil, true)
            end

            return {
              ui_common.make_round_heading(round_i, round),
              ui_common.SIDEBAR_SPACER,
              ui_common.make_kv_text("Money: ", G.C.UI.TEXT_LIGHT, "$" .. number_format(play.dollars), G.C.GOLD),
              ui_common.SIDEBAR_SPACER,
              ui_common.make_kv_text("Poker hand: ", G.C.UI.TEXT_LIGHT, localize(play.display_poker_hand, "poker_hands") --[[@as string]], G.C.RED),
              ui_common.make_text_line(localize("k_lvl") .. tostring(play.poker_hand_level), G.C.HAND_LEVELS[math.min(play.poker_hand_level, #G.C.HAND_LEVELS)], 0.75),
              {
                n = G.UIT.R,
                nodes = {
                  {n = G.UIT.T, config = {text = number_format(play.chips), colour = G.C.CHIPS, scale = 0.5 * 0.75, shadow = true}},
                  {n = G.UIT.T, config = {text = " X ", colour = G.C.JOKER_GREY, scale = 0.5 * 0.75, shadow = true}},
                  {n = G.UIT.T, config = {text = number_format(play.mult), colour = G.C.MULT, scale = 0.5 * 0.75, shadow = true}},
                  {n = G.UIT.T, config = {text = " = ", colour = G.C.JOKER_GREY, scale = 0.5 * 0.75, shadow = true}},
                  {n = G.UIT.T, config = {text = number_format(total_chips), colour = G.C.UI.TEXT_LIGHT, scale = 0.5 * 0.75, shadow = true}},
                },
              },
              ui_common.make_kv_text(ui_common.format_multiplier(total_chips / round.blind.chips) .. "x", G.C.RED, " the required chips", G.C.JOKER_GREY, 0.75),
              {
                n = G.UIT.R,
                nodes = {
                  {n = G.UIT.O, config = {object = play_card_area}},
                },
              },
              ui_common.SIDEBAR_SPACER,
              {
                n = G.UIT.R,
                nodes = {
                  {n = G.UIT.T, config = {text = "Jokers", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}},
                },
              },
              {
                n = G.UIT.R,
                nodes = {
                  {n = G.UIT.O, config = {object = joker_card_area}},
                },
              },
              ui_common.SIDEBAR_SPACER,
              ui_common.uielem_blind(round.blind, ui_metrics.SIDEBAR_WIDTH),
              ui_common.SIDEBAR_SPACER,
              {
                n = G.UIT.R,
                config = {align = "bm"},
                nodes = {
                  {
                    n = G.UIT.C,
                    config = {
                      colour = G.C.RED,
                      r = 0.1,
                    },
                    nodes = {
                      {n = G.UIT.B, config = {w = 0.175, h = 0}},
                      {n = G.UIT.T, config = {text = "Click for more info", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}},
                      {n = G.UIT.B, config = {w = 0.2, h = 0}},
                    },
                  },
                },
              },
            }
          end,
          on_click = function()
            play_sound("button", 1, 0.3)
            ui_win_play.show(round_i, round, play)
          end,
        }
      )
      table.insert(blind_chips.values, round.blind.chips)
      max_value = math.max(max_value, math.max(total_chips, round.blind.chips))

      table.insert(dollars.values, play.dollars)
      dollars.max_value = math.max(dollars.max_value, play.dollars)

      -- Check if ante changed, to deliniate a ante group boundary
      if current_ante ~= round.ante then
        if current_ante ~= nil then
          table.insert(
            ante_group.items,
            {
              from = current_ante_start,
              to = #bars - 1,
              labels = {"Ante " .. current_ante, tostring(current_ante)}
            }
          )
        end
        current_ante = round.ante
        current_ante_start = #bars
      end
    end

    local current_round_end = #bars
    table.insert(
      round_group.items,
      {
        from = current_round_start,
        to = current_round_end,
        labels = {"Round " .. round_i, "Rnd " .. round_i, tostring(round_i)},
      }
    )
  end

  -- Insert the last ante into the group
  if current_ante ~= nil then
    table.insert(
      ante_group.items,
      {
        from = current_ante_start,
        to = #bars,
        labels = {"Ante " .. current_ante, tostring(current_ante)}
      }
    )
  end

  -- Update the max value for the blind requirement line
  blind_chips.max_value = max_value

  -- Figure out percentages for each bar/line point
  local max_value_log = logish(max_value)
  for _, bar in ipairs(bars) do
    if mathx.big(bar.value) <= BIG0 then
      bar.value_percent_log = 0
      bar.value_percent_linear = 0
    else
      bar.value_percent_log = mathx.small(logish(bar.value) / max_value_log)
      bar.value_percent_linear = mathx.small(bar.value / max_value)
    end
  end
  for i, value in ipairs(blind_chips.values) do
    if mathx.big(value) == BIG0 then
      blind_chips.values_percent_log[i] = 0
      blind_chips.values_percent_linear[i] = 0
    else
      blind_chips.values_percent_log[i] = mathx.small(logish(value) / max_value_log)
      blind_chips.values_percent_linear[i] = mathx.small(value / max_value)
    end
  end
  local dollars_max_value_log = logish(dollars.max_value)
  for i, value in ipairs(dollars.values) do
    if mathx.big(value) == BIG0 then
      dollars.values_percent_log[i] = 0
      dollars.values_percent_linear[i] = 0
    else
      dollars.values_percent_log[i] = mathx.small(logish(value) / dollars_max_value_log)
      dollars.values_percent_linear[i] = mathx.small(value / dollars.max_value)
    end
  end

  --- @type GraphBars
  return {
    bars = bars,
    lines = {
      dollars,
      blind_chips,
    },
    max_value = max_value,
    groups = {
      round_group,
      ante_group,
    },
  }
end

--- @return GraphBars
--- @nodiscard
local function gather_bars_grouped_by_rounds()
  local rounds = stats.StatsRoot.get_current().rounds

  -- Figure out how much space the longest bits of chips text take up
  -- So we can draw all that text nice and aligned
  local max_total_chips_len = 0
  local max_required_chips_len = 0
  for _, round in ipairs(rounds) do
    max_total_chips_len = math.max(max_total_chips_len, G.LANG.font.FONT:getWidth(number_format(round:get_total_chips())))
    max_required_chips_len = math.max(max_required_chips_len, G.LANG.font.FONT:getWidth(number_format(round.blind.chips)))
  end

  --- @type GraphBar[]
  local bars = {}

  --- @type GraphLine
  local blind_chips = {
    values = {},
    values_percent_linear = {},
    values_percent_log = {},
    color = G.C.RED,
    max_value = 0,
  }

  --- @type GraphLine
  local dollars = {
    values = {},
    values_percent_linear = {},
    values_percent_log = {},
    color = G.C.GOLD,
    max_value = 0,
  }

  --- @type GraphGroup
  local ante_group = {items = {}}

  local current_ante = nil
  local current_ante_start = nil

  local max_value = BIG0

  for round_i, round in ipairs(rounds) do
    local total_chips = round:get_total_chips()
    table.insert(
      bars,
      {
        value = total_chips,
        draw_on_bar = function(rect, compact_ease)
          local function print_offset(text, y_offset)
            graphicsx.outlined_print(
              text,
              G.LANG.font.FONT,
              rect.x + 0.04,
              rect.y + rect.h - 0.1 + (y_offset * 0.002),
              -DEG90_AS_RAD,
              0.002,
              0.002
              )
          end

          local total_chips_text = number_format(total_chips)
          local required_chips_text = number_format(round.blind.chips)

          local y_offset = -max_total_chips_len
          love.graphics.setColor(1, 1, 1, 1 - compact_ease)
          print_offset(total_chips_text .. " / ", y_offset + G.LANG.font.FONT:getWidth(total_chips_text))

          y_offset = y_offset - G.LANG.font.FONT:getWidth(" / ")
          y_offset = y_offset - max_required_chips_len
          love.graphics.setColor(adjust_alpha(G.C.RED, 1 - compact_ease))
          print_offset(required_chips_text, y_offset + G.LANG.font.FONT:getWidth(required_chips_text))

          -- Add a bit of space before drawing the blind name
          y_offset = y_offset - 100

          local blind_name = localize{type = "name_text", key = round.blind.key, set = "Blind"} --[[@as string]]
          local blind_len = G.LANG.font.FONT:getWidth(blind_name)

          love.graphics.setColor(adjust_alpha(get_blind_main_colour(round.blind.key), 1 - compact_ease))
          love.graphics.rectangle(
            "fill",
            rect.x + rect.w - 0.1,
            rect.y + rect.h - 0.1 + (y_offset * 0.002) + 0.1,
            0.1,
            -blind_len * 0.002 - 0.2
          )

          -- Draw boss blinds in white
          -- Small/big blinds show up *very* faded since you can easily infer them, and the blind text can get quite
          -- visually noisy
          if round.blind:is_boss() then
            love.graphics.setColor(adjust_alpha(G.C.UI.TEXT_LIGHT, 1 - compact_ease))
          else
            love.graphics.setColor(adjust_alpha(G.C.UI.TEXT_LIGHT, 0.25 * (1 - compact_ease)))
          end

          print_offset(blind_name, y_offset)
        end,
        get_sidebar_uielems = function()
          local last_play = round:get_last_play()

          -- Make joker card area
          local joker_card_area = CardArea(0, 0, ui_metrics.SIDEBAR_WIDTH, G.CARD_H / 2, {card_limit = #last_play.joker_cards, card_w = G.CARD_W / 2, type = "play"})
          for _, v in tablex.imap(last_play.joker_cards, stats.JmCard.to_card) do
            v.T.scale = 0.5
            v:remove_UI()
            disable_hover(v)
            joker_card_area:emplace(v, nil, true)
          end

          return {
            ui_common.make_round_heading(round_i, round),
            ui_common.SIDEBAR_SPACER,
            ui_common.make_kv_text("Money: ", G.C.UI.TEXT_LIGHT, "$" .. number_format(last_play.dollars), G.C.GOLD),
            ui_common.SIDEBAR_SPACER,
            ui_common.make_kv_text("Hands played: ", G.C.UI.TEXT_LIGHT, tostring(#round.plays), G.C.RED),
            ui_common.SIDEBAR_SPACER,
            {
              n = G.UIT.R,
              nodes = {
                {n = G.UIT.T, config = {text = "Jokers", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}},
              },
            },
            {
              n = G.UIT.R,
              nodes = {
                {n = G.UIT.O, config = {object = joker_card_area}},
              },
            },
            ui_common.SIDEBAR_SPACER,
            ui_common.uielem_blind(round.blind, ui_metrics.SIDEBAR_WIDTH),
          }
        end,
        on_click = function()
          -- Nothing
        end,
      }
    )
    table.insert(blind_chips.values, round.blind.chips)
    max_value = math.max(max_value, math.max(total_chips, round.blind.chips))

    local last_play = round:get_last_play()
    table.insert(dollars.values, last_play.dollars)
    dollars.max_value = math.max(dollars.max_value, last_play.dollars)

    -- Check if ante changed, to deliniate a ante group boundary
    if current_ante ~= round.ante then
      if current_ante ~= nil then
        table.insert(
          ante_group.items,
          {
            from = current_ante_start,
            to = #bars - 1,
            labels = {"Ante " .. current_ante, tostring(current_ante)}
          }
        )
      end
      current_ante = round.ante
      current_ante_start = #bars
    end
  end

  -- Insert the last ante into the group
  if current_ante ~= nil then
    table.insert(
      ante_group.items,
      {
        from = current_ante_start,
        to = #bars,
        labels = {"Ante " .. current_ante, tostring(current_ante)}
      }
    )
  end

  -- Update the max value for the blind requirement line
  blind_chips.max_value = max_value

  -- Figure out percentages for each bar/line point
  local max_value_log = logish(max_value)
  for _, bar in ipairs(bars) do
    if mathx.big(bar.value) <= BIG0 then
      bar.value_percent_log = 0
      bar.value_percent_linear = 0
    else
      bar.value_percent_log = mathx.sign(bar.value) * mathx.small(logish(math.abs(bar.value)) / max_value_log)
      bar.value_percent_linear = mathx.small(bar.value / max_value)
    end
  end
  for i, value in ipairs(blind_chips.values) do
    if mathx.big(value) == BIG0 then
      blind_chips.values_percent_log[i] = 0
      blind_chips.values_percent_linear[i] = 0
    else
      blind_chips.values_percent_log[i] = mathx.sign(value) * mathx.small(logish(math.abs(value)) / max_value_log)
      blind_chips.values_percent_linear[i] = mathx.small(value / max_value)
    end
  end
  local dollars_max_value_log = logish(dollars.max_value)
  for i, value in ipairs(dollars.values) do
    if mathx.big(value) == BIG0 then
      dollars.values_percent_log[i] = 0
      dollars.values_percent_linear[i] = 0
    else
      dollars.values_percent_log[i] = mathx.sign(value) * mathx.small(logish(math.abs(value)) / dollars_max_value_log)
      dollars.values_percent_linear[i] = mathx.small(value / dollars.max_value)
    end
  end

  --- @type GraphBars
  return {
    bars = bars,
    lines = {
      dollars,
      blind_chips,
    },
    max_value = max_value,
    groups = {
      ante_group,
    },
  }
end

--- @param width number
--- @param group_by EGroupBy
--- @param logarithmic boolean
--- @param compact boolean
function M.Graph:init(width, group_by, logarithmic, compact)
  Moveable.init(self, 0, 0, width, 9)

  self.logarithmic = logarithmic
  self._logarithmic_ease = logarithmic and 1 or 0
  self.compact = compact
  self._compact_ease = compact and 1 or 0
  self.hovered_bar_changed = signal.Signal.new()

  self:set_group_by(group_by)

  local scroll_offset = self:_get_max_scroll_offset()
  self.scroll_offset = scroll_offset
  self.target_scroll_offset = scroll_offset
end

function M.Graph:set_group_by(group_by)
  -- Gather bars
  if group_by == "Hands" then
    self.data = gather_bars_grouped_by_hands()
  else
    self.data = gather_bars_grouped_by_rounds()
  end
end

--- Get the furthest along the graph can be scrolled
---
--- @return number
--- @nodiscard
function M.Graph:_get_max_scroll_offset()
  return math.max(0, self:_get_contents_width() - self.VT.w) --[[@as number]]
end

--- Get the amount of horizontal space the bars take up
---
--- @return number
--- @nodiscard
function M.Graph:_get_contents_width()
  local contents_width = (#self.data.bars * (BAR_WIDTH + BAR_GAP)) - BAR_GAP
  local compact_contents_width = (#self.data.bars * (COMPACT_BAR_WIDTH + COMPACT_BAR_GAP)) - COMPACT_BAR_GAP
  return mathx.lerp(contents_width, compact_contents_width, self._compact_ease)
end

--- @return number?
--- @nodiscard
function M.Graph:get_hovered_bar_index()
  return self._hovered_bar_index
end

--- @param bar_index number
---
--- @return table
--- @nodiscard
function M.Graph:get_sidebar_uielems_for_bar(bar_index)
  assert(bar_index ~= nil)
  return self.data.bars[bar_index].get_sidebar_uielems()
end

--- @diagnostic disable-next-line: unused-local
function M.Graph:update(dt)
  Moveable.update(self, G.real_dt)

  -- Scroll input
  self.target_scroll_offset = mathx.clamp(
    self.target_scroll_offset - input.wheel_delta_y,
    0,
    self:_get_max_scroll_offset()
  ) --[[@as number]]

  -- Scroll easing
  self.scroll_offset = mathx.lerp(
    self.scroll_offset,
    self.target_scroll_offset,
    math.min(G.real_dt * 20, 1)
  )

  -- Logarithmic toggle easing
  if self.logarithmic then
    self._logarithmic_ease = mathx.lerp(self._logarithmic_ease, 1, math.min(G.real_dt * 20, 1))
  else
    self._logarithmic_ease = mathx.lerp(self._logarithmic_ease, 0, math.min(G.real_dt * 20, 1))
  end

  -- Compact toggle easing
  if self.compact then
    self._compact_ease = mathx.lerp(self._compact_ease, 1, math.min(G.real_dt * 20, 1))
  else
    self._compact_ease = mathx.lerp(self._compact_ease, 0, math.min(G.real_dt * 20, 1))
  end
end

function M.Graph:draw()
  prep_draw(self, 1)

  local bars_rect = Rect.new(0, 0, self.VT.w, self.VT.h - SCROLLBAR_THICKNESS)
  local scrollbar_rect = Rect.new(0, self.VT.h - SCROLLBAR_THICKNESS, self.VT.w, SCROLLBAR_THICKNESS)

  self:_draw_scrollable_area(bars_rect)
  self:_draw_scrollbar(scrollbar_rect)
  self:_draw_legend(bars_rect)

  love.graphics.pop()

  -- Not sure this is needed
  add_to_drawhash(self)

  self:draw_boundingrect()
end

--- @param rect Rect
function M.Graph:_draw_scrollable_area(rect)
  love.graphics.push()
  love.graphics.translate(rect.x, rect.y)

  -- Stencil so we don't draw outside our bounds
  local orig_canvas = love.graphics.getCanvas()
  love.graphics.setCanvas{orig_canvas, stencil = true}
  love.graphics.stencil(function()
    love.graphics.setColor(G.C.WHITE)

    -- We extend the height a little bit, in case any lines are at the very top of the graph
    love.graphics.rectangle("fill", 0, -1, rect.w, rect.h + 1)
  end)
  love.graphics.setStencilTest("greater", 0)

  -- Draw bars
  local bars_rect = Rect.new(0, 0, rect.w, rect.h - (GROUP_HEIGHT * #self.data.groups))
  self:_draw_bars(bars_rect)

  -- Draw groups
  for i, group in ipairs(self.data.groups) do
    self:_draw_group(
      Rect.new(
        0,
        bars_rect.h + ((i - 1) * GROUP_HEIGHT),
        rect.w,
        GROUP_HEIGHT
      ),
      group
    )
  end

  love.graphics.setStencilTest()
  love.graphics.setCanvas(orig_canvas)

  love.graphics.pop()
end

--- @return number
--- @nodiscard
function M.Graph:_get_bar_width()
  return mathx.lerp(BAR_WIDTH, COMPACT_BAR_WIDTH, self._compact_ease)
end

--- @param rect Rect
--- @param group GraphGroup
function M.Graph:_draw_group(rect, group)
  love.graphics.setColor(G.C.GOLD)

  for _, item in ipairs(group.items) do
    local bar_width = self:_get_bar_width()
    local bar_gap = mathx.lerp(BAR_GAP, COMPACT_BAR_GAP, self._compact_ease)
    local from_x = (item.from - 1) * (bar_width + bar_gap)
    local to_x = (item.to - 1) * (bar_width + bar_gap) + bar_width

    love.graphics.rectangle(
      "fill",
      rect.x + from_x,
      rect.y + GROUP_PADDING,
      to_x - from_x,
      0.1
    )

    -- Find a label that fits
    for _, label in ipairs(item.labels) do
      if G.LANG.font.FONT:getWidth(label) * 0.002 < to_x - from_x then
        love.graphics.print(
          label,
          G.LANG.font.FONT,
          rect.x + from_x,
          rect.y + GROUP_PADDING + 0.1,
          0,
          0.002,
          0.002
        )
        break
      end
    end
  end
end

--- @param rect Rect
function M.Graph:_draw_bars(rect)
  local screen_rect = rect:global_to_screen()

  -- Scroll
  love.graphics.translate(-self.scroll_offset, 0)

  -- If our content is smaller than the width of the graph, center it
  local contents_width = self:_get_contents_width()
  if contents_width < self.VT.w then
    love.graphics.translate(self.VT.w / 2 - contents_width / 2, 0)
  end

  -- Draw bars
  local bar_width = self:_get_bar_width()
  local bar_gap = mathx.lerp(BAR_GAP, COMPACT_BAR_GAP, self._compact_ease)
  local hovered_bar_index = nil
  for i, bar in ipairs(self.data.bars) do
    local bar_percent = (bar.value_percent_log * self._logarithmic_ease) + (bar.value_percent_linear * (1 - self._logarithmic_ease))

    local h = bar_percent * rect.h
    local x = (i - 1) * (bar_width + bar_gap)
    local y = rect.h - h

    -- Also do hit testing for the mouse here
    -- (Yes this will lag one frame behind the cursor)
    local full_bar_rect = Rect.new(x - (bar_gap / 2), 0, bar_width + bar_gap, rect.h)
    if
      full_bar_rect:global_to_screen():contains_point(love.mouse.getPosition()) and
      screen_rect:contains_point(love.mouse.getPosition())
    then
      hovered_bar_index = i
    end

    -- Highlight behind the bar if this is hovered
    if i == self._hovered_bar_index then
      love.graphics.setColor(G.C.GREY)
      love.graphics.rectangle("fill", full_bar_rect.x, full_bar_rect.y, full_bar_rect.w, full_bar_rect.h)
    end

    -- Draw the bar
    love.graphics.setColor(mathx.lerp_color(G.C.BLACK, G.C.PALE_GREEN, self._compact_ease))
    love.graphics.rectangle("fill", x, y, bar_width, h)
  end

  -- Draw lines
  for _, line in ipairs(self.data.lines) do
    -- Don't crash trying to draw an empty line, if we haven't got any data yet
    if #line.values < 1 then
      goto continue
    end

    local points = {}

    for i = 1, #line.values do
      local value_percent_log = line.values_percent_log[i]
      local value_percent_linear = line.values_percent_linear[i]
      local value_percent = (value_percent_log * self._logarithmic_ease) + (value_percent_linear * (1 - self._logarithmic_ease))

      local x = (i - 1) * (bar_width + bar_gap)
      local y = rect.h - (value_percent * rect.h)
      table.insert(points, x)
      table.insert(points, y)
      table.insert(points, x + bar_width)
      table.insert(points, y)
    end

    -- Outline
    love.graphics.setLineWidth(0.15)
    love.graphics.setColor(adjust_alpha(G.C.BLACK, 0.5))
    love.graphics.line(points)

    -- Line
    love.graphics.setLineWidth(0.05)
    love.graphics.setColor(line.color)
    love.graphics.line(points)

    ::continue::
  end

  -- Draw on top of bars
  for i, bar in ipairs(self.data.bars) do
    local bar_percent = (bar.value_percent_log * self._logarithmic_ease) + (bar.value_percent_linear * (1 - self._logarithmic_ease))

    local h = bar_percent * rect.h
    local x = (i - 1) * (bar_width + bar_gap)
    local y = rect.h - h

    -- Draw text on top of the bar
    local bar_rect = Rect.new(x, y, bar_width, h)
    bar.draw_on_bar(bar_rect, self._compact_ease)
  end

  if hovered_bar_index ~= self._hovered_bar_index then
    self._hovered_bar_index = hovered_bar_index
    self.hovered_bar_changed:emit(hovered_bar_index)
  end

  if hovered_bar_index ~= nil and input.lmb_clicked then
    self.data.bars[hovered_bar_index].on_click()
  end
end

--- @param rect Rect
function M.Graph:_draw_scrollbar(rect)
  local max_scroll_offset = self:_get_max_scroll_offset()
  if max_scroll_offset > 0 then
    -- Draw track
    love.graphics.setColor(G.C.BLACK)
    love.graphics.rectangle(
      "fill",
      rect.x,
      rect.y + SCROLLBAR_PADDING,
      rect.w,
      rect.h - SCROLLBAR_PADDING
    )

    -- Draw thumb
    local scroll_percent = self.scroll_offset / max_scroll_offset
    local percent_visible = rect.w / (rect.w + max_scroll_offset)
    local thumb_length = math.max(MIN_SCROLLBAR_THUMB_LENGTH, rect.w * percent_visible)
    local thumb_offset = scroll_percent * (rect.w - thumb_length)

    love.graphics.setColor(G.C.RED)
    love.graphics.rectangle(
      "fill",
      rect.x + thumb_offset,
      rect.y + SCROLLBAR_PADDING,
      thumb_length,
      rect.h - SCROLLBAR_PADDING
    )
  else
    -- All content is visible, just draw a thumb that appears to cover the whole area
    love.graphics.setColor(G.C.RED)
    love.graphics.rectangle(
      "fill",
      rect.x,
      rect.y + SCROLLBAR_PADDING,
      rect.w,
      rect.h - SCROLLBAR_PADDING
    )
  end
end

--- @param rect Rect
function M.Graph:_draw_legend(rect)
  self:_draw_legend_item(rect.x, rect.y, G.C.RED, "Blind chips requirement")
  self:_draw_legend_item(rect.x, rect.y + 0.5, G.C.GOLD, "Money")
end

function M.Graph:_draw_legend_item(x, y, color, text)
  -- Square outline
  love.graphics.setColor(G.C.BLACK)
  love.graphics.rectangle("fill", x + 0.05, y + 0.05, 0.4, 0.4)

  -- Square
  love.graphics.setColor(color)
  love.graphics.rectangle("fill", x + 0.1, y + 0.1, 0.3, 0.3)

  -- Text
  graphicsx.outlined_print(text, G.LANG.font.FONT, x + 0.6, y + 0.05, 0, 0.002, 0.002)
end

return M
