# Hyprland decisions

## External monitor identity

Identify the Dell S2722QC by its EDID model instead of its DisplayPort connector.
Connector names can change between `DP-1`, `DP-3`, and other ports.

Hyprland's Lua monitor object does not expose `model` directly. Use the
`desc:Dell Inc. DELL S2722QC` selector for static rules, match `DELL S2722QC`
inside `monitor.description` in callbacks.

Built-in panel parameters use a `desc:<description>` selector generated from
the panel connected as `eDP-1`. This lets each laptop use its own EDID and
preferred resolution. Runtime disable and enable operations use the stable
built-in output name `eDP-1`.

The `Chimei Innolux Corporation 0x140A` panel uses scale `1`. Other built-in
panel descriptions use automatic scaling.

## Mako notification lifetime

Mako notifications remain visible until the user left-clicks them. The shared
Mako configuration ignores expiry timeouts requested by applications.

## Hyprlock widget placement

Use output-relative percentage positions for Hyprlock widgets that are placed
beside one another. The keyboard-layout label is centered 9% to the right of
the screen center, alongside the centered 15%-wide password field.

## Wallpaper changer backend

The wallpaper changer uses hyprpaper when a running Hyprland instance is
available. It sets hyprpaper's fallback wallpaper, which covers outputs without
a monitor-specific wallpaper. In other sessions, it uses the configured
GSettings schema.

Hyprpaper splash text is disabled in the managed `hyprpaper.conf`.
