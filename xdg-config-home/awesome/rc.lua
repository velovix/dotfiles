-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local volume_widget = require("volume-widget")
--local brightness_widget = require("brightness-widget")
local touchpad_widget = require("touchpad-widget")
--local battery_widget = require("battery-widget")

-- Load volume control widget
local volume = volume_widget:new({})
-- Load brightness control widget
--local brightness = brightness_widget:new({})
-- Load touchpad control widget
local touchpad = touchpad_widget:new({vendor="Creative"})
-- Load battery control widget
--local battery = battery_widget:new({})

-- Include lain for more layouts
local lain = require("lain")

-- Only run the following command if it isn't already running
function run_once(cmd)
	findme = cmd
	firstspace = cmd:find(" ")
	if firstspace then
		findme = cmd:sub(0, firstspace-1)
	end
	awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

-- Run a command synchronously
function spawn_and_wait(cmd)
	local prog = io.popen(cmd)
	local result = prog:read('*all')
	prog:close()
	return result
end

-- Start autolock
awful.util.spawn_with_shell("xautolock -time 10 -locker i3lock -c 000000")
-- Start compositor
run_once("compton --config ~/.config/compton.conf -b")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({ preset = naughty.config.presets.critical,
					title = "Oops, there were errors during startup!",
					text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function (err)
		-- Make sure we don't go into an endless error loop
		if in_error then return end
		in_error = true

		naughty.notify({ preset = naughty.config.presets.critical,
						 title = "Oops, an error happened!",
						 text = err })
		in_error = false
	end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("~/.config/awesome/lowpoly/theme.lua")

-- Set the default programs
terminal = "termite"
filemanager = "pcmanfm"
browser = "chromium"
editor = os.getenv("EDITOR") or "nano"
editor_gfx = "nvim-qt"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- START CUSTOM FUNCTIONS HERE

-- Touchpad control
touchpadEnabled = false
function toggleTouchpad()
	if touchpadEnabled then
		touchpadEnabled = false
		return "synclient touchpadoff=1"
	else
		touchpadEnabled = true
		return "synclient touchpadoff=0"
	end
end

-- Only run the following command if it isn't already running
function run_once(cmd)
	findme = cmd
	firstspace = cmd:find(" ")
	if firstspace then
		findme = cmd:sub(0, firstspace-1)
	end
	awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

-- END CUSTOM FUNCTIONS HERE

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
	awful.layout.suit.floating,
	lain.layout.uselesstile,
	lain.layout.uselesstile.left,
	lain.layout.uselesstile.bottom,
	lain.layout.uselesstile.top,
	lain.layout.uselessfair,
	lain.layout.uselessfair.horizontal,
	awful.layout.suit.max,
	awful.layout.suit.magnifier,
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
	for s = 1, screen.count() do
		gears.wallpaper.maximized(beautiful.wallpaper, s, true)
	end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
	tagNames = { "web", "ide", "trm", "img", "stm", "etc" }
	tagLayouts = { layouts[2], layouts[2], layouts[2], layouts[1], layouts[1], layouts[1] }
	tags[s] = awful.tag(tagNames, s, tagLayouts)
end
-- }}}

