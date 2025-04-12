--- STEAMODDED HEADER
--- MOD_NAME: MarvelUniverseBalatroMod
--- MOD_ID: MarvelUniverseBalatroMod
--- MOD_AUTHOR: [ztgarrett]
--- MOD_DESCRIPTION: Marvel planet cards

--- PRIORITY: -100
--- BADGE_COLOR: ED1D24
--- DISPLAY_NAME: Marvel Universe
--- VERSION: 1.0.0

----------------------------------------------
------------MOD CODE -------------------------

-- adding badge text
function SMODS.current_mod.process_loc_text()
    local badge_text = {
        k_space_station = 'Space Station',
        k_realm = 'Realm',
        k_universe = 'Universe',
        k_plane = 'Plane',
    }
    for k, v in pairs(badge_text) do
        SMODS.process_loc_text(G.localization.misc.dictionary, k, badge_text, k)
    end
end

-- creating badges
local get_badge = function(self, card, badges, badge_name)
    return create_badge(localize(badge_name), get_type_colour(self or card.config, card), nil, 1.2)
end

local badge_space_station = function(self, card, badges)
    badges[#badges + 1] = get_badge(self, card, badges, 'k_space_station')
end

local badge_realm = function(self, card, badges)
    badges[#badges + 1] = get_badge(self, card, badges, 'k_realm')
end

local badge_universe = function(self, card, badges)
    badges[#badges + 1] = get_badge(self, card, badges, 'k_universe')
end

local badge_plane = function(self, card, badges)
    badges[#badges + 1] = get_badge(self, card, badges, 'k_plane')
end

-- consumable attributes
local consumables = {
    c_mercury = {
        name = 'Knowhere',
        badge = badge_space_station,
    },
    c_venus = {
        name = 'Sakaar',
    },
    c_earth = {
        name = 'Battleworld',
    },
    c_mars = {
        name = 'Ego',
    },
    c_jupiter = {
        name = 'Asgard',
        badge = badge_realm,
    },
    c_saturn = {
        name = 'Vormir',
    },
    c_uranus = {
        name = 'Xandar',
    },
    c_neptune = {
        name = 'Archeopia',
    },
    c_pluto = {
        name = 'Asteriod M',
        badge = badge_space_station,
    },
    c_planet_x = {
        name = 'The Negative Zone',
        badge = badge_universe,
    },
    c_ceres = {
        name = 'The White Hot Room',
        badge = badge_realm,
    },
    c_eris = {
        name = 'The House of Ideas',
        badge = badge_plane,
    },
    c_black_hole = {
        name = 'The Multiverse',
    },
}

SMODS.Atlas{
    key = "MarvelTarot",
    path = "Tarots.png",
    px = 71,
    py = 95,
}

-- update consumable text and badges
local copy_loc = function(self)
    local target_text = G.localization.descriptions[self.set][self.key].text
    SMODS.Consumable.process_loc_text(self)
    G.localization.descriptions[self.set][self.key].text = target_text
end

local get_consumable_obj = function(key, consumable)
    local consumable_obj = {
        atlas = "MarvelTarot",
        process_loc_text = copy_loc,
        generate_ui = 0,
        loc_txt = {name = consumable.name}
    }
    if consumable.badge then
        consumable_obj.set_card_type_badge = consumable.badge 
    end

    return consumable_obj
end

for key, consumable in pairs(consumables) do
    SMODS.Consumable:take_ownership(key, get_consumable_obj(key, consumable))
end

-- set the boosters spritesheet
SMODS.Atlas{
    key = "Booster",
    path = "boosters.png",
    px = 71,
    py = 95,
    raw_key = true,
}

-- replace the Astronomer's card
SMODS.Atlas{
    key = "Jokers",
    path = "Jokers.png",
    px = 71,
    py = 95
}
SMODS.Joker:take_ownership('j_astronomer', {
    atlas = "Jokers"
})

-- modicon
SMODS.Atlas {
    key = 'modicon',
    px = 34,
    py = 34,
    path = 'modicon.png'
}

----------------------------------------------
------------MOD CODE END----------------------