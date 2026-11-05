-- Change the default Omarchy look'n'feel.
-- See https://wiki.hypr.land/Configuring/Basics/Variables/

hl.config({
  decoration = {
    -- The 0.05 gap is what marks the focused window.
    active_opacity = 0.90,
    inactive_opacity = 0.85,

    -- Translucency without blur makes text unreadable over these wallpapers.
    blur = {
      enabled = true,
      size = 6,
      passes = 2,
    },

    shadow = {
      enabled = true,
      range = 20,
      render_power = 4,
      color = "rgba(05090a99)",
      color_inactive = "rgba(05090a66)",
    },
  },

  general = {
    gaps_in = 2,
    gaps_out = 4,
  },

  master = {
    mfact = 0.6,

    -- New windows land on top of the stack, so closing one leaves the most
    -- recent window active.
    new_on_top = true,
  },

  misc = {
    -- Monocle on SUPER + ALT + F (Full width): closing the maximized window
    -- maximizes the next one. Omarchy already has new windows take it over.
    exit_window_retains_fullscreen = true,
  },
})

-- Opt another application in to Omarchy's standard transparency.
-- Find its class with: hyprctl clients
-- o.transparent_window("my-app")
-- o.transparent_window("my-app", "0.9 0.85") -- Custom active/inactive opacity.