mymainmenu = awful.menu({ items = { { "terminal", terminal },
									{ "files", filemanager },
									{ "text", editor_gfx },
									{ "chromium", "chromium" },
									{ "gimp", "gimp" },
									{ "steam", "steam" },
									{ "blender", "optirun -b primus blender" },
									{ "restart", awesome.restart },
									{ "quit", awesome.quit }
								  }
						})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
									 menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
					awful.button({ }, 1, awful.tag.viewonly),
					awful.button({ modkey }, 1, awful.client.movetotag),
					awful.button({ }, 3, awful.tag.viewtoggle),
					awful.button({ modkey }, 3, awful.client.toggletag),
					awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
					awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
					)
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
					 awful.button({ }, 1, function (c)
											  if c == client.focus then
												  c.minimized = true
											  else
												  -- Without this, the following
												  -- :isvisible() makes no sense
												  c.minimized = false
												  if not c:isvisible() then
													  awful.tag.viewonly(c:tags()[1])
												  end
												  -- This will also un-minimize
												  -- the client, if needed
												  client.focus = c
												  c:raise()
											  end
										  end),
					 awful.button({ }, 3, function ()
											  if instance then
												  instance:hide()
												  instance = nil
											  else
												  instance = awful.menu.clients({
													  theme = { width = 250 }
												  })
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
	mypromptbox[s] = awful.widget.prompt()
	-- Create an imagebox widget which will contains an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	mylayoutbox[s] = awful.widget.layoutbox(s)
	mylayoutbox[s]:buttons(awful.util.table.join(
						   awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
						   awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
						   awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
						   awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
	-- Create a taglist widget
	mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

	-- Create a tasklist widget
	mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

	-- Create the wibox
	mywibox[s] = awful.wibox({ position = "top", screen = s })

	-- Widgets that are aligned to the left
	local left_layout = wibox.layout.fixed.horizontal()
	left_layout:add(mylauncher)
	left_layout:add(mytaglist[s])
	left_layout:add(mypromptbox[s])

	-- Widgets that are aligned to the right
	local right_layout = wibox.layout.fixed.horizontal()
	if s == 1 then right_layout:add(wibox.widget.systray()) end
	right_layout:add(mytextclock)
	right_layout:add(touchpad.widget)
	right_layout:add(volume.widget)
	--right_layout:add(brightness.widget)
	--right_layout:add(battery.widget)
	right_layout:add(mylayoutbox[s])

	-- Now bring it all together (with the tasklist in the middle)
	local layout = wibox.layout.align.horizontal()
	layout:set_left(left_layout)
	layout:set_middle(mytasklist[s])
	layout:set_right(right_layout)

	mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
	awful.button({ }, 4, awful.tag.viewnext),
	awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
	-- Print the screen using imagemagick import
	awful.key({}, "Print", function()
		date = os.date("*t", os.time())
		name = date["month"].."-"..date["day"].."-"..date["year"].."_"..date["hour"]..":"..date["min"]..":"..date["sec"]
		awful.util.spawn_with_shell("import -window root -quality 100 ~/Screenshot" .. name .. ".png")
	end ),

	-- Lock key
	awful.key({}, "F12", function()
		awful.util.spawn_with_shell("(i3lock -c 000000) & xset dpms force off")
	end ),

	-- Volume control keys
	awful.key({}, "XF86AudioRaiseVolume", function() volume:up() end ),
	awful.key({}, "XF86AudioLowerVolume", function() volume:down() end ),

	-- Brightness control keys
	--awful.key({}, "XF86MonBrightnessDown", function() brightness:down() end),
	--awful.key({}, "XF86MonBrightnessUp", function() brightness:up() end),

	awful.key({ modkey,		   }, "h",   awful.tag.viewprev	   ),
	awful.key({ modkey,		   }, "l",  awful.tag.viewnext	   ),
	awful.key({ modkey,		   }, "Escape", awful.tag.history.restore),

	awful.key({ modkey,		   }, "j",
		function ()
			awful.client.focus.byidx( 1)
			if client.focus then client.focus:raise() end
		end),
	awful.key({ modkey,		   }, "k",
		function ()
			awful.client.focus.byidx(-1)
			if client.focus then client.focus:raise() end
		end),
	awful.key({ modkey,		   }, "w", function () mymainmenu:show() end),

	-- Layout manipulation
	awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)	end),
	awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)	end),
	awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
	awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
	awful.key({ modkey,		   }, "u", awful.client.urgent.jumpto),
	awful.key({ modkey,		   }, "Tab",
		function ()
			awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			end
		end),

	-- Standard program
	awful.key({ modkey,		   }, "Return", function () awful.util.spawn(terminal) end),
	awful.key({ modkey, "Control" }, "r", awesome.restart),
	awful.key({ modkey, "Shift"   }, "q", awesome.quit),

	awful.key({ modkey,		   }, "Right",	 function () awful.tag.incmwfact( 0.05)	end),
	awful.key({ modkey,		   }, "Left",	 function () awful.tag.incmwfact(-0.05)	end),
	awful.key({ modkey, "Shift"   }, "Left",	 function () awful.tag.incnmaster( 1)	  end),
	awful.key({ modkey, "Shift"   }, "Right",	 function () awful.tag.incnmaster(-1)	  end),
	awful.key({ modkey, "Control" }, "Left",	 function () awful.tag.incncol( 1)		 end),
	awful.key({ modkey, "Control" }, "Right",	 function () awful.tag.incncol(-1)		 end),
	awful.key({ modkey,		   }, "space", function () awful.layout.inc(layouts,  1) end),
	awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

	awful.key({ modkey, "Control" }, "n", awful.client.restore),

	-- Prompt
	awful.key({ modkey },			"r",	 function () mypromptbox[mouse.screen]:run() end),

	awful.key({ modkey }, "x",
			  function ()
				  awful.prompt.run({ prompt = "Run Lua code: " },
				  mypromptbox[mouse.screen].widget,
				  awful.util.eval, nil,
				  awful.util.getdir("cache") .. "/history_eval")
			  end),
	-- Menubar
	awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
	awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end ),
	awful.key({ modkey, "Shift"   }, "c",	   function (c) c:kill()                         end ),
	awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                      ),
	awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end ),
	awful.key({ modkey,           }, "o",      awful.client.movetoscreen						 ),
	awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop			 end ),
	awful.key({ modkey,           }, "n",
		function (c)
			-- The client currently has the input focus, so it cannot be
			-- minimized, since minimized clients can't have the focus.
			c.minimized = true
		end),
	awful.key({ modkey,		   }, "m",
		function (c)
			c.maximized_horizontal = not c.maximized_horizontal
			c.maximized_vertical   = not c.maximized_vertical
		end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = awful.util.table.join(globalkeys,
		-- View tag only.
		awful.key({ modkey }, "#" .. i + 9,
				  function ()
						local screen = mouse.screen
						local tag = awful.tag.gettags(screen)[i]
						if tag then
						   awful.tag.viewonly(tag)
						end
				  end),
		-- Toggle tag.
		awful.key({ modkey, "Control" }, "#" .. i + 9,
				  function ()
					  local screen = mouse.screen
					  local tag = awful.tag.gettags(screen)[i]
					  if tag then
						 awful.tag.viewtoggle(tag)
					  end
				  end),
		-- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + 9,
				  function ()
					  if client.focus then
						  local tag = awful.tag.gettags(client.focus.screen)[i]
						  if tag then
							  awful.client.movetotag(tag)
						  end
					 end
				  end),
		-- Toggle tag.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
				  function ()
					  if client.focus then
						  local tag = awful.tag.gettags(client.focus.screen)[i]
						  if tag then
							  awful.client.toggletag(tag)
						  end
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
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{ rule = { },
	  properties = { border_width = beautiful.border_width,
					 border_color = beautiful.border_normal,
					 focus = awful.client.focus.filter,
					 -- Remove window gaps
					 size_hints_honor = false,
					 raise = true,
					 keys = clientkeys,
					 buttons = clientbuttons } },
	{ rule = { class = "MPlayer" },
	  properties = { floating = true } },
	{ rule = { class = "pinentry" },
	  properties = { floating = true } },
	-- Rules for Hangouts and other Chrome extensions
	{ rule = { instance = "knipolnnllmklapflnccelgolnpehhpl" },
	  properties = { floating = true, } },
	{ rule = { instance = "nckgahadagoaajjgafhacjanaoiihapd" },
	  properties = { floating = true, } },
	{ rule = { instance = "fahmaaghhglfmonjliepjlchgpgfmobi" },
	  properties = {floating = true} },
	{ rule = { instance = "chlffgpmiacpedhhbkiomidkjlcfhogd" },
	  properties = {floating = true} },
	{ rule = { name = "uArm Creator Dashboard" },
	  properties = { floating = true } },
	{ rule = { class = "Git-gui" },
	  properties = {floating = true} },
	{ rule = { name = "background audio visualizer" },
	  properties = { opacity = 0.2, behind = true, skip_taskbar = true, maximized = true, sticky = true } },
}
-- }}}

