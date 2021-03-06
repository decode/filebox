
-- look_simpleblue.lua drawing engine configuration file for Ion.

if not gr.select_engine("de") then return end

de.reset()

de.defstyle("*", {
    shadow_colour = "black",
    highlight_colour = "black",
    background_colour = "#0f1f4f",
    foreground_colour = "#9f9f9f",
    padding_pixels = 0,
    highlight_pixels = 1,
    shadow_pixels = 1,

    --border_style = "elevated",
    --border_style = "groove",
    border_style = "inlaid",
    --border_style = "ridge",
   
    font = "-*-Microsoft Yahei-medium-r-normal-*-14-*-*-*-*-*-*-*",
    text_align = "center",
    transparent_background = true,
})

de.defstyle("frame", {
    based_on = "*",
    shadow_colour = "black",
    highlight_colour = "black",
    padding_colour = "black",
    background_colour = "black",
    foreground_colour = "#ffffff",
    padding_pixels = 0,
    highlight_pixels = 0,
    shadow_pixels = 0,
    de.substyle("active", {
        shadow_colour = "black",
        highlight_colour = "black",
        background_colour = "black",
        foreground_colour = "#ffffff",
    }),
})

de.defstyle("tab", {
    based_on = "*",
    --font = "-*-helvetica-medium-r-normal-*-12-*-*-*-*-*-*-*",
    font = "-*-Microsoft Yahei-medium-r-normal-*-12-*-*-*-*-*-*-*",
    --font = "-*-STHeiti-medium-r-normal-*-13-*-*-*-*-*-*-*",
    de.substyle("active-selected", {
        --shadow_colour = "white",
        --highlight_colour = "white",
        background_colour = "#3f3f3f",
        --foreground_colour = "#bfbfbf",
	foreground_colour = "white",
    }),
    de.substyle("active-unselected", {
        shadow_colour = "black",
        highlight_colour = "black",
        background_colour = "#0f1f4f",
        foreground_colour = "#9f9f9f",
    }),
    de.substyle("inactive-selected", {
        shadow_colour = "black",
        highlight_colour = "black",
        --background_colour = "#1f2f4f",
	background_colour = "#1f2f3f",
        foreground_colour = "#bfbfbf",
    }),
    de.substyle("inactive-unselected", {
        shadow_colour = "black",
        highlight_colour = "black",
        background_colour = "#0f1f4f",
        foreground_colour = "#9f9f9f",
    }),
    text_align = "center",
})

de.defstyle("tab-frame", {
    based_on = "tab",
    de.substyle("*-*-*-*-activity", {
        shadow_colour = "#907070",
        highlight_colour = "#907070",
        background_colour = "#990000",
        foreground_colour = "#eeeeee",
    }),
})

de.defstyle("tab-menuentry", {
    based_on = "tab",
    text_align = "left",
})

de.defstyle("tab-menuentry-big", {
    based_on = "tab-menuentry",
    --font = "-*-helvetica-medium-r-normal-*-17-*-*-*-*-*-*-*",
    font = "-*-Microsoft Yahei-medium-r-normal-*-12-*-*-*-*-*-*-*",
    padding_pixels = 7,
})

de.defstyle("input", {
    based_on = "*",
    shadow_colour = "black",
    highlight_colour = "black",
    background_colour = "#3f3f3f",
    foreground_colour = "white",
    padding_pixels = 1,
    highlight_pixels = 0,
    shadow_pixels = 0,
    border_style = "elevated",
    de.substyle("*-cursor", {
        background_colour = "white",
        foreground_colour = "#3f3f3f",
    }),
    de.substyle("*-selection", {
        background_colour = "black",
        foreground_colour = "white",
    }),
})

de.defstyle("input-menu", {
    based_on = "input",
    padding_pixels=0,
})

-- 状态栏
de.defstyle("stdisp", {
    --based_on = "*",
    -- 状态栏边框
    padding_pixels = 0,
    shadow_pixels = 0,
    highlight_pixels = 0,
    --background_colour = my_neutral_color_dark,
    background_colour = "black",
    foreground_colour = "grey",
    font ="-*-microsoft yahei-medium-r-*-*-12-*-*-*-*-*-*-*",

    de.substyle("important", {
        foreground_colour = "green",
    }),

    de.substyle("critical", {
        foreground_colour = "yellow",
    }),
})

de.defstyle("actnotify", {
    based_on = "*",
    padding_pixels = 4,
    highlight_pixels = 2,
    highlight_colour = my_accent_color_normal,
    shadow_pixels = 2,
    shadow_colour = my_accent_color_normal,
    background_colour = "red",
    foreground_colour = "white",
    font = "-*-helvetica-bold-r-normal-*-10-*-*-*-*-*-*-*",
})

--dopath("lookcommon_clean")

gr.refresh()

