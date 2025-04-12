assert(SMODS.load_file("src/module_setup.lua"))()

local stats = jimbos_metrics_require("stats.lua") --- @module "stats"
local ui_win_summary = jimbos_metrics_require("ui/win_summary.lua") --- @module "ui.win_summary"
local ui_win_play = jimbos_metrics_require("ui/win_play.lua") --- @module "ui.win_play"
local input = jimbos_metrics_require("input.lua") --- @module "input"
local debugx = jimbos_metrics_require("debugx.lua") --- @module "debugx"
local fixes = jimbos_metrics_require("fixes.lua") --- @module "fixes"

stats.init()
ui_win_summary.init()
ui_win_play.init()
input.init()
debugx.init()
fixes.init()

-- Add to the pause menu
local orig_create_UIBox_options = create_UIBox_options
create_UIBox_options = function() --- @diagnostic disable-line: lowercase-global
  local options_ui = orig_create_UIBox_options()
  local list = options_ui.nodes[1].nodes[1].nodes[1].nodes

  if G.STAGE == G.STAGES.RUN then
    table.insert(
      list,
      UIBox_button{
        label = {"Jimbo's Metrics"},
        minw = 5,
        colour = G.C.BLUE,
        button = "craftedcart_jimbos_metrics_win_summary_view",
      }
    )
  end

  return options_ui
end

-- Add to game over menu
local orig_create_UIBox_game_over = create_UIBox_game_over
create_UIBox_game_over = function() --- @diagnostic disable-line: lowercase-global
  local game_over_ui = orig_create_UIBox_game_over()
  -- local list = game_over_ui.nodes[1].nodes[1].nodes[1].nodes[2].nodes[1].nodes[2].nodes
  local list = game_over_ui.nodes[1].nodes[2].nodes[1].nodes[1].nodes[1].nodes

  table.insert(
    list,
    {
      n = G.UIT.R,
      config = {
        align = "cm",
        minw = 5,
        padding = 0.1,
        r = 0.1,
        hover = true,
        colour = G.C.BLUE,
        button = "craftedcart_jimbos_metrics_win_summary_view",
        shadow = true,
        focus_args = {nav = "wide"}
      },
      nodes = {
        {
          n = G.UIT.R,
          config = {
            align = "cm",
            padding = 0,
            no_fill = true,
            maxw = 4.8
          },
          nodes = {
            {
              n = G.UIT.T,
              config = {
                text = "Jimbo's Metrics",
                scale = 0.5,
                colour = G.C.UI.TEXT_LIGHT
              },
            },
          },
        },
      },
    }
  )

  return game_over_ui
end

-- Add to victory menu
local orig_create_UIBox_win = create_UIBox_win
create_UIBox_win = function()
  local win_ui = orig_create_UIBox_win()
  local list = win_ui.nodes[1].nodes[2].nodes[1].nodes[1].nodes[1].nodes

  table.insert(
    list,
    {
      n = G.UIT.R,
      config = {
        align = "cm",
        minw = 5,
        padding = 0.1,
        r = 0.1,
        hover = true,
        colour = G.C.BLUE,
        button = "craftedcart_jimbos_metrics_win_summary_view_from_victory",
        shadow = true,
        focus_args = {nav = "wide"}
      },
      nodes = {
        {
          n = G.UIT.R,
          config = {
            align = "cm",
            padding = 0,
            no_fill = true,
            maxw = 4.8
          },
          nodes = {
            {
              n = G.UIT.T,
              config = {
                text = "Jimbo's Metrics",
                scale = 0.5,
                colour = G.C.UI.TEXT_LIGHT
              },
            },
          },
        },
      },
    }
  )

  return win_ui
end

-- Add debug stuff to the smods config tab
SMODS.current_mod.config_tab = function()
  return {
    n = G.UIT.ROOT,
    config = {
      emboss = 0.05,
      minh = 6,
      r = 0.1,
      minw = 10,
      align = "cm",
      padding = 0.2,
      colour = G.C.BLACK,
    },
    nodes = {
      {
        n = G.UIT.R,
        nodes = {
          {
            n = G.UIT.T,
            config = {
              text = "Debug utilities",
              scale = 0.5,
              colour = G.C.UI.TEXT_LIGHT,
            },
          },
        },
      },

      {
        n = G.UIT.R,
        nodes = {
          UIBox_button{
            label = {"Reload mod"},
            minw = 5,
            colour = G.C.ORANGE,
            button = "craftedcart_jimbos_metrics_reload",
          },
        },
      },

      -- Perf testing button
      {
        n = G.UIT.R,
        nodes = {
          UIBox_button{
            label = {"Next debugx page"},
            minw = 5,
            colour = G.C.ORANGE,
            button = "craftedcart_jimbos_metrics_debugx_next_page",
          },
        },
      },
    },
  }
end

G.FUNCS.craftedcart_jimbos_metrics_reload = function()
  jimbos_metrics_reload_all()
end
