pcall(require, "luarocks.loader")
local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")
local terminal_command = "kitty"

local function notify_error(err)
    naughty.notify({ 
	preset = naughty.config.presets.critical,
	title = "Error",
	text = tostring(err)
    })
end

if awesome.startup_errors then notify_error(awesome.startup_errors) end
awesome.connect_signal("debug::error", notify_error)

local function setup_root_interactions()
	local function launch_terminal()
		awful.spawn("kitty")
	end

	local function restart_awesome()
		awesome.restart()
	end

	local keys = gears.table.join(
	    awful.key({"Mod4"}, "Return", launch_terminal),
	    awful.key({"Mod4", "Control"}, "r", restart_awesome)
	)

	root.keys(keys)
end

local function setup_screen_tags(screen)
	awful.tag({""}, screen, awful.layout.suit.fair)
end

local function setup_client_placement(client)
	awful.placement.no_offscreen(client)
	client:move_to_screen(awful.screen.preferred(client))
end


local function setup_client_interactions(client)
	local function raise_client(client)
		client:emit_signal("request::activate", "mouse_click", { raise = true })
	end

	local function client_kill(client)
		client:kill()
	end

	local buttons = gears.table.join(
		awful.button({}, 1, raise_client)
	)

	local keys = gears.table.join(
		awful.key({"Mod4"}, "q", client_kill)
	);

	client:buttons(buttons)
	client:keys(keys)
end

setup_root_interactions()
client.connect_signal("manage", setup_client_interactions)
client.connect_signal("manage", setup_client_placement)
awful.screen.connect_for_each_screen(setup_screen_tags)

