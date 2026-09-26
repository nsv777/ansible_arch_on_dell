# Hyprland decisions

## Waybar workspace layout indicator

The `custom/hyprland-layout` module displays the first two letters of the
active workspace's `tiledLayout` (`dw`, `ma`, `sc`, or `mo`). It polls
Hyprland's active-workspace JSON once per second and hides itself when no
layout is available. This follows the per-workspace layout switched by
`Alt+Tab`.

## Hypridle startup

Start Hypridle from the `hyprland.start` callback. Do not enable its user
systemd service: GDM can start that service against its own Wayland compositor
before Hyprland starts, causing Hypridle to fail because the idle protocol is
not available. The callback starts it after Hyprland exposes the idle protocol.

For lid-close suspend, use `loginctl lock-session` as Hypridle's
`before_sleep_cmd`. This sends the D-Bus lock event to `lock_cmd`. Set
`inhibit_sleep = 3` so logind waits until Hyprlock confirms that it owns the
lock surface before suspending. Turn DPMS back on after wake.

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
beside one another. The keyboard-layout label is centered 6% to the right of
the screen center, alongside the centered 15%-wide password field.

Hyprlock does not apply Hyprland monitor scale to label fonts. The layout
indicator has a font-size specific to each supported output: `42` on the Dell
S2722QC at scale `1.67`, and `25` on the eDP-1 laptop panel at scale `1`.

## Wallpaper changer backend

The wallpaper changer uses hyprpaper when a running Hyprland instance is
available. It sets hyprpaper's fallback wallpaper, which covers outputs without
a monitor-specific wallpaper. In other sessions, it uses the configured
GSettings schema.

Hyprpaper splash text is disabled in the managed `hyprpaper.conf`.

## Default wallpaper

Disable Hyprland's default wallpaper (`misc:force_default_wallpaper = 0`).
It draws anime mascot with random quote text on desktop. Use hyprpaper instead.
Also set `misc:disable_splash_rendering = true` to kill small random quote text
when no wallpaper layer covers background. Hyprpaper splash stays off in
managed `hyprpaper.conf`.
