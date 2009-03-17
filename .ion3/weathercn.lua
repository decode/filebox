-- weathercn.lua

-- weathercn.lua: an Ion3 applet for displaying weather information

-- INTRODUCTION
-- I discovered Ion last week, after reading an article on linux.com. I
-- installed it and, in a matter of a few hours, I decided to stick to
-- it. How can I say: I've been dreaming of a WM to be run from the
-- command line... and this is what Ion3 can do. And what a kind of a
-- command line! A Lua interpreter! I must confess I've never heard about
-- Lua before, and it was quite a surprise (I had the same feeling with
-- JavaScript some time ago).
-- I decided to write this applet mostly to learn and explore Lua,
-- especially for object-oriented programming.

-- ABOUT
-- This applet can be used to monitor the weather condition(s) of one or
-- more weather observation city(s). Data will be retrieved from
-- http://weather.noaa.gov and displayed in the statusbar.

-- USAGE
-- You need to dopath() this script (e.g. from cfg_ion3.lua):
-- dopath("weathercn")

-- - To monitor one city you can insert, in your cfg_statusbar.lua, within
-- mod_statusbar.launch_statusd{}, something like:
-- weathercn = {
--		city = "57957",
--		hour = "48",
-- }
-- In your template insert something like:
-- %weathercn_status

-- Here's the list of all available data:
-- %weathercn_status
-- %weathercn_statustidy
-- %weathercn_sCurrent
-- %weathercn_sFuture
-- %weathercn_futureT (The future temperature)
-- %weathercn_futureW (The future weather)

 
-- - If you want to monitor more citys you need to create a monitor
-- object for each one with the new_wm() function. After
-- dopath("weather") write something like:
-- mymonitor1 = new_wm("57957")
-- mymonitor2 = new_wm("57036")

-- You can create a new monitor also at run time. Get the Lua code prompt
-- (usually MOD1+F3) and run:
-- mymonitor3 = new_wm("57957")

-- Do not set any city in cfg_statusbar.lua, since that city would
-- be used by *all* monitors.
-- Each monitor will output the data either in %weater_meter_XXXX, where XXXX is
-- the city code (57957), and in %weather_meter.

-- CONFIGURATION
-- Default configuration values, that will apply to *all* monitors, can be
-- written in cfg_statusbar.lua in your ~/.ion3 directory.

-- Each monitor can be also configured at run-time.
-- For instance: if you are monitoring only one city, get the Lua code
-- prompt (usually MOD1+F3) and run:
-- WeatherMonitor.config.unit.tempC = "C"
-- or
-- WeatherMonitor.config.critical.tempC = "15"
-- You can save run-time configuration with the command:
-- WeatherMonitor.save_config()
-- This configuration will not overwrite the default city to be
-- monitored.

-- COMMANDS
-- Monitors are objects that export some public methods. You can use
-- these methods to change the state of the objects.
-- You can change configuration value and save them (see CONFIGURATION)
-- or issues some commands.

-- Suppose you have 2 monitors:
-- mon1 = new_wm("57127")
-- mon2 = new_wm("57036")
-- (Remember: in single mode the name of the object is WeatherMonitor.)

-- Get the Lua code prompt (usually MOD1+F3) and:
-- 1. to force one monitor to update the data:
-- mon1.update()

-- 2. to show the full report of the city:
-- mon2.show_data(_)

-- 3. to update data and show the report:
-- WeatherMonitor.update_and_show(_)

-- 4. to chnage city (only for run-time):
-- WeatherMonitor.set_city(_)

-- 5. to change one monitor configuration:
-- mon1.config.critical.tempC = "15"

-- Obviously you can create key-bindings to run these commands.

-- REVISIONS
-- 2007-01-22 first release

-- The city list:
-- Guilin 57957
-- Xi'An 57036
-- HanZhong 57127

