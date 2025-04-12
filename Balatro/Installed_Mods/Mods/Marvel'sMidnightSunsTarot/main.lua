--- STEAMODDED HEADER
--- MOD_NAME: Marvel's Midnight Suns Tarot
--- MOD_ID: marvelsunstarot
--- PREFIX: marvelsunstarot
--- MOD_AUTHOR: [uXs]
--- MOD_DESCRIPTION: Replaces tarot cards with Marvel's Midnight Suns tarot cards
--- VERSION: 1.0.0
--- DEPENDENCIES: [malverk]

AltTexture({ -- Marvel's Midnight Suns Tarot
    key = 'marvelsunstarot_texture', -- alt_tex key
    set = 'Tarot', -- set to act upon
    path = 'Tarots-MarvelSuns.png', -- path of sprites
    loc_txt = { -- loc text name (NYI)
        name = 'Marvel\'s Midnight Suns',
        text = {'Tarot cards replaced by', 'Marvel\'s Midnight Suns cards'}
    }
})
TexturePack({ -- Marvel's Midnight Suns Tarot
    key = 'marvelsunstarot_pack', -- texpack key
    textures = { -- keys of AltTextures in this TexturePack
        'marvelsunstarot_texture',
    },
    loc_txt = {
        name = 'Marvel\'s Midnight Suns',
        text = {'Tarot cards replaced by', 'Marvel\'s Midnight Suns cards'}
    }
})