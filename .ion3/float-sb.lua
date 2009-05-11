--
-- Example of floating toggleable statusbar
--

local floatsbscr=ioncore.find_screen_id(0)
local floatsb

floatsb=floatsbscr:attach_new{
    type="WStatusBar", 
    unnumbered=true, 
    sizepolicy='southeast', 
    template='[%mocp_state]%mocp_currenttime/%mocp_totaltime : %mocp_songtitle - %mocp_artist (%mocp_album) %mocp_bitrate|%mocp_rate', 
    passive=true, 
    level=2
}

local function toggle_floatsb()
    floatsbscr:set_hidden(floatsb, 'toggle')
end

local function toggle_statusbar()
   local sbar=ioncore.region_list'WStatusBar'[1]
   if sbar then
        sbar:rqclose()
   elseif mod_statusbar then
        dopath'cfg_statusbar'
   else
        dopath'mod_statusbar'
   end
end

ioncore.defbindings("WScreen", {
    kpress(META.."D", toggle_floatsb),
    kpress(META.."B", toggle_statusbar)
})

