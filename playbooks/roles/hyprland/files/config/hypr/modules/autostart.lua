-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:

hl.on("hyprland.start", function ()
--   hl.exec_cmd(terminal)
--   hl.exec_cmd("nm-applet")
  hl.exec_cmd("waybar & hyprpaper")
  hl.exec_cmd("blueman-applet")
  hl.exec_cmd("pgrep -x hypridle >/dev/null || hypridle")
  hl.exec_cmd("hyprland-per-window-layout")
  hl.exec_cmd("/opt/zscaler/bin/ZSTray")
  hl.exec_cmd("slack")
  hl.exec_cmd("firefox")
  hl.exec_cmd("foot")
  hl.exec_cmd("nextcloud")
end)
