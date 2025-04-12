-- Summary window

local ui_metrics = jimbos_metrics_require("ui/metrics.lua") --- @module "ui.metrics"
local ui_graph = jimbos_metrics_require("ui/graph.lua") --- @module "ui.graph"
local ui_common = jimbos_metrics_require("ui/common.lua") --- @module "ui.common"
local signal = jimbos_metrics_require("signal.lua") --- @module "signal"

local M = {}

--- @type Graph?
local current_graph = nil

--- @type EGroupBy
local group_by = "Hands"

local show_more_info = true

local function new_ref(initial_value)
  return setmetatable(
    {
      _inner = initial_value,
      on_changed = signal.Signal.new(),
    },
    {
      __index = function(self, k)
        if k == "value" then
          return self._inner
        else
          error("Invalid key " .. tostring(k))
        end
      end,

      __newindex = function(self, k, v)
        if k == "value" then
          self._inner = v
          self.on_changed:emit(v)
        else
          error("Invalid key " .. tostring(k))
        end
      end,
    }
  )
end

--- A bool inside a table for reference semantics, and voodoo magic
local logarithmic = new_ref(false)
logarithmic.on_changed:bind(function(new_value)
  current_graph.logarithmic = new_value
end)

--- A bool inside a table for reference semantics, and voodoo magic
local compact = new_ref(false)
compact.on_changed:bind(function(new_value)
  current_graph.compact = new_value
end)

local function uibox_empty()
  return {
    n = G.UIT.ROOT,
    config = {
      maxw = 0,
      colour = G.C.CLEAR,
    },
    nodes = {},
  }
end

local function uibox_info_sidebar()
  assert(current_graph ~= nil)

  local hovered_bar_index = current_graph:get_hovered_bar_index()
  local sidebar_nodes
  if hovered_bar_index ~= nil then
    sidebar_nodes = current_graph:get_sidebar_uielems_for_bar(hovered_bar_index)

    -- Force each node to be the width of the sidebar
    for _, node in ipairs(sidebar_nodes) do
      node.config = node.config or {}
      node.config.minw = ui_metrics.SIDEBAR_WIDTH
      node.config.maxw = ui_metrics.SIDEBAR_WIDTH
    end
  else
    sidebar_nodes = {
      {
        n = G.UIT.R,
        nodes = {
          {n = G.UIT.T, config = {text = "Hover over a bar", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}},
        },
      },
      {
        n = G.UIT.R,
        nodes = {
          {n = G.UIT.T, config = {text = "for more info", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}},
        },
      },
    }
  end

  return {
    n = G.UIT.ROOT,
    config = {
      align = "cl",
      minw = ui_metrics.SIDEBAR_WIDTH,
      maxw = ui_metrics.SIDEBAR_WIDTH,
      colour = G.C.CLEAR,
    },
    nodes = sidebar_nodes,
  }
end

local function refresh_sidebar(sidebar)
  local sidebar_uibox = sidebar.config.object
  local parent = sidebar_uibox.parent

  -- Replace sidebar
  sidebar_uibox:remove()
  sidebar.config.object = UIBox{
    definition = show_more_info and uibox_info_sidebar() or uibox_empty(),
    config = {
      offset = {x = 0, y = 0},
      parent = parent,
    },
  }

  -- Change graph size
  assert(current_graph ~= nil)
  current_graph.T.w = show_more_info and (ui_metrics.GRAPH_WIDTH - ui_metrics.SIDEBAR_WIDTH) or ui_metrics.GRAPH_WIDTH

  -- Recompute layout
  G.OVERLAY_MENU:recalculate()
end

local more_info_button = UIBox_button{
  label = {"Toggle Sidebar"},
  colour = G.C.RED,
  button = "craftedcart_jimbos_metrics_win_summary_more_info",
}

