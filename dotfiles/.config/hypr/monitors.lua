-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

-- Optimized for retina-class 2x displays, like 13" 2.8K, 27" 5K, 32" 6K.
hl.env("GDK_SCALE", "2")

-- Catch-all for a display with no rule of its own below.
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

-- Rules naming an output that is not connected are inert - the workspace rules
-- included - so every machine's displays live here and each applies only its own.

-- Laptop. HDMI-A-1 hangs off the dGPU, so it stays dark whenever that card is kept
-- out of the session (see ~/.config/uwsm/env-hyprland).
hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 1.2 })
hl.monitor({ output = "eDP-2", mode = "preferred", position = "auto", scale = 1 })
hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "auto", scale = 1 })
hl.workspace_rule({
  workspace = "1",
  monitor = "eDP-1",
  default = true,
  on_created_empty = "omarchy-launch-terminal",
})

-- Desktop
hl.monitor({ output = "HDMI-A-2", mode = "preferred", position = "auto", scale = 1 })
hl.workspace_rule({
  workspace = "1",
  monitor = "HDMI-A-2",
  default = true,
  on_created_empty = "omarchy-launch-terminal",
})

-- Mirror display
-- hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1, mirror = "eDP-1" })
