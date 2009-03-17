
-- panel.lua: schedule notification script
--
-- You can schedule some messages to show up in the statusbar at
-- specified times.
-- 
-- Syntax:
-- y <year> <month> <date> <hour> <minute> <message>
--      or
-- m <month> <date> <hour> <minute> <message>
--      or
-- d <date> <hour> <minute> <message>
--      or
-- <hour> <minute> <message>
--
-- Current year/month/date will be used if you do not specify one. Messages
-- need not be within quotes. Some examples follow:
--
-- Example:
-- y 2005 4 1 2 0 "April fool!!"    --> 1st April, 2005, 2 am
-- m 4 5 2 0 "Some message"         --> 5th April of the current year, 2 am
-- d 5 2 0 "Other message"          --> 5th of the current month and year, 2 am
-- 20 0 Last message                --> 8 pm of today
--
-- Note:
-- The script now saves notification information in a file in the userdir
-- (usually ~/.ion3/schedule_save.lua). So the notifications stay after a
-- restart.
--
-- Author:
-- Sadrul Habib Chowdhury (Adil)
-- imadil at gmail dot com

if not mod_statusbar then return end

--
-- how often should the script check for scheduled messages?
--

if not panel then
  panel = {
    interval = 60 * 1000,   -- check every minute
    save_filename = "panel_save.lua",
	save_historyname = "panel_history",

	-- disk usage settings
   	template = "[%mpoint: %avail (%availp) free] ",
   	fslist = { "/", "/home", "/mnt/file"},
   	separator = " ",
  }
end

local timer = nil       -- the timer
local list = nil        -- doubly linked list of messages

--
-- extract the first token
--
function panel.get_token(str)
    local bg, fn
    bg, fn = string.find(str, "%w+%s+")
    return string.gsub(string.sub(str, bg, fn), "%s+", ""),
            string.sub(str, fn+1)
end

function math.round(num, idp)
   local mult = 10^(idp or 0)
   return math.floor(num  * mult + 0.5) / mult
end

function guess_mem_unit(amount)
   amount = tonumber(amount)
   if (amount < 1024) then
      return amount .. "k"
   elseif (amount >= 1024) and (amount < 1048576) then
      return math.round((amount / 1024), 0) .. "M"
   elseif (amount > 1048576) then
      return math.round((amount / 1048576), 1) .. "G"
   end
end

function panel.get_df()
   local df_table = {}
   local f = io.popen('df -k', 'r')
   if (f == nil) then return nil end
   f:read("*line") -- skip header line
   local s = f:read("*a")
   f:close()
   local i = 0
   while (i < string.len(s)) do
      local j, fsname, fssize, fsused, fsavail, fsusedp, mpoint
      i, j, fsname, fssize, fsused, fsavail, fsusedp, mpoint
	 = string.find(s, "(/%S+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%%?%s(%S+)\n",
		       i)
      if (i == nil) then return nil end
      df_table[mpoint] = { mpoint=mpoint,
	                   fs=fsname,
	                   size=guess_mem_unit(tonumber(fssize)),
			   used=guess_mem_unit(tonumber(fsused)),
			   avail=guess_mem_unit(tonumber(fsavail)),
			   usedp=tonumber(fsusedp),
			   availp=((100 - tonumber(fsusedp)) .. "%") }
      i = j+1
   end
   return df_table
end

