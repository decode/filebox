
--
-- Ion statusbar module configuration file
-- 


-- Create a statusbar
mod_statusbar.create{
    -- First screen, bottom left corner
    screen=0,
    --pos='tl',
    pos='tl',

    -- Set this to true if you want a full-width statusbar
    fullsize=true,
    -- Swallow systray windows
    systray=true,

    -- Template. Tokens %string are replaced with the value of the 
    -- corresponding meter. Currently supported meters are:
    --   date          date
    --   load          load average (1min, 5min, 15min)
    --   load_Nmin     N minute load average (N=1, 5, 15)
    --   mail_new      mail count (mbox format file $MAIL)
    --   mail_unread   mail count
    --   mail_total    mail count
    --   mail_*_new    mail count (from an alternate mail folder, see below)
    --   mail_*_unread mail count
    --   mail_*_total  mail count
    --
    -- Space preceded by % adds stretchable space for alignment of variable
    -- meter value widths. > before meter name aligns right using this 
    -- stretchable space , < left, and | centers.
    -- Meter values may be zero-padded to a width preceding the meter name.
    -- These alignment and padding specifiers and the meter name may be
    -- enclosed in braces {}.
    --
    -- %filler causes things on the marker's sides to be aligned left and
    -- right, respectively, and %systray is a placeholder for system tray
    -- windows and icons.
    --
    --template="[ %date || load:% %>load || mail:% %>mail_new/%>mail_total ] %filler%systray",
    --template="[ %date || load: %05load_1min || mail: %02mail_new/%02mail_total ] %filler%systray",

	--  	%ticker %workspace_pager %xmmsip_plcur %xmmsip_pos %xmmsip_status  _ BATT: %laptopstatus_batterypercent %laptopstatus_batterytimeleft %schedule %nmaild_new
    --template="%date _ cpu: %cpustat_user %laptopstatus_temperature _ mem: %meminfo_mem_free_adj _ load: %05load_1min _ vol: %volume_level%volume_state _ M:%02nmaild_allnew/%02nmaild_allread %panel %mocp_user_defined %filler %iface%netmon_kbsin/%netmon_kbsout %laptopstatus_batterypercent %laptopstatus_batterytimeleft%workspace_pager%systray",
    template="%date || %mcpu[%mcpu_0,%mcpu_1] %laptopstatus_temperature-%meminfo_mem_free_adj-%05load_1min || vol: %volume_level%volume_state || M:%nmaild_new/%nmaild_read %panel %mocp_user_defined %filler %iface%netmon_kbsin/%netmon_kbsout %laptopstatus_batterypercent %laptopstatus_batterytimeleft%workspace_pager%systray",

}


-- Launch ion-statusd. This must be done after creating any statusbars
-- for necessary statusd modules to be parsed from the templates.
mod_statusbar.launch_statusd{
    -- Date meter
    date={
        -- ISO-8601 date format with additional abbreviated day name
        --date_format='%a %Y-%m-%d %H:%M',
        --date_format='%H:%M %a %m.%d.%y',
	date_format='%H:%M %b.%d %a',
        -- Finnish etc. date format
        --date_format='%a %d.%m.%Y %H:%M',
        -- Locale date format (usually shows seconds, which would require
        -- updating rather often and can be distracting)
        --date_format='%c',
        
        -- Additional date formats. 
        --[[ 
        formats={ 
            time = '%H:%M', -- %date_time
        }
        --]]
    },      

    -- Load meter
    load={
        --update_interval=10*1000,
        --important_threshold=1.5,
        --critical_threshold=4.0,
    },

    -- Mail meter
    --
    -- To monitor more mbox files, add them to the files table.  For
    -- example, add mail_work_new and mail_junk_new to the template
    -- above, and define them in the files table:
    --
    -- files = { work = "/path/to/work_email", junk = "/path/to/junk" }
    --
    -- Don't use the keyword 'spool' as it's reserved for mbox	
    mail={
        --update_interval=60*1000,
        --mbox=os.getenv("MAIL"),
        --files={ 
	--	work = "/home/home/mail/default",
	--	ruby = "~/mail/ruby-talk",
	--},
    },

--[[
   	xmmsip = {
     	interval = 1 * 1000,
     	user_format = "[%status% %pos%/%time%]%title%[%kbitrate%K %plcur%/%pllen%]",
     	not_running = "",
     	do_monitors = true,
   	},
--]]    
	weathercn = {
		-- Guilin 57957
		-- Xi'An 57036
		-- HanZhong 57127
    	city = "57036",
		hour = "48",	--Get the 48 hour's forecast
    },

stock = {
    tickets = {"600036.ss", "000968.sz"},
    interval = 5 * 60 * 1000,       -- check every 5 minutes
    off_msg = "*Stock*",            -- string to be displayed in "short" mode
    susp_msg = "(Stock suspended)", -- string to be displayed when data
                                    -- retrieval is suspended
    susp_msg_hint = "critical",     -- hint for suspended mode
    unit = {
       delta = "%",                 
    },
    important = {
       delta = 0,
    },
    critical = {
       delta = 0,
    }
 },

 nmaild = {
	    update_interval = 5*1000,
	    check = {
	            "~/mail/default",
		    },
	    	     new = {"critical", 1},   	    	     
		     read = {"important", 40},
	   	     allnew = {"critical", 15},
	    	     allread = {"important", 30},
--	    	     exec_on_new = "play ~/mew_wmail.mp3" -->  Execute something on new email arrival.
--	    	     					       If you want to deactivate exec_on_new,
--	    	     					       just erase it from settings.
--	    	     					       If you need to specify very complex commands
--	    	     					       the best way is to replace the quotes for
--	    	     					       [[ at start and ]] at the end.
  	},			

}