function new_wm(city)
   local this = {
      config = {
	 city = city,
	 interval =30 * 60 * 1000,   -- check every 30 minutes
	 unit = {
	    tempC = "∞",
	    tempF = "F",
	    humidity = "%",
	    pressure = "hPa",
	    windspeed = "MPH",

	 },
	 -- Threshold information.  These values should likely be tweaked to
	 -- suit local conditions.
	 important = {
	    tempC = 10,
	    tempF = 50,
		lowT = 10,
		highT = 10,
		cWindLevel = 5,
	    humidity = 30,

	 },
	 critical = {
	    tempC = 26,
	    tempF = 78,
		lowT = 26,
		highT = 26,
		cWindLevel = 7,
	    humidity = 60,
	 },
      },
      status_timer = ioncore.create_timer(),
      url = "http://weather.china.com.cn/city/",

      -- 获取路径
      paths = ioncore.get_paths(),
      data = { 
	 timezone = tonumber(os.date("%z"))
      },
   }

   -- process configuration: 
   -- - config in cfg_statusbar.lua will overwrite default config
   -- - run-time configuration (to be saved at run-time with this.save_config())
   --    will overwrite default config but will be overwtitten by cfg_statusbar.lua
   this.process_config = function()
			    table.merge = function(t1, t2)
					     local t=table.copy(t1, false)
					     for k, v in pairs(t2) do
						t[k]=v
					     end
					     return t
					  end
				local c = ioncore.read_savefile("cfg_statusd")
      			if c.weathercn then 
	 				this.config = table.merge(this.config, c.weathercn)
      			end
			    if not this.config.city then
 					this.config.city = "57957" 
				end
				if not this.config.hour then
					this.config.hour = "48"
				end
			    local config = ioncore.read_savefile("cfg_weather_"..this.config.city)
			    if config then
			       this.config = table.merge(this.config, config)
			    end
			    config = ioncore.read_savefile("cfg_statusd")
			    if config.weather then
			       this.config = table.merge(this.config, config.weather)
			    end
			 end

   -- retrive data from server
   this.update_data = function()
                         -- wget options
                         -- -b  go into the background (otherwise it will hang ion startup 
                         --     until data file is download)
                         -- -o  output error log (specify filename if you want to save output)
						 -- -T the download timeout(second)
			 local command = "wget -T 1 -o /dev/null -O "..this.paths.sessiondir.."/"..this.config.city..".dat "..this.url..this.config.city.."_full.html"
				--local command = "wget -T 1 -o /dev/null -O ".."/home/home/Desktop/link.dat "..
			    	--this.url.."57957".."_full.html"

			 os.execute(command)
			 local f = io.open(this.paths.sessiondir .."/".. this.config.city..".dat", "r")
				--local f = io.open("/home/home/Desktop/link.dat", "r")
			 if not f then return end
			 local s=f:read("*all")
			 f:close()

			 if s ~=nil then
			 	this.raw_data = s
			 else
				this.data.status = "NaN"
			 end

			 os.execute("rm "..this.paths.sessiondir .."/".. this.config.city..".dat")
			--os.execute("rm ".."/home/home/Desktop/link.dat.dat")
		     end

   -- process retrived data and store them in this.data
   this.process_data = function()
			  local s = this.raw_data

				-- The name of the city
				--class="fb20">桂林</td>
			  local pCity = "class=\"fb20\">(.+)</td>"
			  --_, _, this.data.city = string.find(s, pCity)

				-- The format of the time
				--color="#000000">1月20日 夜间</font>
			  local pCurTime = "color=\"#000000\">(.+)</font>"
			  --_, _, this.data.cTime = string.find(s, "color=\"#000000\">(.-)</font>")

							-- The Format of the current weather
							--<tr>
                        		--	<td height="20">气温：6 ℃～9 ℃</td>
                      		--</tr>
                      		--<tr>
                        		--	<td height="20">风向：南风</td>
                      		--</tr>
                      		--<tr>
                        		--	<td height="20">风力：<3 级</td>
                      		--</tr>
			  local pTemp = "气温：(\-*%d+)%s℃～(\-*%d+)%s℃"
			  _, _, this.data.cHighT, this.data.cLowT = string.find(s, pTemp)

			  local pWindDir = "风向：([东南西北]+)风"
			  _, _, this.data.cWindDirection = string.find(s, pWindDir)
			  this.data.cWindDirection = this.trans_winddir(this.data.cWindDirection)

			  local pWindLevel = "风力：小于(%d+)%s级"
			  _, _, this.data.cWindLevel = string.find(s, pWindLevel)

				-- The Format of the weather forecast".."
				-- class="f12">24小时</td><td ... >小雨<img ... > － 阴<img ... ></td>
				-- <td ... >6 ℃</td>
				-- <td ... >9 ℃</td>
				-- <td ... >南风 <3 级</td>
			  	local pHour = "class=\"f12\">(%d+)小时</td>"

				local pWeather1 = "class=\"f12\">(.?.?.?.?.?.?)<img"
				_, _, this.data.cWeather1= string.find(s, pWeather1)
				this.data.cWeather1 = this.trans_weather(this.data.cWeather1)
				
				local pWeather2 = ">%s－%s(.?.?.?.?.?.?)<img"
				_, _, this.data.cWeather2= string.find(s, pWeather2)
				this.data.cWeather2 = this.trans_weather(this.data.cWeather2)

			  -- The current weather status
			  	local sub
			  	if this.data.cLowT ~= nil then
					sub = tonumber(this.data.cLowT) - tonumber(this.data.cHighT)
					if sub < 0 then
			  			this.data.sCurrent = string.format("%s'C~%s'C %s~%s %s<%s", this.data.cLowT, this.data.cHighT, this.data.cWeather1, this.data.cWeather2, this.data.cWindDirection, this.data.cWindLevel)
			  		else
						this.data.sCurrent = string.format("%s'C~%s'C %s~%s %s<%s", this.data.cHighT, this.data.cLowT, this.data.cWeather2, this.data.cWeather1, this.data.cWindDirection, this.data.cWindLevel)
					end
				else
					this.data.sCurrent = ""
				end

				local pTemperature = "class=\"f12\">(\-*%d+)%s℃</td>[%c%s]+"..
						"<td%salign=\"center\"%sbgcolor=\"#[%a%d]+\"%sclass=\"f12\">(\-*%d+)%s℃</td>"
				--_, _, this.data.highT, this.data.lowT = string.find(s, pTemperature)

				local pWind = "class=\"f12\">([东南西北]+)风%s<(%d+)%s级</td>"

				local pTD = "<td%salign=\"center\"%sbgcolor=\"#[%a%d]+\"%s"
				local pIMG ="%ssrc=\"[/_%a%d%p]+\"%salign=\"absmiddle\""

