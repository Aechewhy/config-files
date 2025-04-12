-- Played hand info window

local ui_common = jimbos_metrics_require("ui/common.lua") --- @module "ui.common"
local ui_metrics = jimbos_metrics_require("ui/metrics.lua") --- @module "ui.metrics"
local stats = jimbos_metrics_require("stats.lua") --- @module "stats"
local tablex = jimbos_metrics_require("tablex.lua") --- @module "stats"

local M = {}

--- @param round_i number Round number
--- @param round JmRound
--- @param play JmPlay
---
--- @return table
--- @nodiscard
local function uielems_win_play_contents(round_i, round, play)
  local total_chips = play:get_total_chips()

  -- Make play card area
  local play_card_area = CardArea(
    0,
    0,
    #play.play_cards > 5 and 14 or 10,
    G.CARD_H,
    {card_limit = #play.play_cards, type = "play"}
  )
  for _, v in tablex.imap(play.play_cards, stats.JmCard.to_card) do
    play_card_area:emplace(v, nil, true)
  end

  -- Make hand area
  local hand_card_area = CardArea(
    0,
    0,
    #play.hand_cards > 5 and 14 or 10,
    G.CARD_H,
    {card_limit = #play.hand_cards, type = "play"}
  )
  for _, v in tablex.imap(play.hand_cards, stats.JmCard.to_card) do
    hand_card_area:emplace(v, nil, true)
  end

  -- Make joker card area
  local joker_card_area = CardArea(
    0,
    0,
    10,
    G.CARD_H,
    {card_limit = #play.joker_cards, type = "play"}
  )
  for _, v in tablex.imap(play.joker_cards, stats.JmCard.to_card) do
    joker_card_area:emplace(v, nil, true)
  end

  -- Make consumable card area
  local consumable_card_area = CardArea(
    0,
    0,
    4,
    G.CARD_H,
    {card_limit = #play.consumable_cards, type = "play"}
  )
  for _, v in tablex.imap(play.consumable_cards, stats.JmCard.to_card) do
    consumable_card_area:emplace(v, nil, true)
  end

  return {
    -- TItle text
    {
      n = G.UIT.R,
      config = {align = "cm"},
      nodes = {
        {n = G.UIT.T, config = {text = "Jimbo's Metrics: Played hand", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}},
      },
    },

    {
      n = G.UIT.R,
      nodes = {
        -- Left panel
        {
          n = G.UIT.C,
          config = {
            minw = ui_metrics.SIDEBAR_WIDTH,
          },
          nodes = {
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
            ui_common.SIDEBAR_SPACER,
            ui_common.uielem_blind(round.blind, ui_metrics.SIDEBAR_WIDTH),
          },
        },

        -- Spacing
        {n = G.UIT.B, config = {w = 0.2, h = 0}},

        -- Right panel, shows cards
        {
          n = G.UIT.C,
          nodes = {
            {
              n = G.UIT.R,
              nodes = {
                -- Joker cards
                {
                  n = G.UIT.C,
                  nodes = {
                    {
                      n = G.UIT.R,
                      config = {align = "cm"},
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
                  },
                },

                -- Consumable cards
                {
                  n = G.UIT.C,
                  nodes = {
                    {
                      n = G.UIT.R,
                      config = {align = "cm"},
                      nodes = {
                        {n = G.UIT.T, config = {text = "Consumables", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}},
                      },
                    },
                    {
                      n = G.UIT.R,
                      nodes = {
                        {n = G.UIT.O, config = {object = consumable_card_area}},
                      },
                    },
                  },
                },
              },
            },

            -- Played cards
            {
              n = G.UIT.R,
              config = {align = "cm"},
              nodes = {
                {n = G.UIT.T, config = {text = "Played cards", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}},
              },
            },
            {
              n = G.UIT.R,
              config = {align = "cm"},
              nodes = {
                {n = G.UIT.O, config = {object = play_card_area}},
              },
            },

            -- Cards in hand
            {
              n = G.UIT.R,
              config = {align = "cm"},
              nodes = {
                {n = G.UIT.T, config = {text = "Cards in hand", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}},
              },
            },
            {
              n = G.UIT.R,
              config = {align = "cm"},
              nodes = {
                {n = G.UIT.O, config = {object = hand_card_area}},
              },
            },
          },
        },
      },
    },
  }
end

--- @param round_i number
--- @param round JmRound
--- @param play JmPlay
---
--- @return table
--- @nodiscard
local function uibox_win_play(round_i, round, play)
  local items = uielems_win_play_contents(round_i, round, play)
  table.insert(items, ui_common.uielem_back_button("craftedcart_jimbos_metrics_win_play_back"))

  return {
    n = G.UIT.ROOT,
    config = {
      align = "cm",
      minw = G.ROOM.T.w * 5,
      minh = G.ROOM.T.h * 5,
      padding = 0.1,
      r = 0.1,
      colour = {G.C.GREY[1], G.C.GREY[2], G.C.GREY[3], 0.7}
    },
    nodes = {
      {
        n = G.UIT.R,
        config = {
          align = "cm",
          minh = 1,
          r = 0.3,
          padding = 0.07,
          minw = 1,
          colour = G.C.JOKER_GREY,
          emboss = 0.1
        },
        nodes = {
          {
            n = G.UIT.C,
            config = {
              align = "cm",
              minh = 1,
              r = 0.2,
              padding = 0.2,
              minw = 1,
              colour = G.C.L_BLACK
            },
            nodes = items,
          },
        }
      },
    },
  }
end

--- Show the window with a given play
---
--- @param round_i number Round number
--- @param round JmRound
--- @param play JmPlay
function M.show(round_i, round, play)
  G.SETTINGS.paused = true
  G.FUNCS.overlay_menu{
    definition = uibox_win_play(round_i, round, play),
    config = {no_esc = G.OVERLAY_MENU and G.OVERLAY_MENU.config.no_esc},
  }
end

function M.init()
  G.FUNCS.craftedcart_jimbos_metrics_win_play_back = function()
    local ui_win_summary = jimbos_metrics_require("ui/win_summary.lua") --- @module "ui.win_summary"
    ui_win_summary.show()
  end
end

function M.__on_reload()
  M.init()
end

return M
