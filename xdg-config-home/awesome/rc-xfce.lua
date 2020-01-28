-- @DOC_REQUIRE_SECTION@
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget 

-- {{{ Error handling
-- @DOC_ERROR_HANDLING@
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
						 text = tostring(err) })
		in_error = false
	end)
end
-- }}}

-- {{{ Variable definitions
-- @DOC_LOAD_THEME@
-- Themes define colours, icons, font and wallpapers.
beautiful.init("~/.config/awesome/solarized/theme.lua")

-- Fix bug with large notifications
-- TODO(velovix): Use this when Awesome 4.3 is out
--beautiful.notification_icon_size = 32
naughty.config.defaults['icon_size'] = 50

-- @DOC_DEFAULT_APPLICATIONS@
-- This is used later as the default terminal and editor to run.
terminal = "kitty"
filemanager = "pcmanfm"
browser = "chromium"
editor = os.getenv("EDITOR") or "vi"
editor_gfx = "nvim-qt"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- START CUSTOM FUNCTIONS HERE

-- Run a command synchronously
function spawn_and_wait(cmd)
	local prog = io.popen(cmd)
	local result = prog:read('*all')
	local info = {prog:close()}
	return {result, info[3]}
end

-- Set the current window to be floating, 1920x1080, and in the middle of the
-- current screen.
function fit_to_middle_1080p()
	if client.focus == nil then
		naughty.notify({
			title = "Fit to Middle",
			text = "No client is focused so no window will be fit to middle."
		})
		return
	end

	naughty.notify({
		title = "Fit to Middle",
		text = "Okay, fitting a window to middle..."
	})

	local current_screen = awful.screen.focused()

	client.focus.floating = true
	client.focus:geometry({
		x = (current_screen.geometry.width / 2) - (1920 / 2),
		y = (current_screen.geometry.height / 2) - (1080 / 2),
		width = 1920,
		height = 1080 })
end

-- END CUSTOM FUNCTIONS HERE

-- @DOC_LAYOUT@
-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
	awful.layout.suit.floating,
	awful.layout.suit.tile,
	awful.layout.suit.tile.left,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.tile.top,
	awful.layout.suit.fair,
	awful.layout.suit.fair.horizontal,
	awful.layout.suit.spiral,
	awful.layout.suit.spiral.dwindle,
	awful.layout.suit.max,
	awful.layout.suit.max.fullscreen,
	awful.layout.suit.magnifier,
	awful.layout.suit.corner.nw,
	-- awful.layout.suit.corner.ne,
	-- awful.layout.suit.corner.sw,
	-- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
	local instance = nil

	return function ()
		if instance and instance.wibox.visible then
			instance:hide()
			instance = nil
		else
			instance = awful.menu.clients({ theme = { width = 250 } })
		end
	end
end
-- }}}

-- {{{ Menu
-- @DOC_MENU@

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- Turn off this setting to make menubar faster. Note that this might be fixed
-- in a later release
menubar.menu_gen.lookup_category_icons = function() end
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- @TAGLIST_BUTTON@
local taglist_buttons = awful.util.table.join(
					awful.button({ }, 1, function(t) t:view_only() end),
					awful.button({ modkey }, 1, function(t)
											  if client.focus then
												  client.focus:move_to_tag(t)
											  end
										  end),
					awful.button({ }, 3, awful.tag.viewtoggle),
					awful.button({ modkey }, 3, function(t)
											  if client.focus then
												  client.focus:toggle_tag(t)
											  end
										  end),
					awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
					awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
				)

-- @TASKLIST_BUTTON@
local tasklist_buttons = awful.util.table.join(
					 awful.button({ }, 1, function (c)
											  if c == client.focus then
												  c.minimized = true
											  else
												  -- Without this, the following
												  -- :isvisible() makes no sense
												  c.minimized = false
												  if not c:isvisible() and c.first_tag then
													  c.first_tag:view_only()
												  end
												  -- This will also un-minimize
												  -- the client, if needed
												  client.focus = c
												  c:raise()
											  end
										  end),
					 awful.button({ }, 3, client_menu_toggle_fn()),
					 awful.button({ }, 4, function ()
											  awful.client.focus.byidx(1)
										  end),
					 awful.button({ }, 5, function ()
											  awful.client.focus.byidx(-1)
										  end))

-- @DOC_FOR_EACH_SCREEN@
awful.screen.connect_for_each_screen(function(s)
	-- Each screen has its own tag table.
	local tagNames = { "🌎", "📝", "🖥️", "🎨", "🕴️" }
	awful.tag(tagNames, s, awful.layout.layouts[2])
	for _, v in pairs(tagNames) do
		local tag = awful.tag.find_by_name(s, v)
		tag.gap = 15
		tag.gap_single_client = true
		tag.column_count = 2
		tag.master_width_factor = 0.33
	end

	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()
	-- Create an imagebox widget which will contains an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(awful.util.table.join(
						   awful.button({ }, 1, function () awful.layout.inc( 1) end),
						   awful.button({ }, 3, function () awful.layout.inc(-1) end),
						   awful.button({ }, 4, function () awful.layout.inc( 1) end),
						   awful.button({ }, 5, function () awful.layout.inc(-1) end)))
end)
-- }}}

