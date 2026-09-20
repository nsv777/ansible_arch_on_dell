------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "DP-1",
    mode     = "highres",
    position = "0x0",
    scale    = 2,
})
-- Default laptop screen
hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})
-- External monitor
hl.on("monitor.added", function(m)
    if m.name == "DP-1" then
        -- Force 4K mode first
        hl.monitor({ output = "DP-1", mode = "3840x2160@60.00", position = "0x0", scale = 2 })
        -- Then disable the laptop screen
        hl.monitor({ output = "eDP-1", disabled = true })
    end
end)

-- Re-enable the laptop screen if the external monitor is unplugged
hl.on("monitor.removed", function(m)
    if m.name == "DP-1" then
        hl.monitor({
            output = "eDP-1",
            disabled = false,
            mode = "preferred",
            position = "auto",
            scale = "auto"
        })
    end
end)
