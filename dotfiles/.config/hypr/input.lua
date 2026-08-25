-- Personal input overrides. Omarchy's defaults live in
-- $OMARCHY_PATH/default/hypr/input.lua, and everything set here replaces them.
-- See https://wiki.hypr.land/Configuring/Basics/Variables/#input

hl.config({
  input = {
    -- Second layout is Colemak-DH ortho. Left Alt + Right Alt switches between
    -- the two. Omarchy's kb_options come from /etc/vconsole.conf, so they are
    -- repeated here alongside the group toggle.
    kb_layout = "us,us",
    kb_variant = ",colemak_dh_ortho",
    kb_options = "compose:caps,shift:both_capslock_cancel,grp:alts_toggle",

    -- Increase sensitivity for mouse/trackpad (default: 0).
    sensitivity = 0.50,

    -- Turn off mouse acceleration (default: adaptive).
    accel_profile = "flat",

    touchpad = {
      tap_to_click = false,

      -- Typing on this keyboard rests a palm near the pad without brushing it,
      -- so the lockout swallows more deliberate scrolls than stray cursors.
      disable_while_typing = false,
    },
  },

  misc = {
    -- Wake the displays on a key press, but not on a nudged mouse.
    mouse_move_enables_dpms = false,
  },
})

-- Scroll nicely in the terminal. Omarchy already sets scroll_touchpad here.
o.window("(Alacritty|kitty|foot)", { scroll_mouse = 1.5 })
