---------------------
---- KEYBINDINGS ----
---------------------

-- xkbcli interactive-wayland
local mainMod = "SUPER" -- Main modifier
local altMod = "ALT" -- Alternative modifier

local terminal = "foot"
local fileManager = "nemo"
local menu = "rofi -show run"

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(altMod .. " + Q", hl.dsp.exec_cmd(terminal))
local closeWindowBind = hl.bind(mainMod .. " + C", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(altMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))    -- dwindle only

-- Move focus with mainMod + arrow keys
hl.bind(altMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(altMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(altMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(altMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Move active window to a workspace with Alt + Shift + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(altMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(altMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(altMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + bracketright", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + bracketleft",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(altMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(altMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
-- hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 10%+"),                  { locked = true, repeating = true })
-- hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 10%-"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


-- Set the active Dwindle split ratio to 0.75
hl.bind(mainMod .. " + Z", hl.dsp.layout("splitratio 0.75 exact"))

-- Resize active window with Alt + Shift + Arrows
-- hl.bind(mainMod .. " + SHIFT + right", function() hl.dispatch("resizeactive", "40 0") end)
-- hl.bind(mainMod .. " + SHIFT + left", function() hl.dispatch("resizeactive", "-40 0") end)
-- hl.bind(mainMod .. " + SHIFT + up", function() hl.dispatch("resizeactive", "0 -40") end)
-- hl.bind(mainMod .. " + SHIFT + down", function() hl.dispatch("resizeactive", "0 40") end)
-- hl.bind(mainMod .. " + SHIFT", hl.dsp.submap("resize"))
-- hl.define_submap("resize", function()
-- 	hl.bind("L", hl.dsp.window.resize({ x = 40, y = 0, relative = true }), { repeating = true })
-- 	hl.bind("H", hl.dsp.window.resize({ x = -40, y = 0, relative = true }), { repeating = true })
-- 	hl.bind("K", hl.dsp.window.resize({ x = 0, y = -40, relative = true }), { repeating = true })
-- 	hl.bind("J", hl.dsp.window.resize({ x = 0, y = 40, relative = true }), { repeating = true })
-- 	hl.bind("escape", hl.dsp.submap("reset"))
-- 	hl.bind("Return", hl.dsp.submap("reset"))
-- end)
-- Switch to a submap called `resize`.
hl.bind(altMod .. " + X", hl.dsp.submap("resize"))

-- Start a submap called "resize".
hl.define_submap("resize", function()

    -- Set repeating binds for resizing the active window.
    hl.bind("right", hl.dsp.window.resize({ x = 100, y = 0, relative = true}), { repeating = true })
    hl.bind("left", hl.dsp.window.resize({ x = -100, y = 0, relative = true}), { repeating = true })
    hl.bind("up", hl.dsp.window.resize({ x = 0, y = 100, relative = true}), { repeating = true })
    hl.bind("down", hl.dsp.window.resize({ x = 0, y = -100, relative = true}), { repeating = true })

    -- Use `reset` to go back to the global submap
    hl.bind("escape", hl.dsp.submap("reset"))

end)

-- Move/rearrange active window with Alt + Ctrl + Arrows
hl.bind(altMod .. " + CTRL + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(altMod .. " + CTRL + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(altMod .. " + CTRL + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(altMod .. " + CTRL + down", hl.dsp.window.move({ direction = "down" }))

hl.bind("ALT + F4", hl.dsp.window.close())
hl.bind("F12", hl.dsp.exec_cmd("guake-toggle"))
hl.bind("CONTROL + ALT + L", hl.dsp.exec_cmd("~/.local/bin/lock"))


-- Cycle layouts for current workspace
hl.bind(altMod .. " + tab", function ()
    local layouts   = { "scrolling", "dwindle", "master", "monocle" }
    local workspace = hl.get_active_workspace()
    if hl.get_active_special_workspace() then
        workspace = hl.get_active_special_workspace()
    end

    local next_layout = "dwindle"

    if not workspace then
        return
    end

    for i = 1, #layouts do
        if layouts[i] == workspace.tiled_layout then
            local next_layout_idx = (i % #layouts) + 1
            next_layout = layouts[next_layout_idx]
            break
        end
    end

    if workspace.special then
        hl.workspace_rule({ workspace = tostring(workspace.name), layout = next_layout })
    else
        hl.workspace_rule({ workspace = "name:" .. tostring(workspace.name), layout = next_layout })
    end
end)

hl.bind("SUPER + escape", hl.dsp.submap("logout"))

hl.on("keybinds.submap", function(name)
	if name == "logout" then
		hl.notification.create({
			text = "c - reload\ne - exit\nr - reboot\ns - suspend\nS - poweroff\nl - lock",
			duration = 4500,
			color = "rgb(34E2E2)",
			font_size = 18,
		})
	end
end)

hl.define_submap("logout", function()
	hl.bind("C", function()
		hl.dispatch(hl.dsp.submap("reset"))
		hl.dispatch(hl.dsp.exec_cmd("hyprctl dismissnotify"))
		hl.dispatch(hl.dsp.exec_cmd("hyprctl reload"))
	end)
	hl.bind("E", function()
		hl.dispatch(hl.dsp.submap("reset"))
		hl.dispatch(hl.dsp.exec_cmd("hyprctl dismissnotify"))
		hl.dispatch(hl.dsp.exit())
	end)
	hl.bind("S", function()
		hl.dispatch(hl.dsp.submap("reset"))
		hl.dispatch(hl.dsp.exec_cmd("hyprctl dismissnotify"))
		hl.dispatch(hl.dsp.exec_cmd("~/.local/bin/suspend"))
	end)
	hl.bind("R", function()
		hl.dispatch(hl.dsp.submap("reset"))
		hl.dispatch(hl.dsp.exec_cmd("hyprctl dismissnotify"))
		hl.dispatch(hl.dsp.exec_cmd("systemctl reboot"))
	end)
	hl.bind("SHIFT + S", function()
		hl.dispatch(hl.dsp.submap("reset"))
		hl.dispatch(hl.dsp.exec_cmd("hyprctl dismissnotify"))
		hl.dispatch(hl.dsp.exec_cmd("systemctl poweroff -i"))
	end)
	hl.bind("L", function()
		hl.dispatch(hl.dsp.exec_cmd("hyprctl dismissnotify"))
		hl.dispatch(hl.dsp.exec_cmd("~/.local/bin/lock"))
		hl.dispatch(hl.dsp.submap("reset"))
	end)
	hl.bind("escape", function()
		hl.dispatch(hl.dsp.exec_cmd("hyprctl dismissnotify"))
		hl.dispatch(hl.dsp.submap("reset"))
	end)
	hl.bind("Return", function()
		hl.dispatch(hl.dsp.exec_cmd("hyprctl dismissnotify"))
		hl.dispatch(hl.dsp.submap("reset"))
	end)
end)
