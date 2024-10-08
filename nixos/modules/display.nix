{ config, pkgs, lib, user, ... }: let
  cfg = config.services.displayManager;
in {
  options = {
    services.displayManager = {
      protocol = lib.mkOption {
        default = "x11";
        type = with lib.types; enum ["x11" "wayland"];
        description = ''
          Set desktop display protocol.
        '';
      };
    };
  };

  config = lib.mkMerge [
    {
      # display manager considerations:
      # - start x11/wayland session correctly
      # - autologin
      # - unlock gnome-keyring
      services.displayManager.ly = {
        enable = true;
        settings = {
          animation = "doom";
          clear_password = true;
          clock = "%Y-%m-%d %X";
          numlock = true;
          waylandsessions = "${pkgs.dwl}/share/wayland-sessions";
        };
      };

      environment.systemPackages = with pkgs; [
        bemenu # dynamic menu
        brightnessctl # monitor brightness
      ];
    }
    (lib.mkIf (cfg.protocol == "wayland") {
      nixpkgs.overlays = [
        (final: prev: {
          dwl = prev.dwl.overrideAttrs (old: {
            enableXWayland = true;
            patches = (old.patches or []) ++ [
              ../patches/dwl.patch
            ];
            passthru.providedSessions = ["dwl"];
            fixupPhase = ''
              substituteInPlace $out/share/wayland-sessions/dwl.desktop \
                --replace "Exec=dwl" "Exec='dwl > /tmp/dwltags'"
            '';
          });
        })
      ];

      home-manager = {
        users."${user}" = { config, pkgs, ...}: {
          home.file = with config.lib.file; let
            config = "/home/${user}/config";
          in {
            ".config/yambar" = {
              source = mkOutOfStoreSymlink "${config}/.config/yambar";
              recursive = true;
            };
          };
        };
      };

      services.displayManager = {
        sessionPackages = [pkgs.dwl];
        ly.settings.waylandsessions = "${pkgs.dwl}/share/wayland-sessions";
      };
      services.xserver.videoDrivers = ["nvidia"];

      systemd.user.services = {
        yambar = {
          description = "yambar service";
          wantedBy = ["graphical-session.target"];
          after = ["graphical-session.target"];
          partOf = ["graphical-session.target"];
          startLimitIntervalSec = 0;
          serviceConfig = {
            ExecStart = "${pkgs.yambar}/bin/yambar -c /home/${user}/.config/yambar/config.yml -b wayland -d info";
            Restart = "always";
            RestartSec = "1s";
          };
        };
        swayidle = let
          bg = with config.environment.theme; lib.path.append background.path background.desktop;
          lockCmd = "${pkgs.swaylock}/bin/swaylock -fi ${bg} -s fill";
          suspendCmd = "${pkgs.systemd}/bin/systemctl suspend";
        in {
          description = "idle manager for wayland";
          wantedBy = ["graphical-session.target"];
          partOf = ["graphical-session.target"];
          startLimitIntervalSec = 0;
          serviceConfig = {
            ExecStart = "${pkgs.swayidle}/bin/swayidle -w timeout 300 '${lockCmd}' timeout 600 '${suspendCmd}' before-sleep '${lockCmd}' lock '${lockCmd}'";
            Restart = "always";
            RestartSec = "1s";
          };
        };
      };

      xdg = {
        # TODO inode mime type
        mime.defaultApplications."inode/directory" = "";
        portal = {
          enable = true;
          wlr.enable = true; # required for screensharing on Wayland
          config.common.default = ["gtk"];
          extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        };
      };

      programs.xwayland.enable = true;

      security.pam.services.swaylock = {}; # required for swaylock to authenticate
      environment = {
        sessionVariables.NIXOS_OZONE_WL = "1"; # wayland support in chromium and electron
        systemPackages = with pkgs; [
          cliphist # clipboard manager for Wayland
          dwl # dynamic window manager for Wayland
          mako # notification daemon
          swayidle # idle management
          swaylock # screen locker for Wayland
          wl-clipboard # CLI clipboard for Wayland
          wlogout # logout menu for Wayland
          wlr-randr # xrandr for wlroots
          yambar # X11/Wayland status bar
        ];
      };
    })
    (lib.mkIf (cfg.protocol == "x11") {
      nixpkgs.overlays = [
        (final: prev: {
          dwm = prev.dwm.overrideAttrs (old: {
            patches = (old.patches or []) ++ [
              ../patches/dwm.patch
            ];
          });
          slock = prev.slock.overrideAttrs (old: {
            buildInputs = (old.buildInputs or []) ++ [prev.imlib2];
            patches = [
              ../patches/slock.patch
            ];
          });
        })
      ];

      hardware = {
        graphics = {
          enable = true; # enable opengl
          enable32Bit = true; # for wine
        };
        nvidia = {
          open = true;
          powerManagement.enable = true;
        };
      };

      services = {
        displayManager.defaultSession = "none+dwm";
        dwm-status = {
          enable = true;
          order = ["cpu_load" "audio" "battery" "time"];
          extraConfig = ''
            [audio]
            mute = "󰝟"
            template = " {VOL}%"

            [battery]
            charging = "󰄿"
            discharging = "󰄼"
            no_battery = "󱉝"
          '';
        };
        clipmenu.enable = true;
        gvfs.enable = true;
        xserver = {
          enable = true;
          videoDrivers = ["nvidia"];
          windowManager.dwm.enable = true;
          xautolock = {
            enable = true;
            time = 5;
            extraOptions = [
              "-detectsleep"
              "-lockaftersleep"
            ];
            nowlocker = "/run/wrappers/bin/slock";
            locker = "/run/wrappers/bin/slock";
            killer = "/run/current-system/systemd/bin/systemctl suspend";
          };
          xkb = {
            layout = "us";
            variant = "";
            options = "caps:escape";
          };
        };
      };

      # alsa "Master" is not always available immediately at boot
      systemd.user.services.dwm-status.serviceConfig.Restart = "on-failure";

      programs = {
        # screen locker
        slock.enable = true;
        thunar = {
          enable = true;
          plugins = with pkgs.xfce; [
            thunar-archive-plugin
            thunar-volman
          ];
        };
      };

      xdg.mime.defaultApplications."inode/directory" = "thunar.desktop";

      environment = {
        systemPackages = with pkgs; [
          clipmenu
          dwm-status
          feh # image viewer/wallpaper manager
          gvfs # required for thunar
          xautolock # auto lock
          xclip # required for neovim clipboard support
          xfce.thunar
        ];
        variables = {
          CM_LAUNCHER = "bemenu";
        };
      };
    })
  ];
}

