local mathx = jimbos_metrics_require("mathx.lua") --- @module "mathx"

local M = {}

M.SIDEBAR_SPACER = {
  n = G.UIT.R,
  nodes = {
    {n = G.UIT.B, config = {w = 1, h = 0.25}},
  },
}

--- @param callback_name string Function (in `G.FUNCS`) to invoke when the back button is pressed
---
--- @return table
--- @nodiscard
function M.uielem_back_button(callback_name)
  return {
    n = G.UIT.R,
    config = {
      id = "overlay_menu_back_button",
      align = "cm",
      minw = 2.5,
      -- button_delay = args.back_delay,
      padding = 0.1,
      r = 0.1,
      hover = true,
      colour = G.C.ORANGE,
      button = callback_name,
      shadow = true,
      focus_args = {
        nav = "wide",
        button = "b",
        -- snap_to = args.snap_back
      }
    },
    nodes = {
      {
        n = G.UIT.R,
        config = {align = "cm", padding = 0, no_fill = true},
        nodes = {
          {
            n = G.UIT.T,
            config = {
              text = localize("b_back"),
              scale = 0.5,
              colour = G.C.UI.TEXT_LIGHT,
              shadow = true,
            },
          },
        },
      },
    },
  }
end

--- Make key-value paired text
---
--- @param k string
--- @param k_color Rgba
--- @param v string
--- @param v_color Rgba
--- @param scale number?
---
--- @return table
--- @nodiscard
function M.make_kv_text(k, k_color, v, v_color, scale)
  scale = scale or 1

  return {
    n = G.UIT.R,
    nodes = {
      {n = G.UIT.T, config = {text = k, colour = k_color, scale = 0.5 * scale, shadow = true}},
      {n = G.UIT.T, config = {text = v, colour = v_color, scale = 0.5 * scale, shadow = true}},
    },
  }
end

--- @param blind JmBlind
--- @param width number
---
--- @return table
--- @nodiscard
function M.uielem_blind(blind, width)
  local blind_proto = blind:get_prototype()

  local blind_name = localize{type = "name_text", key = blind.key, set = "Blind"} --[[@as string]]

  -- TODO? This doesn't properly get the blind description since we pass no vars in
  -- Eg: The blind that sets your money to zero when you play most played poker hand won't work
  --     (it says "Playing a nil sets money to $0")
  local ok, blind_desc_lines = pcall(
    localize,
    {
      type = "raw_descriptions",
      key = blind.key,
      set = "Blind",
      vars = setmetatable({}, {__index = function(_, _) return "?" end}),
    }
  )
  if not ok then
    -- Try again with numerical vars
    -- Cryptid seems to expect that in some places at least (Eg: The Joke blind)
    ok, blind_desc_lines = pcall(
      localize,
      {
        type = "raw_descriptions",
        key = blind.key,
        set = "Blind",
        vars = setmetatable({}, {__index = function(_, _) return 0 end}),
      }
    )

    if not ok then
      -- Give up
      blind_desc_lines = {
        "Error fetching",
        "blind description",
      }
    end
  end

  local blind_color = get_blind_main_colour(blind.key)
  -- if blind_proto ~= nil and blind_proto.boss_colour ~= nil then
  --   blind_color = blind_proto.boss_colour
  -- elseif blind.key == "bl_small" then
  --   blind_color = G.C.BLUE
  -- elseif blind.key == "bl_big" then
  --   blind_color = G.C.ORANGE
  -- else
  --   blind_color = G.C.RED
  -- end

  local texts = {
    -- Blind name/heading
    {
      n = G.UIT.R,
      nodes = {
        {n = G.UIT.T, config = {text = "Blind: ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}},
        {
          n = G.UIT.C,
          config = {
            colour = blind_color,
            r = 0.1,
          },
          nodes = {
            {n = G.UIT.B, config = {w = 0.175, h = 0}},
            {n = G.UIT.T, config = {text = blind_name, colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}},
            {n = G.UIT.B, config = {w = 0.2, h = 0}},
          },
        },
      },
    },
    M.make_kv_text(number_format(blind.chips), G.C.RED, " required chips", G.C.JOKER_GREY, 0.75),
  }
  -- Blind description
  for _, line in ipairs(blind_desc_lines --[=[@as string[]]=]) do
    table.insert(texts, M.make_text_line(line, G.C.JOKER_GREY, 0.75))
  end

  local out = {
    n = G.UIT.R,
    nodes = {
      {
        n = G.UIT.C,
        config = {
          align = "tl",
          minw = width - 1,
        },
        nodes = texts,
      },
    },
  }

  -- Add the blind sprite
  if blind_proto ~= nil then
    local sprite = AnimatedSprite(0, 0, 1, 1, G.ANIMATION_ATLAS.blind_chips, blind_proto.pos)

    table.insert(
      out.nodes,
      {
        n = G.UIT.O,
        config = {
          align = "tr",
          object = sprite,
        },
      }
    )
  end

  return out
end

--- @param text string
--- @param color Rgba
--- @param scale number?
---
--- @return table
--- @nodiscard
function M.make_text_line(text, color, scale)
  scale = scale or 1

  return {
    n = G.UIT.R,
    nodes = {
      {n = G.UIT.T, config = {text = text, colour = color, scale = 0.5 * scale, shadow = true}},
    },
  }
end

--- @param round_i number
--- @param round JmRound
---
--- @return table
--- @nodiscard
function M.make_round_heading(round_i, round)
  return {
    n = G.UIT.R,
    nodes = {
      {n = G.UIT.T, config = {text = "Round ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}},
      {n = G.UIT.T, config = {text = tostring(round_i), colour = G.C.GOLD, scale = 0.5, shadow = true}},
      {n = G.UIT.T, config = {text = " Ante ", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}},
      {n = G.UIT.T, config = {text = tostring(round.ante), colour = G.C.GOLD, scale = 0.5, shadow = true}},
    },
  }
end

--- @param num number|Big
---
--- @return string
--- @nodiscard
function M.format_multiplier(num)
  -- Balatro's number_format deals badly with numbers smaller than 0.01
  if mathx.big(num) < mathx.big(0.01) then
    return string.format("%.3f", mathx.small(num))
  else
    return number_format(num)
  end
end

return M
