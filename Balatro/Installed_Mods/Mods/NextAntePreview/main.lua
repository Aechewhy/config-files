---@alias Prediction { blind: string, tag: string? }
---Precicts blinds and tags for the upcoming ante
---
---Hook note:<br>
---Any changes made to `G.GAME.pseudorandom` will be reverted after this function is called
---@return { Small: Prediction, Big: Prediction, Boss: Prediction }
function predict_next_ante()
    local small_tag = get_next_tag_key()
    local big_tag = get_next_tag_key()
    local boss = get_new_boss()
    G.GAME.bosses_used[boss] = G.GAME.bosses_used[boss] - 1
    return { Small = { blind = "bl_small", tag = small_tag }, Big = { blind = "bl_big", tag = big_tag }, Boss = { blind = boss } }
end

SMODS.Blind:take_ownership("ox", {
    loc_vars = function(self)
        return { vars = { localize(G.GAME.current_round.most_played_poker_hand, 'poker_hands') } }
    end,
    preview_ui = function(self)
        local hand_center = SMODS.PokerHands[G.GAME.current_round.most_played_poker_hand]
        local hand_sprite = Sprite(0, 0, 1, 0.13 / 0.53,
            G.ASSET_ATLAS[hand_center.atlas or "nap_poker_hands"], hand_center.pos or { x = 0, y = 0 })
        return { n = G.UIT.O, config = { object = hand_sprite } }
    end
}, true)

SMODS.Tag:take_ownership("handy", {
    preview_ui = function(self, tag)
        return { n = G.UIT.T, config = { text = localize("$") .. tostring(tag.config.dollars_per_hand * (G.GAME.hands_played or 0)), colour = G.C.MONEY, scale = 0.4 } }
    end
}, true)

SMODS.Tag:take_ownership("garbage", {
    preview_ui = function(self, tag)
        return { n = G.UIT.T, config = { text = localize("$") .. tostring(tag.config.dollars_per_discard * (G.GAME.unused_discards)), colour = G.C.MONEY, scale = 0.4 } }
    end
}, true)

SMODS.Tag:take_ownership("skip", {
    preview_ui = function(self, tag)
        return { n = G.UIT.T, config = { text = localize("$") .. tostring(tag.config.skip_bonus * ((G.GAME.skips + 1) or 1)), colour = G.C.MONEY, scale = 0.4 } }
    end
}, true)

SMODS.Tag:take_ownership("orbital", {
    preview_ui = function(self, tag)
        local hand_center = SMODS.PokerHands[tag.ability.orbital_hand]
        local hand_sprite = Sprite(0, 0, 1, 0.13 / 0.53,
            G.ASSET_ATLAS[hand_center.atlas or "nap_poker_hands"], hand_center.pos or { x = 0, y = 0 })
        return { n = G.UIT.O, config = { object = hand_sprite } }
    end
}, true)

SMODS.Atlas({
    key = "poker_hands",
    path = "hands.png",
    px = 53,
    py = 13,
})

for index, handname in ipairs({
    "High Card",
    "Pair",
    "Two Pair",
    "Three of a Kind",
    "Straight",
    "Flush",
    "Full House",
    "Four of a Kind",
    "Straight Flush",
    "Five of a Kind",
    "Flush House",
    "Flush Five",
}) do
    SMODS.PokerHand:take_ownership(handname, {
        atlas = "nap_poker_hands",
        pos = { x = 0, y = index }
    }, true)
end

