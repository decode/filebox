-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

require("scratch")
require("vicious")
require("awful.client")
require("revelation")

-- Go to client by name using dmenu
require("aweswt")
require("aweror")
globalkeys = awful.util.table.join(globalkeys, aweror.genkeys(modkey))
      
-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
--beautiful.init("/usr/share/awesome/themes/zenburn/theme.lua")
beautiful.init("/home/home/.config/awesome/themes/zenburn/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt" --"xterm"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.max,
    awful.layout.suit.max,
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5 }, s, layouts)
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   --{ "hide titlebar", function() mpdwidget.visible = false end},
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it

tasks = widget({ type = "textbox" } )
--tasks = textbox({ width = 200, align = "left" })

-- Initialize widget
infoimage = widget({ type = "imagebox" })
infoimage.image = image("/home/home/.config/awesome/themes/icons/anrxc/down.png")
netwidget = widget({ type = "textbox" })
vicious.register(netwidget, vicious.widgets.net, '<span color="'
  .. 'green' ..'">${eth0 down_kb}</span>/<span color="'
  .. 'yellow' ..'">${eth0 up_kb}</span>', 5)

wifiimage = widget({ type = "imagebox" })
wifiimage.image = image("/home/home/.config/awesome/themes/icons/anrxc/wifi.png")
wifiwidget = widget({ type = "textbox" })
vicious.register(wifiwidget, vicious.widgets.net, '<span color="green">${wlan0 down_kb}</span>'
  .. '/<span color="yellow">${wlan0 up_kb}</span>', 3)
  
timeimage = widget({ type = "imagebox" })
timeimage.image = image("/home/home/.config/awesome/themes/icons/anrxc/time.png")
datewidget = widget({ type = "textbox" })
vicious.register(datewidget, vicious.widgets.date, '<span color="white">%R</span> %b %d, %a(%U) ', 60)


cpuimage = widget({ type = "imagebox" })
cpuimage.image = image("/home/home/.config/awesome/themes/icons/anrxc/cpu.png")
--cpuimage.image = image("/home/home/.config/awesome/themes/icons/dzen/dzen_bitmaps/cpu.png")
cpuwidget = widget({ type = "textbox" })
vicious.register(cpuwidget, vicious.widgets.cpu, "$1% ")

tempimage = widget({ type = "imagebox" })
tempimage.image = image("/home/home/.config/awesome/themes/icons/anrxc/temp.png")
tzswidget = widget({ type = "textbox" })
vicious.register(tzswidget, vicious.widgets.thermal, "$1C ", 30, "thermal_zone0")

memimage = widget({ type = "imagebox" })
memimage.image = image("/home/home/.config/awesome/themes/icons/anrxc/mem.png")
memwidget = widget({ type = "textbox" })
vicious.register(memwidget, vicious.widgets.mem, "$1%($2MB) ", 20)

loadimage = widget({ type = "imagebox" })
loadimage.image = image("/home/home/.config/awesome/themes/icons/anrxc/info.png")
loadwidget = widget({ type = "textbox" })
vicious.register(loadwidget, vicious.widgets.uptime, "$4 ($1:$2:$3) ")

volimage = widget({ type = "imagebox" })
volimage.image = image("/home/home/.config/awesome/themes/icons/anrxc/vol.png")
volwidget = widget({ type = "textbox" })
vicious.register(volwidget, vicious.widgets.volume, "$1%[$2]", 2, "Master")

batimage = widget({ type = "imagebox" })
batimage.image = image("/home/home/.config/awesome/themes/icons/anrxc/bat.png")
batwidget = widget({ type = "textbox" })
vicious.register(batwidget, vicious.widgets.bat, "$1$2% ", 61, "BAT0")

musicimage = widget({ type = "imagebox" })
musicimage.image = image("/home/home/.config/awesome/themes/icons/anrxc/music.png")
mpdwidget = widget({ type = "textbox", name = "mympdwidget" })
vicious.register(mpdwidget, vicious.widgets.mpd, "${Artist} - ${Title} [${state}] ", 5)

--weatherwidget = widget({ type = "textbox" })
--vicious.register(weatherwidget, vicious.widgets.weather, "${weather} ${tempc}", 10, "ZLSN")