local function uielems_win_summary_contents()
  current_graph = ui_graph.Graph(
    show_more_info and (ui_metrics.GRAPH_WIDTH - ui_metrics.SIDEBAR_WIDTH) or ui_metrics.GRAPH_WIDTH,
    group_by,
    logarithmic.value,
    compact.value
  )

  local sidebar_elem = {
    n = G.UIT.O,
    config = {
      object = UIBox{
        definition = show_more_info and uibox_info_sidebar() or uibox_empty(),
        config = {
          offset = {x = 0, y = 0},
        },
      },
    },
  }

  current_graph.hovered_bar_changed:bind(function(_)
    refresh_sidebar(sidebar_elem)
  end)
  more_info_button.nodes[1].config._sidebar = sidebar_elem

  return {
    -- TItle text
    {
      n = G.UIT.R,
      config = {align = "cm"},
      nodes = {
        {n = G.UIT.T, config = {text = "Jimbo's Metrics: Run summary", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}},
      },
    },

    -- Options row at the top
    {
      n = G.UIT.R,
      config = {align = "cm"},
      nodes = {
        -- More info
        {
          n = G.UIT.C,
          config = {align = "cm"},
          nodes = {
            more_info_button,
          },
        },

        -- Spacer
        {n = G.UIT.B, config = {w = 0.5, h = 0}},

        -- Group by
        {
          n = G.UIT.C,
          config = {align = "cm"},
          nodes = {
            {n = G.UIT.T, config = {text = "Group by", scale = 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true}}
          },
        },
        {n = G.UIT.B, config = {w = 0.1, h = 0}},
        {
          n = G.UIT.C,
          config = {align = "cm"},
          nodes = {
            create_option_cycle{
              options = {"Hands", "Rounds"}, --- @type EGroupBy[]
              current_option = group_by == "Hands" and 1 or 2,
              opt_callback = "craftedcart_jimbos_metrics_win_summary_set_group_by",
            },
          },
        },

        -- Logarithmic toggle
        {
          n = G.UIT.C,
          config = {align = "cm"},
          nodes = {
            create_toggle{
              label = "Logarithmic",
              ref_table = logarithmic,
              ref_value = "value",
            },
          },
        },

        -- Compact toggle
        {
          n = G.UIT.C,
          config = {align = "cm"},
          nodes = {
            create_toggle{
              label = "Compact",
              ref_table = compact,
              ref_value = "value",
            },
          },
        },
      },
    },

    {
      n = G.UIT.R,
      nodes = {
        -- Sidebar
        sidebar_elem,

        -- Graph
        {n = G.UIT.O, config = {object = current_graph}},
      },
    },
  }
end

local function uibox_win_summary()
  local items = uielems_win_summary_contents()
  table.insert(items, ui_common.uielem_back_button("craftedcart_jimbos_metrics_win_summary_back"))

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

--- Kindof a hack
---
--- Basically, if you open this from the "you win" menu, we want to go back to the "you win" menu
---
--- @type boolean
local opened_from_victory_menu = false

function M.show()
  -- Hidden functionality!
  -- Ctrl+Shift to toggle _RELEASE_MODE
  -- Ctrl+Alt to reload
  -- Shift+Alt to GC
  if love.keyboard.isDown("lctrl") and love.keyboard.isDown("lshift") then
    _RELEASE_MODE = not _RELEASE_MODE

    -- Reload pause menu
    if G.STATE ~= G.STATES.GAME_OVER then
      G.FUNCS.options()
    end
    return
  elseif love.keyboard.isDown("lctrl") and love.keyboard.isDown("lalt") then
    jimbos_metrics_reload_all()
    return
  elseif love.keyboard.isDown("lshift") and love.keyboard.isDown("lalt") then
    sendInfoMessage(string.format("Before GC: %dKbytes in use", collectgarbage("count")))
    collectgarbage("collect")
    sendInfoMessage(string.format("After GC: %dKbytes in use", collectgarbage("count")))
    return
  end

  G.SETTINGS.paused = true
  G.FUNCS.overlay_menu{
    definition = uibox_win_summary(),
    config = {no_esc = G.STATE == G.STATES.GAME_OVER or opened_from_victory_menu},
  }
end

function M.init()
  G.FUNCS.craftedcart_jimbos_metrics_win_summary_view_from_victory = function()
    opened_from_victory_menu = true
    M.show()
  end

  G.FUNCS.craftedcart_jimbos_metrics_win_summary_view = function()
    opened_from_victory_menu = false
    M.show()
  end

  G.FUNCS.craftedcart_jimbos_metrics_win_summary_back = function()
    if G.STATE == G.STATES.GAME_OVER then
      G.FUNCS.overlay_menu{
          definition = create_UIBox_game_over(),
          config = {no_esc = true},
      }
    elseif opened_from_victory_menu then
      G.FUNCS.overlay_menu{
          definition = create_UIBox_win(),
          config = {no_esc = true},
      }
    else
      G.FUNCS.options()
    end
  end

  G.FUNCS.craftedcart_jimbos_metrics_win_summary_set_group_by = function(args)
    group_by = args.to_val
    if current_graph ~= nil then
      current_graph:set_group_by(group_by)
    end
  end

  G.FUNCS.craftedcart_jimbos_metrics_win_summary_more_info = function(ui_elem)
    show_more_info = not show_more_info
    refresh_sidebar(ui_elem.config._sidebar)
  end
end

function M.__on_reload()
  M.init()
end

return M
