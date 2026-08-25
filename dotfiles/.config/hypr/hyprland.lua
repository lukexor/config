--
--                                    i  t
--                                   LE  ED.
--                                  L#E  E#K:
--                                 G#W.  E##W;
--                                D#K.   E#E##t
--                               E#K.    E#t ##f
--                             .E#E.     E#t  ;#D.
--                            .K#E       E#ELLE##K:
--                           .K#D        E#L;;;;;;,
--                          .W#G      .K E#t
--                         :W##########W E#t
--                         :,,,,,,,,,,,, .
--
--
--     Personal omarchy configuration of Luke Petherbridge <me@lukeworks.tech>

-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Load Omarchy defaults, which must not be edited directly.
require("default.hypr.omarchy")

-- Personal overrides. They load after the defaults so package updates can
-- improve those without rewriting anything here.
require("hypr.monitors")
require("hypr.input")
require("hypr.windows")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- Toggle config flags dynamically.
require("default.hypr.toggles")