numLockOn = false

-- {{{ Key bindings
-- @DOC_GLOBAL_KEYBINDINGS@
globalkeys = awful.util.table.join(
	-- Print the screen using scrot
	awful.key({}, "Print", function()
		date = os.date("*t", os.time())
		name = date["year"].."-"..date["month"].."-"..date["day"].."_"..date["hour"]..":"..date["min"]..":"..date["sec"]
		awful.util.spawn_with_shell("mkdir -p ~/Screenshots")
		awful.util.spawn_with_shell("sleep 0.5; scrot 'Screenshots/" .. name .. ".png' -s")
	end ),

	-- Volume control keys
	awful.key({}, "XF86AudioRaiseVolume", function()
		awful.util.spawn_with_shell("pactl set-sink-volume @DEFAULT_SINK@ +5%")
	end),
	awful.key({}, "XF86AudioLowerVolume", function()
		awful.util.spawn_with_shell("pactl set-sink-volume @DEFAULT_SINK@ -5%")
	end),
	
	awful.key({}, "Num_Lock",
		function()
			if numLockOn then
				awful.util.spawn_with_shell("play ~/.config/awesome/num-lock-on.wav")
			else
				awful.util.spawn_with_shell("play ~/.config/awesome/num-lock-off.wav")
			end
			numLockOn = not numLockOn
		end,
		{description="testing", group="client"}),

	awful.key({ modkey,		   }, "s",	 function() awful.client.sticky = false end,
			  {description="toggle stickiness", group="tag"}),
	awful.key({ modkey,		   }, "h",   awful.tag.viewprev,
			  {description = "view previous", group = "tag"}),
	awful.key({ modkey,		   }, "l",  awful.tag.viewnext,
			  {description = "view next", group = "tag"}),
	awful.key({ modkey,		   }, "Escape", awful.tag.history.restore,
			  {description = "go back", group = "tag"}),

	awful.key({ modkey,		   }, "j",
		function ()
			awful.client.focus.byidx( 1)
		end,
		{description = "focus next by index", group = "client"}
	),
	awful.key({ modkey,		   }, "k",
		function ()
			awful.client.focus.byidx(-1)
		end,
		{description = "focus previous by index", group = "client"}
	),

	-- Layout manipulation
	awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)	end,
			  {description = "swap with next client by index", group = "client"}),
	awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)	end,
			  {description = "swap with previous client by index", group = "client"}),
	awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
			  {description = "focus the next screen", group = "screen"}),
	awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
			  {description = "focus the previous screen", group = "screen"}),
	awful.key({ modkey,		   }, "u", awful.client.urgent.jumpto,
			  {description = "jump to urgent client", group = "client"}),
	awful.key({ modkey,		   }, "Tab",
		function ()
			awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			end
		end,
		{description = "go back", group = "client"}),

	-- Standard program
	awful.key({ modkey,		   }, "Return", function () awful.spawn(terminal) end,
			  {description = "open a terminal", group = "launcher"}),
	awful.key({ modkey, "Control" }, "r", awesome.restart,
			  {description = "reload awesome", group = "awesome"}),
	awful.key({ modkey, "Shift"   }, "q", awesome.quit,
			  {description = "quit awesome", group = "awesome"}),

	awful.key({ modkey,		   }, "Right",	 function () awful.tag.incmwfact( 0.05)		  end,
			  {description = "increase master width factor", group = "layout"}),
	awful.key({ modkey,		   }, "Left",	 function () awful.tag.incmwfact(-0.05)		  end,
			  {description = "decrease master width factor", group = "layout"}),
	awful.key({ modkey, "Control" }, "h",	 function () awful.tag.incncol( 1, nil, true)	end,
			  {description = "increase the number of columns", group = "layout"}),
	awful.key({ modkey, "Control" }, "l",	 function () awful.tag.incncol(-1, nil, true)	end,
			  {description = "decrease the number of columns", group = "layout"}),
	awful.key({ modkey,		   }, "space", function () awful.layout.inc( 1)				end,
			  {description = "select next", group = "layout"}),
	awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)				end,
			  {description = "select previous", group = "layout"}),

	awful.key({ modkey, "Control" }, "n",
			  function ()
				  local c = awful.client.restore()
				  -- Focus restored client
				  if c then
					  client.focus = c
					  c:raise()
				  end
			  end,
			  {description = "restore minimized", group = "client"}),

	awful.key({ modkey }, "p", function() awful.util.spawn_with_shell("rofi -show drun -theme ~/.config/rofi/solarized_simple.rasi -font 'hack 10'") end,
			  {description = "Show rofi", group = "launcher"}),
	
	-- Fit to middle at 1920x1080
	awful.key({ modkey, "Control", "Shift" }, "m", fit_to_middle_1080p)
)

