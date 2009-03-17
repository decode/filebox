-- $Id: statusd_cpustat.lua 58 2006-11-14 11:06:49Z tibi $

-- statusd_cpustat.lua -- CPU monitor for Ion3's statusbar

-- version : 0.1
-- date    : 2006-11-14
-- author  : Tibor Csögör <tibi@tiborius.net>

-- Shows the CPU utilization of the system similiar to top(1).
-- This script depends on the /proc filesystem and thus only works on Linux.
-- Tested with kernel 2.6.16.

-- Configuration:
-- The following placeholders (with a "cpustat_" prefix) can be used in the
-- statusbar template: `user', `nice', `idle', `system', `iowait', `irq',
-- `softirq' and `steal'.  In addition, `system_adj' sums up the last 5 fields.
-- For a compact output simply use the `cpustat' placeholder.

-- This software is in the public domain.

--------------------------------------------------------------------------------


local defaults = {
   update_interval = 5000, -- 5 second

   important = {
		cpustat_user = 50,
   },

   critical = {
		cpustat_user = 70,
   }
}

local settings
if statusd ~= nil then
    settings = table.join (statusd.get_config ("cpustat"), defaults)
else
    settings = defaults
end

local last_stat, current_stat
local last_uptime, current_uptime = 0, 0
local first_run = true

function math.round(num, idp)
   local mult = 10^(idp or 0)
   return math.floor(num  * mult + 0.5) / mult
end

-- this function reads stats from /proc/stat and /proc/uptime and calculates the
-- CPU time used in the measurement interval
local function get_cpustat()
   local f1, f2, s, s2
   f1 = io.open('/proc/stat', 'r')
   f2 = io.open('/proc/uptime', 'r')
   if ((f1 == nil ) or (f2 == nil)) then return nil end
   s = f1:read("*l")
   s2 = f2:read("*l")
   f1:close()
   f2:close()

   last_uptime = current_uptime
   local a1, a2 = string.match(s2, "(%d+)\.(%d+) %d")
   current_uptime = tonumber(a1 .. a2)
   local uptime_interv = current_uptime - last_uptime
   
   local t = { string.match(s, "cpu%s+(%d+) (%d+) (%d+) (%d+) (%d+) (%d+) " ..
			    "(%d+) (%d+)") }
   for i = 1, #t do
      t[i] = tonumber(t[i])
   end

   last_stat = current_stat
   current_stat = t
   if (first_run) then
      last_stat = t
      first_run = false
   end

   local c = {}
   for i = 1, #t do
      table.insert(c, math.round(((current_stat[i] - last_stat[i])
				  / uptime_interv) * 100))
   end

   -- adjusted system CPU time (= system + iowait + irq + softirq + steal)
   table.insert(c, math.round((((current_stat[2] - last_stat[2]) +
				(current_stat[5] - last_stat[5]) +
				(current_stat[6] - last_stat[6]) +
				(current_stat[7] - last_stat[7]) +
				(current_stat[8] - last_stat[8])) /
				  uptime_interv)
				 * 100))
   return c
end

local cpustat_timer
if statusd ~= nil then
    cpustat_timer = statusd.create_timer ()
end

--
-- Return a hint value for the given meter
--
local function get_hint(meter, val)
    local hint = "normal"
    local crit = settings.critical[meter]
    local imp = settings.important[meter]
    if crit and val > crit then
	hint = "critical"
    elseif imp and val > imp then
	hint = "important"
    end
    return hint
end

local function update_cpustat()
   local t = get_cpustat()
   if (t == nil) then return nil end

   if statusd ~= nil then
      statusd.inform("cpustat_user", string.format("%02d", t[1]) .. "%")
	  statusd.inform("cpustat_user_hint", get_hint("user", cpustatus_user))
      statusd.inform("cpustat_nice", t[2] .. "%")
      statusd.inform("cpustat_system", t[3] .. "%")
      statusd.inform("cpustat_system_adj", t[9] .. "%")
      statusd.inform("cpustat_idle", t[4] .. "%")
      statusd.inform("cpustat_iowait", t[5] .. "%")
      statusd.inform("cpustat_irq", t[6] .. "%")
      statusd.inform("cpustat_softirq", t[7] .. "%")
      statusd.inform("cpustat_steal", t[8] .. "%")
      statusd.inform("cpustat", string.format("%3d%% us,%3d%% sy,%3d%% ni",
					   t[1], t[9], t[3]))
      cpustat_timer:set(settings.update_interval, update_cpustat)
   end
end



update_cpustat()

-- EOF
