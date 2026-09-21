------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- hyprctl monitors
local external_monitor_model = "DELL S2722QC"
local external_monitor_selector = "desc:Dell Inc. " .. external_monitor_model
local internal_monitor_output = "eDP-1"
local internal_monitor_scale_by_description = {
    ["Chimei Innolux Corporation 0x140A"] = 1,
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

hl.monitor({
    output   = external_monitor_selector,
    mode     = "3840x2160@60.00",
    position = "0x0",
    scale    = 1.67,
})

configure_connected_internal_monitor()

-- External monitor
hl.on("monitor.added", function(m)
    if m.name == internal_monitor_output then
        configure_internal_monitor(m)
    elseif is_external_monitor(m) then
        use_external_monitor()
    end
end)

hl.on("hyprland.start", function()
    configure_connected_internal_monitor()

    local monitor = hl.get_monitor(external_monitor_selector)
    if monitor ~= nil then
        use_external_monitor()
    end
end)

-- Re-enable the laptop screen if the external monitor is unplugged
hl.on("monitor.removed", function(m)
    if is_external_monitor(m) then
        set_internal_monitor_disabled(false)
    end
end)