-- Ban the audio visualizer from being focused
do
	local filter = awful.client.focus.filter
	awful.client.focus.filter = function(c)
		--if c.name == "background audio visualizer" then
			--awful.client.focus.history.delete(c)
		--end
		return c.name ~= "background audio visualizer" and filter(c)
	end
end

-- Ban the audio visualizer from history
do
	local historyGet = awful.client.focus.history.get
	awful.client.focus.history.get = function(screen, idx)
		-- Find the audio visualizer 
		local history = awful.client.data.focus
		for k, v in ipairs(history) do
			if v.name == "background audio visualizer" then
				awful.client.focus.history.delete(v)
			end
		end

		return historyGet(screen, idx)
	end
end

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
	-- Enable sloppy focus
	c:connect_signal("mouse::enter", function(c)
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

	local titlebars_enabled = false
	if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
		-- buttons for the titlebar
		local buttons = awful.util.table.join(
				awful.button({ }, 1, function()
					client.focus = c
					c:raise()
					awful.mouse.client.move(c)
				end),
				awful.button({ }, 3, function()
					client.focus = c
					c:raise()
					awful.mouse.client.resize(c)
				end)
				)

		-- Widgets that are aligned to the left
		local left_layout = wibox.layout.fixed.horizontal()
		left_layout:add(awful.titlebar.widget.iconwidget(c))
		left_layout:buttons(buttons)

		-- Widgets that are aligned to the right
		local right_layout = wibox.layout.fixed.horizontal()
		right_layout:add(awful.titlebar.widget.floatingbutton(c))
		right_layout:add(awful.titlebar.widget.maximizedbutton(c))
		right_layout:add(awful.titlebar.widget.stickybutton(c))
		right_layout:add(awful.titlebar.widget.ontopbutton(c))
		right_layout:add(awful.titlebar.widget.closebutton(c))

		-- The title goes in the middle
		local middle_layout = wibox.layout.flex.horizontal()
		local title = awful.titlebar.widget.titlewidget(c)
		title:set_align("center")
		middle_layout:add(title)
		middle_layout:buttons(buttons)

		-- Now bring it all together
		local layout = wibox.layout.align.horizontal()
		layout:set_left(left_layout)
		layout:set_right(right_layout)
		layout:set_middle(middle_layout)

		awful.titlebar(c):set_widget(layout)
	end

	placeVisualizers()
end)

function placeVisualizers()
	local cnt = 1

	for s = 1, screen.count() do
		for v, k in ipairs(awful.client.visible(s)) do
			if k.name == "background audio visualizer" then
				if cnt <= screen.count() then
					k.screen = cnt
					cnt = cnt + 1
				else
					naughty.notify({text="warning, too many visualizers"})
				end
			end
		end
	end
end

-- Spawn redshift
run_once("redshift-gtk")
-- Spawn the visualizer
spawn_and_wait("pkill -f 'background audio visualizer'")
for s = 1, screen.count() do
	awful.util.spawn_with_shell("termite --title 'background audio visualizer' --config ~/.config/termite/config-transparent --exec cava")
end
