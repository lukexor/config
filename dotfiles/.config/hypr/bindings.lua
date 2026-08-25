-- Personal keybinding overrides. Omarchy's defaults live in
-- $OMARCHY_PATH/default/hypr/bindings/ and are listed by:
--   omarchy menu keybindings --print
--
-- A key Omarchy already binds has to be released with hl.unbind before it can
-- be reused, so every override below that touches a default key is paired.

-- Vim-style focus. Omarchy puts the split toggle, the keybindings menu, and the
-- workspace-layout toggle on J, K, and L.
hl.unbind("SUPER + J")
hl.unbind("SUPER + K")
hl.unbind("SUPER + L")
o.bind("SUPER + H", "Move focus left", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + J", "Move focus down", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + K", "Move focus up", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + L", "Move focus right", hl.dsp.focus({ direction = "r" }))

o.bind("SUPER + SHIFT + H", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + SHIFT + J", "Swap window down", hl.dsp.window.swap({ direction = "d" }))
o.bind("SUPER + SHIFT + K", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + SHIFT + L", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))

-- Cycling has to raise the window it lands on, or a stacked window stays buried.
hl.unbind("SUPER + P")
o.bind("SUPER + P", "Previous window", function()
  hl.dispatch(hl.dsp.window.cycle_next({ next = false }))
  hl.dispatch(hl.dsp.window.bring_to_top())
end)
o.bind("SUPER + N", "Next window", function()
  hl.dispatch(hl.dsp.window.cycle_next())
  hl.dispatch(hl.dsp.window.bring_to_top())
end)

-- SUPER + J is focus, so the split toggle takes a modifier.
o.bind("SUPER + CTRL + J", "Toggle window split", hl.dsp.layout("togglesplit"))

-- Monocle keeps the fullscreen window fullscreen as new windows arrive, which
-- Omarchy's tiled-fullscreen toggle does not.
hl.unbind("SUPER + CTRL + F")
o.bind("SUPER + CTRL + F", "Toggle monocle", os.getenv("HOME") .. "/bin/toggle-monocle")

-- Keybindings cheat sheet, on the chord SUPER + K used to answer.
hl.unbind("SUPER + CTRL + K")
o.bind("SUPER + CTRL + K", "Show key bindings", "omarchy-menu-keybindings")

-- Move the current workspace between monitors, taking the comma and period pair
-- from Omarchy's notification bindings.
hl.unbind("SUPER + SHIFT + comma")
o.bind("SUPER + SHIFT + comma", "Move workspace to next monitor", hl.dsp.workspace.move({ monitor = "+1" }))
o.bind("SUPER + SHIFT + period", "Move workspace to previous monitor", hl.dsp.workspace.move({ monitor = "-1" }))

-- System
-- Reloading twice clears an Nvidia hang after suspend.
o.bind("SUPER + SHIFT + R", "Reload Hyprland", "hyprctl reload && hyprctl reload")
o.bind("SUPER + SHIFT + I", "Reload networking", "pkexec systemctl restart systemd-networkd systemd-resolved")
o.bind("SUPER + SHIFT + ESCAPE", "Suspend", "systemctl suspend")
o.bind("SUPER + CTRL + ESCAPE", "Reboot", "systemctl reboot")
o.bind("SUPER + SHIFT + CTRL + ESCAPE", "Power off", "systemctl poweroff")

-- Capture, on letters rather than the PRINT key. Omarchy's PRINT bindings are
-- left alone.
hl.unbind("SUPER + SHIFT + P")
o.bind("SUPER + SHIFT + P", "Screenshot of region", "omarchy-capture-screenshot region")
hl.unbind("SUPER + CTRL + P")
o.bind("SUPER + CTRL + P", "Screenshot of window", "omarchy-capture-screenshot windows")
o.bind("SUPER + SHIFT + CTRL + P", "Screenshot (smart)", "omarchy-capture-screenshot smart")
o.bind("SUPER + ALT + P", "Color picker", "pkill hyprpicker || hyprpicker -a")
o.bind("SUPER + ALT + R", "Screen record a region", "omarchy-capture-screenrecording")
hl.unbind("SUPER + CTRL + R")
o.bind("SUPER + CTRL + R", "Screen record display", "omarchy-capture-screenrecording --fullscreen")

-- Second chord for Omarchy's clipboard history, which also answers on
-- SUPER + CTRL + V.
o.bind("ALT + SHIFT + V", "Clipboard manager", "omarchy-shell shell toggle omarchy.clipboard")

-- Applications, where the wanted target differs from Omarchy's preinstalled one.
hl.unbind("SUPER + SHIFT + A")
o.bind("SUPER + SHIFT + A", "Claude", { webapp = "https://claude.ai" })
hl.unbind("SUPER + SHIFT + CTRL + A")
o.bind("SUPER + SHIFT + CTRL + A", "ChatGPT", { webapp = "https://chatgpt.com" })

hl.unbind("SUPER + SHIFT + C")
o.bind("SUPER + SHIFT + C", "Google Calendar", { webapp = "https://calendar.google.com" })
o.bind("SUPER + SHIFT + CTRL + C", "Outlook Calendar", { webapp = "https://outlook.office365.com/calendar" })

hl.unbind("SUPER + SHIFT + E")
o.bind("SUPER + SHIFT + E", "Gmail", { webapp = "https://gmail.com" })
o.bind("SUPER + SHIFT + CTRL + E", "Outlook", { webapp = "https://outlook.office365.com/mail" })

hl.unbind("SUPER + SHIFT + ALT + G")
o.bind("SUPER + SHIFT + ALT + G", "GitHub", { webapp = "https://github.com/lukexor" })

hl.unbind("SUPER + SHIFT + G")
o.bind("SUPER + SHIFT + G", "Steam", { launch = "steam" })
hl.unbind("SUPER + SHIFT + CTRL + G")
o.bind("SUPER + SHIFT + CTRL + G", "Lutris", { launch = "lutris" })

hl.unbind("SUPER + SHIFT + SLASH")
o.bind("SUPER + SHIFT + SLASH", "Passwords", { webapp = "https://lastpass.com/vault/" })

o.bind("SUPER + SHIFT + T", "Teams", { webapp = "https://gov.teams.microsoft.us/v2/" })
o.bind("SUPER + SHIFT + V", "VPN", { launch = "forticlient.desktop" })
o.bind("SUPER + SHIFT + CTRL + M", "Google Messages", { webapp = "https://messages.google.com/web/conversations", focus = true })

-- Same apps as the Omarchy defaults, on the chords already in the fingers.
o.bind("SUPER + SHIFT + CTRL + F", "File manager (cwd)", { omarchy = "nautilus-cwd" })
o.bind("SUPER + SHIFT + CTRL + B", "Browser (private)", { omarchy = "browser --private" })
o.bind("SUPER + SHIFT + CTRL + T", "Activity", { tui = "btop" })
