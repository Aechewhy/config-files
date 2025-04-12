--- STEAMODDED HEADER
--- MOD_NAME: Buddies PACK Z
--- MOD_ID: boz_deck_Z
--- PREFIX: boz
--- MOD_AUTHOR: [Scruby, Gatler, DoubleV]
--- MOD_DESCRIPTION: Various card skins From Toriyama Influnced series! and smiling friends :)
--- LOADER_VERSION_GEQ: 1.0.0
--- VERSION: 1.0.1
--- BADGE_COLOR: FF3800 

local atlas_key = 'boz_atlas' -- Format: PREFIX_KEY
-- See end of file for notes
local atlas_path = 'boz_lc.png' -- Filename for the image in the asset folder
local atlas_path_hc = 'boz_hc.png' -- Filename for the high-contrast version of the texture, if existing

local suits = {'hearts', 'clubs', 'diamonds', 'spades'} -- Which suits to replace
local ranks = {'Jack', 'Queen', "King", "Ace"} -- Which ranks to replace

local descriptions = {'Smiling Friends', 'Super Mario Bros. Z', 'Dragon Ball Z', 'Chrono Trigger'} -- English-language description, in order of suits

-----------------------------------------------------------
-- You should only need to change things above this line --
-----------------------------------------------------------

-- Registers the mod icon
SMODS.Atlas { -- modicon
  key = 'modicon',
  px = 32,
  py = 32,
  path = 'modicon.png'
}

SMODS.Atlas{  
    key = atlas_key..'_lc',
    px = 71,
    py = 95,
    path = atlas_path,
    prefix_config = {key = false}, -- See end of file for notes
}

if atlas_path_hc then
    SMODS.Atlas{  
        key = atlas_key..'_hc',
        px = 71,
        py = 95,
        path = atlas_path_hc,
        prefix_config = {key = false}, -- See end of file for notes
    }
end

for i, suit in ipairs(suits) do
    SMODS.DeckSkin{
        key = suit.."_skin",
        suit = suit:gsub("^%l", string.upper),
        ranks = ranks,
        lc_atlas = atlas_key..'_lc',
        hc_atlas = (atlas_path_hc and atlas_key..'_hc') or atlas_key..'_lc',
        loc_txt = {
            ['en-us'] = descriptions[i]
        },
        posStyle = 'deck'
    }
end

-- Notes:

-- The current version of Steamodded has a bug with prefixes in mods including `DeckSkin`s.
-- By manually including the prefix in the atlas' key, this should keep the mod functional
-- even after this bug is fixed.
