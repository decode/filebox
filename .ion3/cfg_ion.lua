--
-- Ion main configuration file
--
-- This file only includes some settings that are rather frequently altered.
-- The rest of the settings are in cfg_ioncore.lua and individual modules'
-- configuration files (cfg_modulename.lua).
--

-- Set default modifiers. Alt should usually be mapped to Mod1 on
-- XFree86-based systems. The flying window keys are probably Mod3
-- or Mod4; see the output of 'xmodmap'.
   META="Mod4+"
   ALTMETA="Mod1+"
   SHIFT="Shift+"
   CTRL="Control+"

-- Terminal emulator
--XTERM="xterm"

-- Debian sets the META and ALTMETA keys in /etc/default/ion3.
--dopath("cfg_debian")

-- Some basic settings
ioncore.set{
    -- Maximum delay between clicks in milliseconds to be considered a
    -- double click.
    --dblclick_delay=250,

    -- For keyboard resize, time (in milliseconds) to wait after latest
    -- key press before automatically leaving resize mode (and doing
    -- the resize in case of non-opaque move).
    --kbresize_delay=1500,

    -- Opaque resize?
    --opaque_resize=false,

    -- Movement commands warp the pointer to frames instead of just
    -- changing focus. Enabled by default.
    --warp=true,
}

dopath("cfg_defaults")

-- cfg_ioncore contains configuration of the Ion 'core'
--dopath("cfg_ioncore")

-- Load some kludges to make apps behave better.
--dopath("cfg_kludges")

-- Load some modules. Disable the loading of cfg_modules by commenting out 
-- the corresponding line with -- if you don't want the whole default set 
-- (everything except mod_dock). Then uncomment the lines for the modules
-- you want. 
--dopath("cfg_modules")
--dopath("mod_query")
--dopath("mod_menu")
--dopath("mod_tiling")
--dopath("mod_statusbar")
--dopath("mod_dock")
--dopath("mod_sp")

-- Deprecated.
dopath("cfg_user", true)

dopath("statusd_volume")
dopath("statusd_netmon")
--dopath("statusd_netmon_eth")
dopath("statusd_laptopstatus")
--dopath("statusd_xmmsip")
dopath("statusd_iface")
dopath("statusd_cpustat")
dopath("statusd_meminfo")
dopath("statusd_sysmon")
dopath("statusd_panel")
dopath("statusd_df")
--dopath("statusd_nmaild")
dopath("statusbar_workspace")
--dopath("statusd_mpd")
dopath("statusd_mocp")
dopath("statusd_nmaild")
--dopath("statusd_fortune")
dopath("statusd_flashing")
dopath("statusd_ticker")

dopath("histcompl")
dopath("exec_show")
--dopath("min_tabs")
dopath("rss_feed_jjh")
--dopath("ctrl_volume")
dopath("weathercn")
--dopath("statusd_stock")
dopath("show_submap")
dopath("bindsearch")
--dopath("statusbar_act")

dopath("statusd_mcpu")