function show_tasks(cli)
  USE_T=true
  local clients = client.get()
  if table.getn(clients) == 0 then 
    return
  end
  local m1=''
  local t2={}
  local tmp
  for i, c in pairs(clients) do
    if USE_T then do
      if c['window']==cli['window'] then do
        tmp='<span color=\'#ffffee\'>- '..i..':'..string.sub(c['class'], 1, 12)..' -</span>'
        if c['instance']=="Navigator" then 
          tmp='<span color=\'#ffffee\'>- '..i..':Firefox -</span>'
        end
      end
      else do
        tmp='<span color=\'#aabbcc\'>'..i..':'..string.sub(c['class'], 1, 12)..'</span>'
        if c['instance']=="Navigator" then 
          tmp='<span color=\'#aabbcc\'>'..i..':Firefox</span>'
        end
      end
      end
    end
    else do
      tmp=i..':'..c['instance']..'.'..c['class']
    end
    end
    m1=m1..tmp..'  '
    --t2[tmp]=c
  end
  tasks.text = m1
  tasks.width = 1024 
  tasks.align = "center"
  tasks.bg = "black"
end

mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              --a,b,x = awful.client.idx(c)
                                              --return awful.widget.tasklist.label.focused(c, s) 
                                              return awful.widget.tasklist.label.currenttags(c, s) 
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "bottom", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mytaglist[s],
            mylauncher,
            mypromptbox[s],
            --tasks,
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mpdwidget,
        musicimage,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
    mywibox[s].height = 14
end
-- }}}

tb_moc = widget({ type = "textbox" })