function panel.update_df()
   local t = panel.get_df()
   if (t == nil) then return nil end
   local df_str = ""
   for i=1, #panel.fslist do
      local s = string.gsub(panel.template, "%%(%w+)",
			    function (arg)
			       if (t[panel.fslist[i]] ~= nil) then
				  return t[panel.fslist[i]][arg]
			       end
			       return nil
			    end)
      df_str = df_str .. panel.separator .. s
   end
   df_str = string.sub(df_str, #panel.separator + 1)

	disk = df_str	

   if statusd ~= nil then
   		statusd.inform("df", df_str)
		statusd.indorm("disk", disk)
   		--df_timer:set(settings.update_interval, update_df)
   end

   return df_str
end


--
-- show the notification when scheduled
--
function panel.notify()
    local l = list
    local time = os.time()
    if l and time > l.time then

        io.stderr:write("schedule: " .. l.message .. "\n")
		local output = "TODO: " .. l.message
        mod_statusbar.inform("panel", output)
        mod_statusbar.inform("panel_hint", "important")
        mod_statusbar.update()

		io.popen('play ~/desktop/ring/iPhoneRingtone.mp3', 'r')

        list = l.next
        if list then
            list.prev = nil
        end
        l = nil
        panel.save_file()
    end

    timer:set(panel.interval, panel.notify)
end

--
-- very hackish
--
function panel.insert_into_list(time, message)
    local l = list
    local t = nil

    if os.time() > time then return false end

    if l == nil then
        l = {}
        l.prev = nil
        l.next = nil
        l.time = time
        l.message = message
        list = l
        return true
    end

    while l do
        if l.time > time then
            l = l.prev
            break
        end

        if l.next then
            l = l.next
        else
            break
        end
    end

    t = {}
    t.time = time
    t.message = message

    if l == nil then
        list.prev = t
        t.next = list
        t.prev = nil
        list = t
    else
        t.next = l.next
        t.prev = l
        l.next = t
    end
    return true
end

--
-- add messages in the queue
--
function panel.add_message(mplex, str)
    local token = nil
    local tm = os.date("*t")

    token, str = panel.get_token(str)

    if token == "y" then
        tm.year, str = panel.get_token(str)
        tm.month, str = panel.get_token(str)
        tm.day, str = panel.get_token(str)
        tm.hour, str = panel.get_token(str)
    elseif token == "m" then
        tm.month, str = panel.get_token(str)
        tm.day, str = panel.get_token(str)
        tm.hour, str = panel.get_token(str)
    elseif token == "d" then
        tm.day, str = panel.get_token(str)
        tm.hour, str = panel.get_token(str)
    else
        tm.hour = token
    end

    tm.min, str = panel.get_token(str)

    if panel.insert_into_list(os.time(tm), str) then
        mod_query.message(mplex, "Notification \"" .. str .. "\" scheduled at " ..
                        os.date("[%a %d %h %Y] %H:%M", os.time(tm)))
        panel.save_file()
		panel.save_history()
    else
        mod_query.message(mplex, "dude, can't schedule notification for past!")
    end
end

function panel.ask_message(mplex)
    mod_query.query(mplex, TR("Schedule notification:"), nil, panel.add_message, 
            nil, "schedule")
end




local iwinfo_timer
local iwinfomation

function panel.get_iwinfo_iwcfg()
	local f = io.open('/proc/net/wireless', 'r')
	if not f then
		return
	end
-- first 2 lines -- headers
	f:read('*l')
	f:read('*l')
-- the third line has wifi info
	local s = f:read('*l')
	f:close()
	local st, en, iface = 0, 0, 0
	if not s then
		return
	end
	st, en, iface = string.find(s, '(%w+):')
	local f1 = io.popen("/sbin/iwconfig " .. iface)
	if not f1 then
		return
	else
		local iwOut = f1:read('*a')
		f1:close()
		st,en,proto = string.find(iwOut, '(802.11[%-]*%a*)')
		st,en,ssid = string.find(iwOut, 'ESSID[=:]"([%w+%s*-]*)"', en)
		st,en,bitrate = string.find(iwOut, 'Bit Rate[=:]([%s%w%.]*%/%a+)', en)
		bitrate = string.gsub(bitrate, "%s", "")
		st,en,linkq = string.find(iwOut, 'Link Quality[=:](%d+%/%d+)', en)
		st,en,signal = string.find(iwOut, 'Signal level[=:](%-%d+)', en)
		st,en,noise = string.find(iwOut, 'Noise level[=:](%-%d+)', en)

		return proto, ssid, bitrate, linkq, signal, noise
	end
end

function panel.update_iwinfo()
	local proto, ssid, bitrate, linkq, signal, noise = panel.get_iwinfo_iwcfg()

-- In case get_iwinfo_iwcfg doesn't return any values we don't want stupid lua
-- errors about concatenating nil values.
	ssid = ssid or "N/A"
	bitrate = bitrate or "N/A"
	linkq = linkq or "N/A"
	signal = signal or "N/A"
	noise = noise or "N/A"
	proto = proto or "N/A"

	iwinformation = "Wireless Network: " .. ssid.." "..bitrate.." "..linkq.." "..signal.."/"..noise.."dBm "..proto
	--[[statusd.inform("iwinfo_cfg", ssid.." "..bitrate.." "..linkq.." "..signal.."/"..noise.."dBm "..proto)
	statusd.inform("iwinfo_ssid", ssid)
	statusd.inform("iwinfo_bitrate", bitrate)
	statusd.inform("iwinfo_linkq", linkq)
	statusd.inform("iwinfo_signal", signal)
	statusd.inform("iwinfo_noise", noise)
	statusd.inform("iwinfo_proto", proto)
	iwinfo_timer:set(statusd_iwinfo.interval, update_iwinfo)
	--]]
	
	return iwinformation
end



-- 
-- show the scheduled notifications
--
function panel.show_all(mplex)
    local l = list
	local d = disk

    local output = "" 

	-- Add weather forecast
	if WeatherMonitor.get_weather() ~= nil then	
		output = output .. "Weather:    " .. WeatherMonitor.get_weather() .. "\n\n"
	end

	-- Add wireless network status
	--if panel.update_iwinfo() ~= nil then
	--	output = output .. iwinformation .. "\n\n"
	--end

	-- Add disk usage report
	
	local disk = panel.update_df()
	if disk ~= nil then
		output = output .. "Disk Usage:  " .. disk .. "\n\n"
	end

	--output = output .. "List of scheduled notifications:"
    while l do
        output = output .. "\n" .. os.date("[%a %d %h %Y] %H:%M", l.time) ..
                        " => " .. l.message
        l = l.next
    end
    mod_query.message(mplex, output)
end

--
-- save in file
--
function panel.save_file()
    if not list then return end
    local t = ioncore.get_paths()    -- saving the file in userdir
    local f = io.open(t.userdir .."/".. panel.save_filename, "w")
    if not f then return end

    local l = list
    while l do
        f:write("panel.insert_into_list("..l.time..", \""..l.message.."\")\n")
        l = l.next
    end
    f:close()
end

--
-- save in history file
--
function panel.save_history()
    if not list then return end
    local t = ioncore.get_paths()    -- saving the history in userdir
    local f = io.open(t.userdir .."/".. panel.save_historyname, "w")
    if not f then return end

    local l = list
    while l do
        f:write("panel.insert_into_list("..l.time..", \""..l.message.."\")\n")
        l = l.next
    end
    f:close()
end

function panel.get_history(mplex)

    local output = "" 

	output = output .. "List of scheduled notifications:"
	local t = ioncore.get_paths()
	local h = io.open(t.userdir .. "/" .. panel.save_historyname, "r")
	if not h then return end
	local s = h:read("*all")
	h.close()
	if s ~= nil then	
		output = output .. s
	end
    mod_query.message(mplex, output)
end
--
-- clear notification
--
function panel.clear_schedule(mplex)
	mod_statusbar.inform("panel", "")
    mod_statusbar.inform("panel_hint", "")
    mod_statusbar.update()
end

dopath(panel.save_filename, true)    -- read any saved notifications
timer = ioncore.create_timer()
timer:set(panel.interval, panel.notify)
mod_statusbar.inform("panel", "")

--
-- the key bindings
--
--[[
defbindings("WMPlex", {
    -- you can change the key bindings to your liking
    --kpress(MOD1.."F5", "panel.ask_message(_)"),
    kpress(SHIFT.."F9", "panel.ask_message(_)"),
    kpress(META.."Shift+F5", function ()  -- clear notification
                mod_statusbar.inform("schedule", "")
                mod_statusbar.inform("schedule_hint", "")
                mod_statusbar.update()
            end),
    kpress(META.."Control+F5", "panel.show_all(_)"),
})
--]]
