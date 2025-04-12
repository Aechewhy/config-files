function SMODS.current_mod.config_tab()
    return {
        n = G.UIT.ROOT,
        config = { r = 0.1, colour = G.C.BLACK, emboss = 0.05 },
        nodes = { {
            n = G.UIT.C,
            config = { align = "ct" },
            nodes = {
                {
                    n = G.UIT.R,
                    nodes = { create_toggle({
                        ref_table = SMODS.Mods.AntePreview.config,
                        ref_value = "custom_UI",
                        label = localize("b_AntePreview_custom_UI"),
                    }) }
                },
            }
        } }
    }
end

return {
    custom_UI = true,
}