--[[			The total format:
                <tr>
                  <td height="22" align="center" bgcolor="#CAE6FF" class="f12">48小时</td>
                  <td align="center" bgcolor="#CAE6FF" class="f12">中雨<img src="/weathericons/s_4.gif" align="absmiddle"> － 小雨<img src="/weathericons/s_4.gif" align="absmiddle"></td>
                  <td align="center" bgcolor="#CAE6FF" class="f12">7 ℃</td>
                  <td align="center" bgcolor="#CAE6FF" class="f12">4 ℃</td>
                  <td align="center" bgcolor="#CAE6FF" class="f12">西南风 <3 级</td>
                </tr>
--]]
				
				local pStatusBase = "小时</td>[%c%s]+"..pTD..pWeather1..pIMG..pWeather2..pIMG..
						"></td>[%c%s]+"..pTD..pTemperature.."[%c%s]+"..pTD..pWind

				-- avaliable value: 24, 48, 72
				local pStatus = this.config.hour..pStatusBase

				_, _, this.data.weather1, this.data.weather2, this.data.lowT, this.data.highT, this.data.wind, this.data.windlevel =
						string.find(s, pStatus)

			 if this.data.level ~= nil then
					this.data.futureStep = string.format("(%s)", this.data.level)
			 end



			 if this.data.lowT ~=nil and this.data.highT ~= nil then
			  		this.data.futureT = string.format("%s'C~%s'C", this.data.lowT, this.data.highT)
			 else
					this.data.futureT = ""		
			 end
			
			 -- The future weather status
			 if this.data.weather1 ~= nil and this.data.weather2 ~= nil then
 			  		this.data.weather1 = this.trans_weather(this.data.weather1)
 			  		this.data.weather2 = this.trans_weather(this.data.weather2)		
			  		this.data.futureW = string.format("%s~%s", this.data.weather1, this.data.weather2)
					this.data.sFuture = string.format("(%s)%s %s", this.config.hour, this.data.futureT, this.data.futureW)
			 else
				this.data.futureW = ""
				this.data.sFuture = this.data.futureT
			 end

			 this.data.status = this.data.sCurrent.."    "..this.data.sFuture
			 this.data.statustidy =this.data.sCurrent

			  this.format_time()
    end

	this.get_hour = function(hour)
			local s = this.raw_data
			local pWeather1 = "class=\"f12\">(.?.?.?.?.?.?)<img"
			local pWeather2 = ">%s－%s(.?.?.?.?.?.?)<img"

			local pTemperature = "class=\"f12\">(\-*%d+)%s℃</td>[%c%s]+"..
				"<td%salign=\"center\"%sbgcolor=\"#[%a%d]+\"%sclass=\"f12\">(\-*%d+)%s℃</td>"

			local pWind = "class=\"f12\">([东南西北]+)风%s<(%d+)%s级</td>"

			local pTD = "<td%salign=\"center\"%sbgcolor=\"#[%a%d]+\"%s"
			local pIMG ="%ssrc=\"[/_%a%d%p]+\"%salign=\"absmiddle\""
			local pStatusBase = "小时</td>[%c%s]+"..pTD..pWeather1..pIMG..pWeather2..pIMG..
						"></td>[%c%s]+"..pTD..pTemperature.."[%c%s]+"..pTD..pWind

			-- avaliable value: 24, 48, 72
			local pStatus = hour..pStatusBase

			_, _, this.data.weather1, this.data.weather2, this.data.lowT, this.data.highT, this.data.wind, this.data.windlevel = string.find(s, pStatus)

			 local isLow = true
			 local sub
			 if this.data.lowT ~=nil and this.data.highT ~= nil then
					sub = tonumber(this.data.lowT) - tonumber(this.data.highT)
				if sub < 0 then
			  		this.data.futureT = string.format("%s'C~%s'C", this.data.lowT, this.data.highT)
				else
					isLow = false
					this.data.futureT = string.format("%s'C~%s'C", this.data.highT, this.data.lowT)
				end
			 else
					this.data.futureT = ""		
			 end
			
			 -- The future weather status
			 if this.data.weather1 ~= nil and this.data.weather2 ~= nil then
 			  		this.data.weather1 = this.trans_weather(this.data.weather1)
 			  		this.data.weather2 = this.trans_weather(this.data.weather2)
				if isLow ~= true then	
						this.data.futureW = string.format("%s~%s %s<%s", this.data.weather2, this.data.weather1, this.trans_winddir(this.data.wind), this.data.windlevel)
				else
						this.data.futureW = string.format("%s~%s %s<%s", this.data.weather1, this.data.weather2, this.trans_winddir(this.data.wind), this.data.windlevel)
				end
					this.data.sFuture = string.format("(%s)%s %s", hour, this.data.futureT, this.data.futureW)
				
			 else
				this.data.futureW = ""
				this.data.sFuture = this.data.futureT
			 end
			
			return this.data.sFuture
	end

	-- Transform chinese weather name to english short name	
	this.trans_weather = function(wName)
		local wSet = {}
		wSet["雨夹雪"] = "Sleet"
		wSet["小雨"] = "LRain" --"light rain"
		wSet["中雨"] = "MRain" --"moderate rain"
		wSet["阵雨"] = "Shower"
		wSet["阴"] = "Overcast"
		wSet["多云"] = "Cloudy"
		wSet["晴"] = "Clear"
		wSet["小雪"] = "LSnow" --"light snow"
		if wSet[wName] ~= nil then
			return wSet[wName]
		else
			return ""
		end
	end	

	-- Transform chinese wind direction name to english short name
	this.trans_winddir = function(wDir)
		local dSet = {}
		dSet["东"] = "E"
		dSet["南"] = "S" 
		dSet["西"] = "W"
		dSet["北"] = "N"
		dSet["东南"] = "WE"
		dSet["东北"] = "NE"
		dSet["西南"] = "SW"
		dSet["西北"] = "NW"
		if dSet[wDir] ~= nil then
			return dSet[wDir]
		else
			return ""
		end
	end

   -- format teh time string to get hh:mm
   this.format_time = function()
			 local time
			 if this.data.time then 
			    time = tonumber(this.data.time) + tonumber(this.data.timezone)
			 else return
			 end
			 if time > 2400 then 
			    time = tostring(time - 2400) 
			 end
			 if string.match(time, "^%d%d$") then 
			    time = "00"..time 
			 end
			 if string.match(time, "^%d%d%d$") then 
			    time = "0"..time 
			 end
			 this.data.time = tostring(time):gsub("(%d%d)(%d%d)","%1%:%2")
		      end

   -- get threshold information 
   this.get_hint = function(meter, val)
		      local hint = "normal"
		      local crit = this.config.critical[meter]
		      local imp = this.config.important[meter]
		      if crit and tonumber(val) > crit then
			 hint = "critical"
		      elseif imp and tonumber(val) > imp then
			 hint = "important"
		      end
		      return hint
		   end

   -- get the unit of each meter
   this.get_unit = function(meter)
		      local unit = this.config.unit[meter]
		      if unit then return unit end
		      return ""
		   end

   -- update information for mod_statusbar
   this.notify = function()
		    for i,v in pairs(this.data) do
		       mod_statusbar.inform("weathercn_"..i.."_"..this.config.city.."_hint", this.get_hint(i, v))
		       mod_statusbar.inform("weathercn_"..i.."_hint", this.get_hint(i, v))
		       if not v then v = "N/A" end
		       mod_statusbar.inform("weathercn_"..i.."_"..this.config.city, v..this.get_unit(i))
		       mod_statusbar.inform("weathercn_"..i, v..this.get_unit(i))
		    end
		    mod_statusbar.update()
		 end
   --
   -- some public methods
   --
   -- save object state (each monitor will store its configuration in 
   -- a file named cfg_weather_XXXX where XXXX is the city code
   -- this configuration will apply only to the monitor watching that
   -- city. In other words, you cannot set the default city for
   -- the monitor with this.set_city() (see comments below).
   this.save_config = function()
			 ioncore.write_savefile("cfg_weather_"..this.config.city, this.config)
		      end

   -- restarts the object
   this.update = function()
		    this.init()
		 end

   -- shows full report
   this.show_data = function(mplex)
		       mod_query.message(mplex, this.raw_data)
		    end

   -- updates data and shows updated full report
   this.update_and_show = function(mplex)
			     this.init()
			     this.show_data(mplex)
			  end

   -- changes city. the new city will not be saved: 
   -- to change city edit the configuration or start the 
   -- monitor with the city as a paramenter, like:
   -- mymon = new_wm("57957")
   this.set_city = function(mplex)
			 local handler = function(mplex, str)
					    this.config.city = str;
					    this.init()
					 end
			 mod_query.query(mplex, TR("Enter a city code:"), nil, handler, 
					 nil, "weather")
		      end

	this.get_report = function(mplex)
			if this.data.status ~= nil then
				mod_query.message(mplex, this.data.status)
			end
	end

	this.get_weather = function()

		local weather = ""
		local tab = "      "
		if this.data.sCurrent ~=nil then
			weather = weather .. "(24)" .. this.data.sCurrent .. tab
		end
		
		local h48 = this.get_hour("48")
		if h48 ~= nil then
			weather = weather .. h48 .. tab
		end		
		
		local h72 = this.get_hour("72")
		if h72 ~= nil then
			weather = weather .. h72
		end

		return weather
	end

   -- constructor
   this.init = function()
		  if mod_statusbar ~= nil then
		  	this.update_data()
		  	this.process_data()
		     this.notify()
		     this.status_timer:set(this.config.interval, this.init)
		  end
   end

   -- initialize the object
   this.process_config()
   this.init()
   return { 
      config = this.config,
      data = this.data,
      save_config = this.save_config,
      update = this.update,
      show_data = this.show_data,
      update_and_show = this.update_and_show,
      set_city = this.set_city,
      get_report = this.get_report,
	  get_weather = this.get_weather
   }
end

-- start default monitor
WeatherMonitor = new_wm()

	defmenu("weathermenu", {
	   menuentry("set city", "WeatherMonitor.set_city(_)"),
	   menuentry("update now", "WeatherMonitor.update(_)"),
	   menuentry("update and show", "WeatherMonitor.update_and_show(_)"),
	   menuentry("show data", "WeatherMonitor.show_data(_)"),
	   menuentry("get hint", "WeatherMonitor.get_hint(_)"),
	   menuentry("get report", "WeatherMonitor.get_report(_)"),
	})
--[[
defbindings("WMPlex", {
	       kpress(ALTMETA..SHIFT.."F9", "mod_query.query_menu(_, 'weathermenu', 'WeatherMonitor Menu: ')"),
	       kpress(ALTMETA..SHIFT.."F10", "WeatherMonitor.set_city(_)"),
	    })
defmenu("weathermenu", {
	   menuentry("set city", "WeatherMonitor.set_city()"),
	   menuentry("update now", "WeatherMonitor.update()"),
	   menuentry("update and show", "WeatherMonitor.update_and_show()"),
	   menuentry("show data", "WeatherMonitor.show_data()"),
	   menuentry("get hint", "WeatherMonitor.get_hint()"),
	   menuentry("get report", "WeatherMonitor.get_report()"),
	}
)
--]]
