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

local function apply_external_monitor_mode(mode)
    hl.monitor({
        output   = external_monitor_selector,
        mode     = mode,
        position = "auto",
        scale    = external_monitor_scale,
    })
end

local external_retry_generation = 0
local function pin_external_monitor_mode()
    external_retry_generation = external_retry_generation + 1
    local generation = external_retry_generation
    hl.timer(function()
        -- Do not apply a timer from a previous connection to a replugged Dell.
        if generation ~= external_retry_generation then
            return
        end
        local monitor = hl.get_monitor(external_monitor_selector)
        if monitor ~= nil and (monitor.width ~= 3840 or monitor.height ~= 2160
            or math.abs(monitor.refresh_rate - 60) > 1) then
            -- Request an i915 link retrain before trying 4K60 again.
            os.execute("sudo -n /usr/local/sbin/dp-link-retrain")
            apply_external_monitor_mode(external_monitor_mode)
        end
    end, { timeout = 1500, type = "oneshot" })
end

local function use_external_monitor()
    set_internal_monitor_disabled(true)
    -- A failed modeset can leave 4K60 cached as the requested rule even
    -- after fallback. Reset to preferred so the timer submits a different
    -- rule once eDP-1 is off, forcing a new modeset if needed.
    apply_external_monitor_mode("preferred")
    pin_external_monitor_mode()
end

-- Config reloads re-run this file without firing the startup/hotplug events.
configure_connected_internal_monitor()
if hl.get_monitor(external_monitor_selector) ~= nil then
    use_external_monitor()
else
    apply_external_monitor_mode("preferred")
end

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

    if hl.get_monitor(external_monitor_selector) ~= nil then
        use_external_monitor()
    end
end)

-- Re-enable the laptop screen if the external monitor is unplugged
hl.on("monitor.removed", function(m)
    if not is_external_monitor(m) then
        return
    end

    external_retry_generation = external_retry_generation + 1
    local internal = hl.get_monitor(internal_monitor_output)
    if internal ~= nil then
        configure_internal_monitor(internal)
    else
        set_internal_monitor_disabled(false)
    end
end)