statuswibox = {}
-- {{{ Custom Statusbar
for s = 1, screen.count() do
    statuswibox[s] = awful.wibox({ position = "top", screen = s })
    statuswibox[s].widgets = {
      {
        --mytextclock,
        --mytaglist[s],
        timeimage,
        datewidget,
        cpuimage,
        cpuwidget,
        tempimage,
        tzswidget,
        memimage,
        memwidget,
        loadimage,
        loadwidget,
        volimage,
        volwidget,
        --musicimage,
        --mpdwidget,
        --weatherwidget,
        --tb_moc,
        --mypromptbox[s],
        layout = awful.widget.layout.horizontal.leftright
      },
      s == 1 and mysystray or nil,
      netwidget,
      infoimage,
      wifiwidget,
      wifiimage,
      batwidget,
      batimage,
      layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}


taskwibox = {}
-- {{{ Custom Statusbar
for s = 1, screen.count() do
    taskwibox[s] = awful.wibox({ position = "bottom", screen = s })
    taskwibox[s].widgets = {
          --mytasklist[s],
          tasks,
          layout = awful.widget.layout.horizontal.leftright
    }
    taskwibox[s].height = 16
    taskwibox[s].opacity = 0.4
    --taskwibox[s].x = 300
    --taskwibox[s].y = 735 
    taskwibox[s].y = 736
    taskwibox[s].bg = "gray"
    taskwibox[s].ontop = true
end

-- {{{ Custom Statusbar

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey }, "k", aweswt.switch),
    awful.key({ modkey }, "space", function () scratch.pad.toggle() end),
    awful.key({ modkey }, "/", function () scratch.drop("urxvt", "bottom", "center", 1, 0.3, true) end),
    awful.key({ modkey }, "e",  revelation.revelation),
    awful.key({ modkey }, "o",  function() 
      if tasks.visible==true then
        tasks.visible = false
        for s = 1, screen.count() do
          taskwibox[s].visible = false 
        end
      else
        for s = 1, screen.count() do
          taskwibox[s].visible = true 
          taskwibox[s].y = 736
          --taskwibox[s].y = 670
        end
        tasks.visible = true 
      end
    end),

    awful.key({ modkey }, "y",  function() 
      mpdwidget.visible = not mpdwidget.visible
      musicimage.visible = not musicimage.visible
    end),

    awful.key({ modkey }, "s", function ()
        awful.prompt.run({ prompt = "<span color='green' background='black'> Web search: </span>" }, mypromptbox[mouse.screen].widget,
            function (command)
                awful.util.spawn("firefox 'http://yubnub.org/parser/parse?command="..command.."'", false)
                --awful.util.spawn("firefox 'http://www.google.de/search?hl=de&source=hp&q="..command.."&btnG=Google-Suche'", false)
                -- Switch to the web tag, where Firefox is, in this case tag 3
                --if tags[mouse.screen][3] then awful.tag.viewonly(tags[mouse.screen][3]) end
            end)
    end),

    awful.key({ "Mod1" }, "m", function ()
      -- If you want to always position the menu on the same place set coordinates
      io.popen("notify-send -t 2000 'Alt + m' 'show Window List'")
      awful.menu.menu_keys.down = { "Down", "Alt_L" }
      local cmenu = awful.menu.clients({width=245}, { keygrabber=true, coords={x=405, y=300} })
    end),


    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, ".",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus 
              then 
                client.focus:raise() 
                io.popen("notify-send -t 2000 'win + .' 'next client'")
              end
        end),
    awful.key({ modkey,           }, "x",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus 
              then
                client.focus:raise()
                io.popen("notify-send -t 2000 'win + x' 'next client'")
              end
        end),
    awful.key({ modkey,           }, ",",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus 
              then 
                client.focus:raise() 
                io.popen("notify-send -t 2000 'win + ,' 'prev client'")
              end
        end),
    awful.key({ modkey,           }, "z",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus
              then
                client.focus:raise() 
                io.popen("notify-send -t 2000 'win + z' 'prev client'")
              end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            io.popen("notify-send -t 2000 'win + tab' 'cycle client'")
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    --awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey, "Alt_L"   }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    --awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "F4",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Return",
        function (c)
          c.fullscreen = not c.fullscreen  
          io.popen("notify-send -t 2000 '[win + return]' 'toggle client fullscreen'")
        end),
    awful.key({ modkey, }, "c",      
        function (c) 
          c:kill()                         
          io.popen("notify-send -t 2000 'win + c' 'kill client'")
        end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey, "Shift"   }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      
        function (c) 
          c.ontop = not c.ontop            
          io.popen("notify-send -t 2000 'win + t' 'set client on top'")
        end),
    awful.key({ modkey,           }, "n",      
        function (c)
            c.minimized = not c.minimized    
            io.popen("notify-send -t 2000 'win + n' 'minimized client'")
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
            io.popen("notify-send -t 2000 'win + m' 'toggle maximized client'")
        end),


    awful.key({ modkey }, "p", function (c) scratch.pad.set(c, 0.60, 0.60, true) end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewonly(tags[screen][i])
                          io.popen("notify-send -t 2000 'win + ".. i .."' 'goto screen " .. i .. "'")
                      end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                          io.popen("notify-send -t 2000 'win + ".. i .."' 'show both screen " .. i .. "'")
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                          io.popen("notify-send -t 2000 'win + shift + ".. i .."' 'send client to screen " .. i .. "'")
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                          io.popen("notify-send -t 2000 'win + ctrl + shift + ".. i .."' 'show client also in screen " .. i .. "'")
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     size_hints_honor = false,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "Openetion" },
      properties = { floating = true } },
    { rule = { class = "Tilda" },
      properties = { floating = true } },
    { rule = { class = "smplayer" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })
    show_tasks(c)

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) 
  c.border_color = beautiful.border_focus 
  show_tasks(c)
end)
client.add_signal("unfocus", function(c)
  c.border_color = beautiful.border_normal
  show_tasks(c)
end)

client.add_signal("list", function()
  for s = 1, screen.count() do
    c = awful.client.focus.history.get(1,0)
  end
  show_tasks(c)
end)

-- }}}

mytimer = timer({ timeout = 2 })
mytimer:add_signal("timeout", function()
   moc_info = io.popen("mocp -i"):read("*all")
   moc_state = string.gsub(string.match(moc_info, "State: %a*"),"State: ","")
   if moc_state == "PLAY" or moc_state == "PAUSE" then
       moc_artist = string.gsub(string.match(moc_info, "Artist: %C*"), "Artist: ","")
       moc_title = string.gsub(string.match(moc_info, "SongTitle: %C*"), "SongTitle: ","")
       moc_curtime = string.gsub(string.match(moc_info, "CurrentTime: %d*:%d*"), "CurrentTime: ","")
       moc_totaltime = string.gsub(string.match(moc_info, "TotalTime: %d*:%d*"), "TotalTime: ","")
       if moc_artist == "" then 
           moc_artist = "unknown artist" 
       end
       if moc_title == "" then 
           moc_title = "unknown title" 
       end
       moc_string = "MOC: " .. moc_artist .. " - " .. moc_title .. "(" .. moc_curtime .. "/" .. moc_totaltime .. ")"
       if moc_state == "PAUSE" then 
           moc_string = " [[ " .. moc_string .. " ]]"
       end
   else
       moc_string = " [ not playing ]"
   end
   tb_moc.text = moc_string
end)
--mytimer:start()

