-- $Id: look_tibi.lua 63 2006-11-14 15:20:59Z tibi $

-- version : 0.1
-- date    : 2006-11-14
-- author  : Tibor Cs√∂g√∂r <tibi@tiborius.net>

-- This style highlights active elements with an `accent' color.  Bright and
-- dimmed variants emphasize the level of importance.  The corresponding neutral
-- colors are (roughly) the non-saturated versions.

-- The author likes the color scheme `gold' best, however, feel free to
-- experiment with the accent color(s).

-- This software is in the public domain.


-- color configuration ---------------------------------------------------------

-- gold
--[[
 local my_accent_color_bright = "lightgoldenrod1"
 local my_accent_color_normal = "gold1"
 local my_accent_color_dimmed = "gold2"
 local my_accent_color_dark   = "gold3"
--]]

-- green
--[[
local my_accent_color_bright = "#c2ffc2"
local my_accent_color_normal = "palegreen1"
local my_accent_color_dimmed = "palegreen2"
local my_accent_color_dark   = "palegreen3"
--]]

-- blue
----[[
 local my_accent_color_bright = "lightblue1"
-- local my_accent_color_normal = "#c0c6f9"
 local my_accent_color_normal = "skyblue1"
 local my_accent_color_dimmed = "skyblue2"
 local my_accent_color_dark   = "skyblue3"
--]]

-- plum
--[[
 local my_accent_color_bright = "#ffd3ff"
 local my_accent_color_normal = "plum1"
 local my_accent_color_dimmed = "plum2"
 local my_accent_color_dark   = "plum3"
--]]

--------------------------------------------------------------------------------


-- neutral colors
local my_neutral_color_normal = "grey85"
local my_neutral_color_dimmed = "grey70"
local my_neutral_color_dark   = "grey20"


if not gr.select_engine("de") then return end

de.reset()

de.defstyle("*", {
    padding_pixels = 0,
    spacing = 0,
    foreground_colour = "black",
    background_colour = my_accent_color_bright,
    highlight_pixels = 1,
    highlight_colour = "black",
    shadow_pixels = 1,
    shadow_colour = "black",

    border_style = "elevated",
    --border_style = "groove",
    --border_style = "inlaid",
    --border_style = "ridge",

    --透明背景
    transparent_background = true,
})

de.defstyle("frame", {
    ---based_on = "*",
    background_colour = "black",
})

de.defstyle("frame-floating", {
    based_on = "frame",
    padding_pixels = 0,
    highlight_pixels = 3,
    highlight_colour = my_neutral_color_normal,
    shadow_pixels = 3,
    shadow_colour = my_neutral_color_normal,
    de.substyle("active", {
    	highlight_colour = my_accent_color_normal,
        shadow_colour = my_accent_color_normal,
    }),
})

de.defstyle("frame-tiled", {
    based_on = "frame",
    -- 框体的空间
    spacing = 2,
    padding_pixels = 1,
    highlight_pixels = 1,
    highlight_colour = my_neutral_color_dark,
    shadow_pixels = 1,
    shadow_colour = my_neutral_color_dark,
    de.substyle("active", {
	padding_colour = my_accent_color_dark,
    	highlight_colour = my_accent_color_normal,
        shadow_colour = my_accent_color_normal,
    }),
})

de.defstyle("tab", {
    based_on = "*",
    spacing = 1,
    padding_pixels = 2,
    highlight_pixels = 0,
    shadow_pixels = 0,
    foreground_colour = "black",
    background_colour = my_neutral_color_dimmed,
    text_align = "center",
    font = "-*-helvetica-bold-r-normal-*-10-*-*-*-*-*-*-*",
    de.substyle("active-selected", {
        background_colour = my_accent_color_normal,
     }),
    de.substyle("active-unselected", {
        background_colour = my_accent_color_dark,
	--background_colour = "#d8d8d8",
        shadow_colour = "#a1a1a1",
        highlight_colour = "#ffffff",
        foreground_colour = "#000000",
    }),
    de.substyle("inactive-selected", {
        background_colour = my_neutral_color_normal,
    }),
})

de.defstyle("input-edln", {
    --based_on = "*",
    padding_pixels = 2,

    foreground_colour = "#eeeeff",
    --foreground_colour = "white",

    background_colour = "#34639f",
    --background_colour = my_accent_color_bright,

    highlight_pixels = 1,
    --highlight_colour = "#9999bb",
    highlight_colour = my_accent_color_dark,

    shadow_pixels = 1,
    --shadow_colour = "#9999bb",
    shadow_colour = my_accent_color_dark,

    font ="-*-lucidatypewriter-medium-r-*-*-12-*-*-*-*-*-*-*",
    --font ="-*-lucidatypewriter-medium-r-*-*-10-*-*-*-*-*-*-*",
    de.substyle("*-cursor", {
        foreground_colour = my_accent_color_bright,
        background_colour = "black",
    }),
    de.substyle("*-selection", {
        foreground_colour = "black",
        background_colour = my_accent_color_dimmed,
    }),
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
    foreground_colour = "white",
    font ="-*-helvetica-medium-r-*-*-10-*-*-*-*-*-*-*",

    de.substyle("important", {
        foreground_colour = "green",
    }),

    de.substyle("critical", {
        foreground_colour = "red",
    }),
})

de.defstyle("tab-menuentry", {
    based_on = "*",
    text_align = "left",
    padding_pixels = 4,
    spacing = 0,
    shadow_pixels = 0,
    highlight_pixels = 0,
    font = "-*-helvetica-medium-r-normal-*-10-*-*-*-*-*-*-*",
    foreground_colour = "black",
    background_colour = my_accent_color_bright,
    de.substyle("inactive-selected", {
        background_colour = my_accent_color_dimmed,
    }),
})

de.defstyle("tab-frame", {
    based_on = "tab",
    -- 有消息提示的tab标签
    de.substyle("*-*-*-*-activity", {
        shadow_colour = "#401010",
        highlight_colour = "#eec0c0",
        background_colour = "#990000",
        foreground_colour = "#eeeeee",
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

gr.refresh()

-- EOF
