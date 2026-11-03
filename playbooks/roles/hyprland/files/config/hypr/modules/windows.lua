--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

hl.window_rule({
    name  = "float-calculator",
    match = { class = "^(org\\.gnome\\.Calculator|[Gg]alculator)$" },

    float    = true,
    move     = { "(monitor_w-window_w)", "(monitor_h-window_h)*0.5" },
    size     = { 400, 550 },
    min_size = { 400, 550 },
    max_size = { 400, 550 },
})

hl.window_rule({
    name  = "zstray-workspace-10",
    match = { class = "^ZSTray6$" },

    workspace = "10",
})

hl.window_rule({
    name  = "freelens-workspace-3",
    match = { class = "^freelens$" },

    workspace = "3",
})

hl.window_rule({
    name  = "float-zoom-annotate-toolbar",
    match = { class = "zoom", title = "annotate_toolbar" },

    float = true,
    size  = { 40, 40 },
    workspace = "10",
})

hl.window_rule({
    name  = "float-zoom-annotate-toolbar",
    match = { class = "zoom", title = "Zoom Workplace" },

    float = true,
    size  = { 400, 80 },
    workspace = "10",
})