---Creates the preview for the upcoming ante
---
---Hook note:<br>
---Any changes made to `G.GAME.pseudorandom` will be reverted after this function is called
---
---@see predict_next_ante for the information that is rendered here
function create_ante_preview()
    G.round_eval:get_UIE_by_ID("next_ante_preview").children = {}
    local prediction = predict_next_ante()
    for _, choice in ipairs({ "Small", "Big", "Boss" }) do
        if prediction[choice] then
            local blind = G.P_BLINDS[prediction[choice].blind]
            local blind_sprite = AnimatedSprite(0, 0, 1, 1,
                G.ANIMATION_ATLAS[blind.atlas] or G.ANIMATION_ATLAS.blind_chips, blind.pos)
            blind_sprite:define_draw_steps({ { shader = 'dissolve', shadow_height = 0.05 }, { shader = 'dissolve' } })
            blind_sprite.float = true
            blind_sprite.states.hover.can = true
            blind_sprite.states.drag.can = false
            blind_sprite.states.collide.can = true
            blind_sprite.config = { blind = blind, force_focus = true }
            blind_sprite.hover = function()
                if not G.CONTROLLER.dragging.target or G.CONTROLLER.using_touch then
                    if not blind_sprite.hovering and blind_sprite.states.visible then
                        blind_sprite.hovering = true
                        blind_sprite.hover_tilt = 3
                        blind_sprite:juice_up(0.05, 0.02)
                        play_sound('chips1', math.random() * 0.1 + 0.55, 0.12)
                        local vars = blind.vars
                        if blind.loc_vars then
                            local locvars_return = blind:loc_vars()
                            vars = locvars_return and locvars_return.vars or vars
                        end
                        blind_sprite.config.h_popup = create_UIBox_blind_popup(blind, blind.discovered, vars)
                        blind_sprite.config.h_popup_config = {
                            align = 'cl',
                            offset = { x = -0.1, y = 0 },
                            parent = blind_sprite
                        }
                        Node.hover(blind_sprite)
                    end
                end
                blind_sprite.stop_hover = function()
                    blind_sprite.hovering = false; Node.stop_hover(blind_sprite)
                    blind_sprite.hover_tilt = 0
                end
            end
            local blind_preview_ui = SMODS.Mods.AntePreview.config.custom_UI and blind.preview_ui and blind:preview_ui()
                or nil
            local blind_amt = get_blind_amount(G.GAME.round_resets.blind_ante + 1)
                * blind.mult * G.GAME.starting_params.ante_scaling
            local tag = prediction[choice].tag
            local tag_sprite
            local tag_preview_ui
            if tag then
                local tag_object
                local hands = {} -- Orbital tag is weird as hell
                for k, v in pairs(G.GAME.hands) do
                    if v.visible then table.insert(hands, k) end
                end
                G.orbital_hand = pseudorandom_element(hands, pseudoseed('orbital'))
                tag_object = Tag(tag, nil, choice)
                G.orbital_hand = nil
                _, tag_sprite = tag_object:generate_UI(0.4)
                tag_preview_ui = SMODS.Mods.AntePreview.config.custom_UI and G.P_TAGS[tag].preview_ui and
                    G.P_TAGS[tag]:preview_ui(tag_object) or nil
            end
            G.round_eval:add_child({
                    n = G.UIT.C,
                    nodes = { {
                        n = G.UIT.R,
                        nodes = {
                            {
                                n = G.UIT.C,
                                config = { maxw = 1 },
                                nodes = {
                                    { n = G.UIT.R, nodes = { { n = G.UIT.O, config = { object = blind_sprite } } } },
                                    blind_preview_ui and
                                    { n = G.UIT.R, config = { align = "tm" }, nodes = { blind_preview_ui } },
                                }
                            },
                            {
                                n = G.UIT.C,
                                nodes = {
                                    {
                                        n = G.UIT.R,
                                        config = { align = "cl" },
                                        nodes = {
                                            { n = G.UIT.O, config = { object = get_stake_sprite(G.GAME.stake, 0.4) } },
                                            { n = G.UIT.T, config = { text = number_format(blind_amt), colour = G.C.RED, scale = score_number_scale(0.8, blind_amt) } }
                                        }
                                    },
                                    tag and {
                                        n = G.UIT.R,
                                        config = { align = "cl" },
                                        nodes = {
                                            { n = G.UIT.T, config = { text = localize("ph_or_sp"), colour = G.C.UI.TEXT_LIGHT, scale = 0.4 } },
                                            { n = G.UIT.O, config = { id = "tag_sprite", object = tag_sprite } },
                                            tag_preview_ui,
                                        }
                                    },
                                },
                            },
                        }
                    } }
                },
                G.round_eval:get_UIE_by_ID("next_ante_preview"))
            if choice ~= "Boss" then
                G.round_eval:add_child({ n = G.UIT.B, config = { w = 0.25, h = 0 } },
                    G.round_eval:get_UIE_by_ID("next_ante_preview"))
            end
        end
    end
end

local evaluate_round_hook = G.FUNCS.evaluate_round
function G.FUNCS.evaluate_round()
    evaluate_round_hook()
    if G.GAME.blind_on_deck == "Boss" then
        G.E_MANAGER:add_event(Event({
            func = function()
                local random_state = copy_table(G.GAME.pseudorandom)
                G.round_eval:add_child(
                    {
                        n = G.UIT.C,
                        config = { r = 0.1, colour = G.C.BLACK, emboss = 0.05 },
                        nodes = {
                            { n = G.UIT.R, config = { padding = 0.1 },                          nodes = { { n = G.UIT.T, config = { text = localize("ph_next_ante"), colour = G.C.UI.TEXT_LIGHT, scale = 0.5 } } } },
                            { n = G.UIT.R, config = { id = "next_ante_preview", padding = 0.1 } },
                        }
                    },
                    G.round_eval:get_UIE_by_ID("eval_bottom"))
                create_ante_preview()
                G.GAME.pseudorandom = random_state
                return true
            end
        }))
    end
end
