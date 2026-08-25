-- Extra autostart processes. Omarchy already starts the shell, udiskie, the
-- monitor watcher, and the clipboard history watcher.

-- o.launch_on_start("dropbox-cli start")

-- Applies the nightlight schedule in hypr/hyprsunset.conf.
o.launch_on_start("hyprsunset")

-- Hibernates on long idle, which the shell's idle settings do not cover. See
-- hypr/hypridle.conf.
o.launch_on_start("hypridle")
