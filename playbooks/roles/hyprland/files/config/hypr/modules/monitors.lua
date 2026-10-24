------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- hyprctl monitors all
local external_monitor_model    = "DELL S2722QC"
local external_monitor_selector = "desc:Dell Inc. " .. external_monitor_model
local external_monitor_mode     = "3840x2160@60"
local external_monitor_scale    = 1.67
local internal_monitor_output   = "eDP-1"
local internal_monitor_scale_by_description = {
    -- Lenovo ThinkPad
    ["Chimei Innolux Corporation 0x140A"] = 1,
    -- Dell XPS 13
    ["Sharp Corporation 0x144A"] = 1.67,
}

local function is_external_monitor(monitor)
    return monitor.description ~= nil
        and monitor.description:find(external_monitor_model, 1, true) ~= nil
end

local function configure_internal_monitor(monitor)
    hl.monitor({
        output   = "desc:" .. monitor.description,
        mode     = "preferred",
        position = "auto",
        scale    = internal_monitor_scale_by_description[monitor.description] or "auto",
    })
end

local function configure_connected_internal_monitor()
    local monitor = hl.get_monitor(internal_monitor_output)
    if monitor ~= nil then
        configure_internal_monitor(monitor)
    end
end

local function set_internal_monitor_disabled(disabled)
    hl.monitor({ output = internal_monitor_output, disabled = disabled })
end

local function use_external_monitor()
    set_internal_monitor_disabled(true)
end

local function apply_external_monitor_mode()
    hl.monitor({
        output   = external_monitor_selector,
        mode     = external_monitor_mode,
        position = "auto",
        scale    = external_monitor_scale,
    })
end

-- Hyprland applies monitor rules while eDP-1 is still enabled. A pinned
-- 3840x2160 mode can fail in that state and silently fall back to 2560x1440,
-- and Hyprland records the requested rule as applied, so no later config pass
-- retries it. Re-apply the mode once eDP-1 is off; the different mode is a hard
-- rule change, which forces a real modeset.
local function pin_external_monitor_mode()
    hl.timer(function()
        local monitor = hl.get_monitor(external_monitor_selector)
        if monitor == nil or monitor.width ~= 3840 or math.abs(monitor.refresh_rate - 60) > 1 then
            apply_external_monitor_mode()
        end
    end, { timeout = 1500, type = "oneshot" })
end

-- Startup rule. The exact mode is pinned by pin_external_monitor_mode().
hl.monitor({
    output   = external_monitor_selector,
    mode     = "preferred",
    position = "auto",
    scale    = external_monitor_scale,
})

-- External monitor
hl.on("monitor.added", function(m)
    if m.name == internal_monitor_output then
        configure_internal_monitor(m)
    elseif is_external_monitor(m) then
        use_external_monitor()
        pin_external_monitor_mode()
    end
end)

hl.on("hyprland.start", function()
    configure_connected_internal_monitor()

    if hl.get_monitor(external_monitor_selector) ~= nil then
        use_external_monitor()
        pin_external_monitor_mode()
    end
end)

-- Re-enable the laptop screen if the external monitor is unplugged
hl.on("monitor.removed", function(m)
    if not is_external_monitor(m) then
        return
    end

    local internal = hl.get_monitor(internal_monitor_output)
    if internal ~= nil then
        configure_internal_monitor(internal)
    else
        set_internal_monitor_disabled(false)
    end
end)
