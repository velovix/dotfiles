-- paperlike, an awesome 3 theme by Tyler Compton

--{{{ Main
local awful = require("awful")
awful.util = require("awful.util")

theme = {}

home          = os.getenv("HOME")
config        = awful.util.getdir("config")
shared        = "/usr/share/awesome"
if not awful.util.file_readable(shared .. "/icons/awesome16.png") then
    shared    = "/usr/share/local/awesome"
end
sharedicons   = shared .. "/icons"
sharedthemes  = shared .. "/themes"
themes        = config
themename     = "/paperlike"
if not awful.util.file_readable(themes .. themename .. "/theme.lua") then
       themes = sharedthemes
end
themedir      = themes .. themename

wallpaper1    = themes .. themename .. "/background.jpeg"
wpscript      = home .. "/.wallpaper"

if awful.util.file_readable(wallpaper1) then
  theme.wallpaper = wallpaper1
elseif awful.util.file_readable(wallpaper2) then
  theme.wallpaper = wallpaper2
elseif awful.util.file_readable(wpscript) then
  theme.wallpaper_cmd = { "sh " .. wpscript }
end
--}}}

theme.font          = "Noto Sans 8"

theme.bg_normal     = "#959186"
theme.bg_focus      = "#fdf6e3"
theme.bg_urgent     = "#fdf6e3"
theme.bg_minimize   = "#959186"

theme.fg_normal     = "#eee8d5"
theme.fg_focus      = "#002b36"
theme.fg_urgent     = "#fc736d"
theme.fg_minimize   = "#eee8d5"

theme.border_width  = "4"
theme.border_normal = "#959186"
theme.border_focus  = "#eee8d5"
theme.border_marked = "#052F52FF"

-- Display the taglist squares
theme.taglist_squares_sel   = themedir .. "/taglist/focus.png"
theme.taglist_squares_unsel = themedir .. "/taglist/unfocus.png"

-- Awesome icon
theme.awesome_icon = themedir .. "/awesome-icon.png"

-- Layout icons
theme.layout_fairh = themedir .. "/layouts/fairh.png"
theme.layout_fairv = themedir .. "/layouts/fairv.png"
theme.layout_floating  = themedir .. "/layouts/floating.png"
theme.layout_magnifier = themedir .. "/layouts/magnifier.png"
theme.layout_max = themedir .. "/layouts/max.png"
theme.layout_fullscreen = themedir .. "/layouts/fullscreen.png"
theme.layout_tilebottom = themedir .. "/layouts/tilebottom.png"
theme.layout_tileleft   = themedir .. "/layouts/tileleft.png"
theme.layout_tile = themedir .. "/layouts/tile.png"
theme.layout_tiletop = themedir .. "/layouts/tiletop.png"
theme.layout_spiral  = themedir .. "/layouts/spiral.png"
theme.layout_dwindle = themedir .. "/layouts/dwindle.png"

return theme

