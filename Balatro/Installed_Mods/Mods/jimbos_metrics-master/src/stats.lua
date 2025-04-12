local mathx = jimbos_metrics_require("mathx.lua") --- @module "mathx"
local tablex = jimbos_metrics_require("tablex.lua") --- @module "tablex"

local M = {}

-- StatsRoot -----------------------------------------------------------------------------------------------------------

--- @class StatsRoot
--- @field rounds JmRound[]
M.StatsRoot = {}
local StatsRoot_metatable = {__index = M.StatsRoot}

--- @return StatsRoot
--- @nodiscard
function M.StatsRoot.new()
  return setmetatable(
    {
      rounds = {},
    },
    StatsRoot_metatable
  )
end

--- @return StatsRoot
--- @nodiscard
function M.StatsRoot.get_current()
  if G.GAME.craftedcart_jimbos_metrics == nil then
    G.GAME.craftedcart_jimbos_metrics = M.StatsRoot.new()
  end

  return G.GAME.craftedcart_jimbos_metrics
end

--- Restores metatables when stuff is loaded from a save game
---
--- @param root StatsRoot
function M.StatsRoot.restore_from_save(root)
  setmetatable(root, StatsRoot_metatable)

  for _, round in pairs(root.rounds) do
    M.JmRound.restore_from_save(round)
  end
end

-- JmRound -------------------------------------------------------------------------------------------------------------

--- @class JmRound
--- @field ante number
--- @field blind JmBlind
--- @field plays JmPlay[]
M.JmRound = {}
local JmRound_metatable = {__index = M.JmRound}

--- @param ante number
--- @param blind JmBlind
---
--- @return JmRound
--- @nodiscard
function M.JmRound.new(ante, blind)
  return setmetatable(
    {
      ante = ante,
      blind = blind,
      plays = {},
    },
    JmRound_metatable
  )
end

--- @return JmRound
--- @nodiscard
function M.JmRound.get_current()
  local stats = M.StatsRoot.get_current()
  if stats.rounds[G.GAME.round] == nil then
    local blind_moveable = G.GAME.blind
    local blind_proto = blind_moveable.config.blind
    local jm_blind = M.JmBlind.new(blind_proto.key, blind_moveable.chips)
    stats.rounds[G.GAME.round] = M.JmRound.new(G.GAME.round_resets.ante, jm_blind)
  end

  return stats.rounds[G.GAME.round]
end

--- Restores metatables when stuff is loaded from a save game
---
--- @param round JmRound
function M.JmRound.restore_from_save(round)
  setmetatable(round, JmRound_metatable)
  M.JmBlind.restore_from_save(round.blind)

  for _, play in pairs(round.plays) do
    M.JmPlay.restore_from_save(play)
  end
end

--- @param play JmPlay
function M.JmRound:add_play(play)
  table.insert(self.plays, play)
end

