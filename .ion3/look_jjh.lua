--
-- look_blue, based on look-cleanviolet
-- 

if not gr.select_engine("de") then
    return
end

-- Clear existing styles from memory.
de.reset()

-- Base style
de.defstyle("*", {
    highlight_colour = "#eeeeff",
    shadow_colour = "#eeeeff",
    background_colour = "#9999bb",
    foreground_colour = "#444477",
    
    shadow_pixels = 1,
    highlight_pixels = 1,
    padding_pixels = 1,
    spacing = 0,
    border_style = "elevated",
    
    font = "-*-helvetica-medium-r-normal-*-12-*-*-*-*-*-*-*",
    text_align = "center",

    transparent_background = true,
})


de.defstyle("frame", {
    based_on = "*",
    padding_colour = "#aaaaaa",
    background_colour = "#000000",
})


de.defstyle("frame-tiled", {
    based_on = "frame",
    shadow_pixels = 0,
    highlight_pixels = 0,
    padding_pixels = 0,
    spacing = 1,
})


de.defstyle("tab", {
    based_on = "*",
    font = "-*-SimHei-medium-r-normal-*-13-*-*-*-*-*-*-*",
    de.substyle("active-selected", {
        shadow_colour = "#404679",
        highlight_colour = "#c0c6f9",
        background_colour = "#8086b9",
        foreground_colour = "#ffffff",
    }),
    de.substyle("active-unselected", {
        shadow_colour = "#a1a1a1",
        highlight_colour = "#ffffff",
        background_colour = "#e6e6e6",
        foreground_colour = "#000000",
    }),
    de.substyle("inactive-selected", {
	shadow_colour = "#a1a1a1",
        highlight_colour = "#ffffff",
        background_colour = "#e6e6e6",
        foreground_colour = "#000000",
    }),
    de.substyle("inactive-unselected", {
        shadow_colour = "#ffffff",
        highlight_colour = "#a1a1a1",
        background_colour = "#e6e6e6",
        foreground_colour = "#a0a0a0",
    }),
    text_align = "center",
})


de.defstyle("tab-menuentry", {
    based_on = "tab",
    text_align = "left",
    spacing = 1,
})


de.defstyle("tab-menuentry-big", {
    based_on = "tab-menuentry",
    font = "-*-helvetica-medium-r-normal-*-17-*-*-*-*-*-*-*",
    padding_pixels = 4,
})


de.defstyle("input", {
    based_on = "*",
    text_align = "left",
    spacing = 0,
    highlight_colour = "#9999bb",
    shadow_colour = "#9999bb",
    background_colour = "#34639f",
    foreground_colour = "#eeeeff",
    
    de.substyle("*-selection", {
        background_colour = "#9999ff",
        foreground_colour = "#333366",
    }),

    de.substyle("*-cursor", {
        background_colour = "#ccccff",
        foreground_colour = "#9999aa",
    }),
})

dopath("lookcommon_clean")
    
-- Refresh objects' brushes.
gr.refresh()