-- @DOC_CLIENT_KEYBINDINGS@
clientkeys = awful.util.table.join(
	awful.key({ modkey,		   }, "f",
		function (c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end,
		{description = "toggle fullscreen", group = "client"}),
	awful.key({ modkey, "Shift"   }, "c",	  function (c) c:kill()						 end,
			  {description = "close", group = "client"}),
	awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle					 ,
			  {description = "toggle floating", group = "client"}),
	awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
			  {description = "move to master", group = "client"}),
	awful.key({ modkey,		   }, "o",	  function (c) c:move_to_screen()			   end,
			  {description = "move to screen", group = "client"}),
	awful.key({ modkey,		   }, "t",	  function (c) c.ontop = not c.ontop			end,
			  {description = "toggle keep on top", group = "client"}),
	awful.key({ modkey,		   }, "n",
		function (c)
			-- The client currently has the input focus, so it cannot be
			-- minimized, since minimized clients can't have the focus.
			c.minimized = true
		end ,
		{description = "minimize", group = "client"}),
	awful.key({ modkey,		   }, "m",
		function (c)
			c.maximized = not c.maximized
			c:raise()
		end ,
		{description = "maximize", group = "client"})
)

-- @DOC_NUMBER_KEYBINDINGS@
-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = awful.util.table.join(globalkeys,
		-- View tag only.
		awful.key({ modkey }, "#" .. i + 9,
				  function ()
						local screen = awful.screen.focused()
						local tag = screen.tags[i]
						if tag then
						   tag:view_only()
						end
				  end,
				  {description = "view tag #"..i, group = "tag"}),
		-- Toggle tag display.
		awful.key({ modkey, "Control" }, "#" .. i + 9,
				  function ()
					  local screen = awful.screen.focused()
					  local tag = screen.tags[i]
					  if tag then
						 awful.tag.viewtoggle(tag)
					  end
				  end,
				  {description = "toggle tag #" .. i, group = "tag"}),
		-- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + 9,
				  function ()
					  if client.focus then
						  local tag = client.focus.screen.tags[i]
						  if tag then
							  client.focus:move_to_tag(tag)
						  end
					 end
				  end,
				  {description = "move focused client to tag #"..i, group = "tag"}),
		-- Toggle tag on focused client.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
				  function ()
					  if client.focus then
						  local tag = client.focus.screen.tags[i]
						  if tag then
							  client.focus:toggle_tag(tag)
						  end
					  end
				  end,
				  {description = "toggle focused client on tag #" .. i, group = "tag"})
	)
end

-- @DOC_CLIENT_BUTTONS@
clientbuttons = awful.util.table.join(
	awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
	awful.button({ modkey }, 1, awful.mouse.client.move),
	awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
-- @DOC_RULES@
awful.rules.rules = {
	-- @DOC_GLOBAL_RULE@
	-- All clients will match this rule.
	{ rule = { },
	  properties = { border_width = beautiful.border_width,
					 border_color = beautiful.border_normal,
					 focus = awful.client.focus.filter,
					 raise = true,
					 keys = clientkeys,
					 buttons = clientbuttons,
					 screen = awful.screen.preferred,
					 placement = awful.placement.no_overlap+awful.placement.no_offscreen } },
    {
      rule = { class = "Xfce4-panel" },
	  properties = { border_width = 0 }
	},
    {
      rule = { class = "Xfdesktop" },
	  properties = {
		border_width = 0,
	    sticky = true,
	  }
    },

	-- @DOC_FLOATING_RULE@
	-- Floating clients.
	{ rule_any = {
		instance = {
		  "copyq",  -- Includes session name in class.
		},
		class = {
		  "Arandr"
	    },

		name = {
		  "Event Tester",  -- xev.
		},
		role = {
		  "pop-up",	   -- e.g. Google Chrome's (detached) Developer Tools.
		}
	  }, properties = { floating = true }},

	-- @DOC_DIALOG_RULE@
	{ rule_any = {type = { "normal", "dialog" }
	  }, properties = { titlebars_enabled = false }
	},
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
-- @DOC_MANAGE_HOOK@
client.connect_signal("manage", function (c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end

	if awesome.startup and
	  not c.size_hints.user_position
	  and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- @DOC_TITLEBARS@
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
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

	awful.titlebar(c) : setup {
		{ -- Left
			awful.titlebar.widget.iconwidget(c),
			buttons = buttons,
			layout  = wibox.layout.fixed.horizontal
		},
		{ -- Middle
			{ -- Title
				align  = "center",
				widget = awful.titlebar.widget.titlewidget(c)
			},
			buttons = buttons,
			layout  = wibox.layout.flex.horizontal
		},
		{ -- Right
			awful.titlebar.widget.floatingbutton (c),
			awful.titlebar.widget.maximizedbutton(c),
			awful.titlebar.widget.stickybutton   (c),
			awful.titlebar.widget.ontopbutton	(c),
			awful.titlebar.widget.closebutton	(c),
			layout = wibox.layout.fixed.horizontal()
		},
		layout = wibox.layout.align.horizontal
	}
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
		and awful.client.focus.filter(c) then
		client.focus = c
	end
end)

-- @DOC_BORDER@
client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)
-- }}}

