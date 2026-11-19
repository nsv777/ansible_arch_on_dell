-- Run from the repository root: lua tests/hyprland/monitors.lua
local config = "playbooks/roles/hyprland/files/config/hypr/modules/monitors.lua"
local selector = "desc:Dell Inc. DELL S2722QC"

local function check_recovery(trigger)
    local panel = { name = "eDP-1", description = "Chimei Innolux Corporation 0x140A" }
    local dell = {
        name = "DP-3", description = "Dell Inc. DELL S2722QC 2DK2J24",
        width = 2560, height = 1440, refresh_rate = 59.951,
    }
    local callbacks, timers = {}, {}
    local connected = trigger == "reload" or trigger == "startup" or trigger == "already 4k"
    if trigger == "already 4k" then
        dell.width, dell.height, dell.refresh_rate = 3840, 2160, 59.997
    end
    local active_mode = "3840x2160@60" -- Requested rule cached despite fallback.
    local pending_mode, pending_panel_rule
    local panel_disabled, panel_scale, link_ready = false, nil, false
    local retrain_count = 0
    local retrain_allowed = trigger ~= "quick replug"

    local function frame()
        if pending_panel_rule ~= nil then
            panel_disabled = pending_panel_rule.disabled == true
            panel_scale = pending_panel_rule.scale
        end
        -- Hyprland does not modeset for an identical requested rule, even
        -- when the actual output mode differs from that rule.
        if connected and pending_mode and pending_mode ~= active_mode then
            active_mode = pending_mode
            if link_ready and panel_disabled then
                dell.width, dell.height, dell.refresh_rate = 3840, 2160, 59.997
            end
        end
        pending_mode, pending_panel_rule = nil, nil
    end

    local load_config = assert(loadfile(config, "t", {
        hl = {
            get_monitor = function(output)
                if output == panel.name then return panel end
                if output == selector and connected then return dell end
            end,
            monitor = function(rule)
                if rule.output == selector then pending_mode = rule.mode end
                if rule.output == panel.name or rule.output == "desc:" .. panel.description then
                    pending_panel_rule = rule
                end
            end,
            on = function(event, callback) callbacks[event] = callback end,
            timer = function(callback) timers[#timers + 1] = callback end,
        },
        os = {
            execute = function(command)
                assert(command == "sudo -n /usr/local/sbin/dp-link-retrain")
                retrain_count = retrain_count + 1
                link_ready = retrain_allowed
            end,
        },
        math = math,
    }))

    load_config()
    if trigger == "startup" then
        callbacks["hyprland.start"]()
    elseif not connected then
        frame()
        connected = true
        callbacks["monitor.added"](dell)
    end
    frame()
    if trigger == "quick replug" or trigger == "unplug" then
        connected = false
        callbacks["monitor.removed"](dell)
        frame()
        assert(not panel_disabled and panel_scale == 1, "ThinkPad panel scale was not restored")
        if trigger == "quick replug" then
            connected = true
            callbacks["monitor.added"](dell)
            frame()
        end
    end
    for _, callback in ipairs(timers) do
        callback()
        frame()
        retrain_allowed = true
    end

    if trigger == "unplug" or trigger == "already 4k" then
        assert(retrain_count == 0, trigger .. ": unnecessary link retrain")
    end
    if connected then
        assert(dell.width == 3840 and dell.height == 2160 and math.abs(dell.refresh_rate - 60) < 1,
            trigger .. ": Dell stayed at " .. dell.width .. "x" .. dell.height .. "@" .. dell.refresh_rate)
        assert(panel_disabled, trigger .. ": laptop panel was not disabled")
    end
end

check_recovery("replug")
check_recovery("reload")
check_recovery("quick replug")
check_recovery("startup")
check_recovery("unplug")
check_recovery("already 4k")
print("Hyprland monitor recovery checks passed")