--- @return JmPlay
--- @nodiscard
function M.JmRound:get_last_play()
  assert(#self.plays > 0)
  return self.plays[#self.plays]
end

--- Get the number of chips scored this round
---
--- @return number|Big
--- @nodiscard
function M.JmRound:get_total_chips()
  local total_chips = mathx.big(0)

  for _, play in pairs(self.plays) do
    total_chips = total_chips + play:get_total_chips()
  end

  return total_chips
end

-- JmBlind -------------------------------------------------------------------------------------------------------------

--- @class JmBlind
--- @field key string Table key of the blind (in `G.P_BLINDS` - eg: "Small Blind", "The Wheel")
--- @field chips number|Big Chips required to defeat the blind
M.JmBlind = {}
local JmBlind_metatable = {__index = M.JmBlind}

--- @param key string
--- @param chips number|Big
---
--- @return JmBlind
--- @nodiscard
function M.JmBlind.new(key, chips)
  assert(G.P_BLINDS[key] ~= nil, "Blind " .. tostring(key) .. " does not exist")

  return setmetatable(
    {
      key = key,
      chips = chips,
    },
    JmBlind_metatable
  )
end

--- Restores metatables when stuff is loaded from a save game
---
--- @param blind JmBlind
function M.JmBlind.restore_from_save(blind)
  setmetatable(blind, JmBlind_metatable)
end

--- Returns `nil` if the blind is not found (which should only be able to happen if the user changed mods after starting
--- a run)
---
--- @return table?
--- @nodiscard
function M.JmBlind:get_prototype()
  return G.P_BLINDS[self.key]
end

--- Returns `false` if unknown (which should only happen if mods changed after starting a run)
---
--- @return boolean
--- @nodiscard
function M.JmBlind:is_boss()
  local proto = self:get_prototype()
  return proto and (not not proto.boss) or false
end

-- JmPlay --------------------------------------------------------------------------------------------------------------

--- A played hand
---
--- @class JmPlay
--- @field chips number|Big Chips before they are multiplied by mult
--- @field mult number|Big
--- @field dollars number
--- @field poker_hand string Internal name for a poker hand
--- @field display_poker_hand string Can be localized with `localize(display_poker_hand, "poker_hands")`
--- @field poker_hand_level number
--- @field play_cards JmCard[] Played cards
--- @field hand_cards JmCard[] Cards in hand
--- @field joker_cards JmCard[] Joker cards
--- @field consumable_cards JmCard[] Consumable cards
M.JmPlay = {}
local JmPlay_metatable = {__index = M.JmPlay}

--- @param chips number|Big Chips before they are multiplied by mult
--- @param mult number|Big
--- @param dollars number
--- @param poker_hand string
--- @param display_poker_hand string
--- @param poker_hand_level number
--- @param play_cards JmCard[] Played cards
--- @param hand_cards JmCard[] Cards in hand
--- @param joker_cards JmCard[] Joker cards
--- @param consumable_cards JmCard[] Consumable cards
---
--- @return JmPlay
--- @nodiscard
function M.JmPlay.new(
    chips,
    mult,
    dollars,
    poker_hand,
    display_poker_hand,
    poker_hand_level,
    play_cards,
    hand_cards,
    joker_cards,
    consumable_cards
    )
  return setmetatable(
    {
      chips = chips,
      mult = mult,
      dollars = dollars,
      poker_hand = poker_hand,
      display_poker_hand = display_poker_hand,
      poker_hand_level = poker_hand_level,
      play_cards = play_cards,
      hand_cards = hand_cards,
      joker_cards = joker_cards,
      consumable_cards = consumable_cards,
    },
    JmPlay_metatable
  )
end

--- Restores metatables when stuff is loaded from a save game
---
--- @param play JmPlay
function M.JmPlay.restore_from_save(play)
  setmetatable(play, JmPlay_metatable)
  for _, v in pairs(play.play_cards) do
    M.JmCard.restore_from_save(v)
  end
  for _, v in pairs(play.joker_cards) do
    M.JmCard.restore_from_save(v)
  end
end

function M.JmPlay:get_total_chips()
  return mathx.big(self.chips) * mathx.big(self.mult)
end

-- JmCard --------------------------------------------------------------------------------------------------------------

--- @class JmCard
---
--- @param save_data table The table you get from `Card:save`
M.JmCard = {}
local JmCard_metatable = {__index = M.JmCard}

--- Convert from a Balatro Card object
---
--- @param card Card
---
--- @return JmCard
--- @nodiscard
function M.JmCard.from_card(card)
  return setmetatable(
    {
      save_data = card:save(),
    },
    JmCard_metatable
  )
end

--- @return Card
--- @nodiscard
function M.JmCard:to_card()
  local card = Card(0, 0, G.CARD_W, G.CARD_H, G.P_CENTERS.j_joker, G.P_CENTERS.c_base)

  -- Fix issues where removing these cards could cause joker slots to go down, if this was a negative joker
  -- (among other weird things)
  local save_data = tablex.shallow_clone(self.save_data)
  save_data.added_to_deck = false
  save_data.joker_added_to_deck_but_debuffed = false
  save_data.ability = save_data.ability or {}
  save_data.ability.joker_added_to_deck_but_debuffed = false

  card:load(save_data)

  return card
end

--- Restores metatables when stuff is loaded from a save game
---
--- @param card JmCard
function M.JmCard.restore_from_save(card)
  setmetatable(card, JmCard_metatable)
end

------------------------------------------------------------------------------------------------------------------------

local waiting_for_scoring = false

--- @return boolean
--- @nodiscard
local function is_scoring()
  return G.SCORING_COROUTINE ~= nil and coroutine.status(G.SCORING_COROUTINE) ~= "dead"
end

local function on_hand_played()
  assert(not is_scoring())

  local poker_hand, _, _, _, display_poker_hand = G.FUNCS.get_poker_hand_info(G.play.cards)
  local poker_hand_level = G.GAME.hands[poker_hand].level

  M.JmRound.get_current():add_play(
    M.JmPlay.new(
      hand_chips,
      mult,
      G.GAME.dollars,
      poker_hand,
      display_poker_hand,
      poker_hand_level,
      tablex.collect(tablex.imap(G.play.cards, M.JmCard.from_card)),
      tablex.collect(tablex.imap(G.hand.cards, M.JmCard.from_card)),
      tablex.collect(tablex.imap(G.jokers.cards, M.JmCard.from_card)),
      tablex.collect(tablex.imap(G.consumeables.cards, M.JmCard.from_card))
      )
    )
end

function M.init()
  -- Track stats on round end
  -- local orig_evaluate_round = G.FUNCS.evaluate_round
  -- G.FUNCS.evaluate_round = function() --- @diagnostic disable-line: duplicate-set-field
  --   local out = orig_evaluate_round()

  --   M.JmRound.get_current():add_play(M.JmPlay.new(G.GAME.chips))

  --   return out
  -- end

  -- Track stats on played hand end
  local orig_evaluate_play = G.FUNCS.evaluate_play
  G.FUNCS.evaluate_play = function(e) --- @diagnostic disable-line: duplicate-set-field
    orig_evaluate_play(e)

    -- Talisman can smear scoring out over several frames, check for that
    if G.SCORING_COROUTINE == nil or coroutine.status(G.SCORING_COROUTINE) == "dead" then
      -- Finished scoring in one frame
      on_hand_played()
    else
      -- Scoring will take multiple frames
      waiting_for_scoring = true
    end
  end

  -- Restore metatables when loading a save game
  local orig_start_run = Game.start_run
  Game.start_run = function(self, args) --- @diagnostic disable-line: duplicate-set-field
    orig_start_run(self, args)

    if G.GAME.craftedcart_jimbos_metrics ~= nil then
      M.StatsRoot.restore_from_save(G.GAME.craftedcart_jimbos_metrics)
    end
  end

  -- Talisman calls exit_overlay_menu when done scoring, hook into there
  local orig_exit_overlay_menu = G.FUNCS.exit_overlay_menu
  G.FUNCS.exit_overlay_menu = function() --- @diagnostic disable-line: duplicate-set-field
    orig_exit_overlay_menu()

    -- The user can manually close the overlay with Esc, even though scoring still continues (and Talisman will re-open
    -- the overlay immediately after) - so double-check that Talisman is done scoring when the overlay is closed
    if waiting_for_scoring and not is_scoring() then
      waiting_for_scoring = false
      on_hand_played()
    end
  end
end

function M.__reload()
  M.init()
end

return M
