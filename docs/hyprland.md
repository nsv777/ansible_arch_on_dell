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
