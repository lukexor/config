{ config, pkgs, lib, ... }: let
  cfg = config.display;
  x11Config = {
    home-manager.users.luke.home = {};

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
      xserver = {
        enable = true;
        videoDrivers = ["nvidia"];
        windowManager.dwm = {
          enable = true;
          package = (pkgs.dwm.override {
            patches = [
              ../patches/dwm.patch
            ];
          });
        };
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
    systemd.user.services.dwm-status.serviceConfig.Restart = "always";

    programs = {
      # screen locker
      slock = {
        enable = true;
        package = pkgs.slock.overrideAttrs (prev: {
          buildInputs = prev.buildInputs or [] ++ [pkgs.imlib2];
          patches = [
            ../patches/slock.patch
          ];
        });
      };
      thunar = {
        enable = true;
        plugins = with pkgs.xfce; [
          thunar-archive-plugin
          thunar-volman
        ];
      };
    };

    xdg.mime.defaultApplications."inode/directory" = "thunar.desktop";

    environment.systemPackages = with pkgs; [
      xfce.thunar
      clipmenu
      dmenu # dynamic menu
      dwm-status
      xautolock # auto lock
      xclip # required for neovim clipboard support
    ];
  };
  waylandConfig = {
    home-manager.users.luke.home.file = with config.lib.file; let
      config = "/home/${user}/config";
    in {
      ".config/yambar" = {
        source = mkOutOfStoreSymlink "${config}/.config/yambar";
        recursive = true;
      };
      ".xinitrc" = {
        text = ''
          #!/usr/bin/env sh
          exec dwl > /tmp/dwltags
        '';
        executable = true;
      };
    };

    services.displayManager.defaultSession = "none+dwl";

    systemd.user.services.yambar = {
      description = "yambar service";
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      serviceConfig = {
        ExecStart = "${pkgs.yambar}/bin/yambar";
        Restart = "always";
      };
    };

    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      xwayland.enable = true;
    };

    xdg = {
      # TODO inode mime type
      mime.defaultApplications."inode/directory" = "";
      portal = {
        enable = true;
        wlr.enable = true; # required for screensharing on Wayland
        config.common = {
          default = [
            "gtk"
          ];
        };
      };
    };

    environment.systemPackages = with pkgs; [
      (dwl.overrideAttrs (prev: {
        enableXWayland = true;
        patches = [
          ../patches/dwl.patch
        ];
      }))
      wl-clipboard # CLI clipboard for Wayland
      wlr-randr # xrandr for wlroots
      wmenu # dmenu for wlroots
      yambar # X11/Wayland status bar
    ];
  };
in {
  options = {
    display = {
      protocol = lib.mkOption {
        default = "wayland";
        type = with lib.types; enum ["x11" "wayland"];
        description = ''
          Set desktop display protocol.
        '';
      };
    };
  };

  config = {
    home-manager = lib.optionalAttrs (cfg.protocol == "x11") x11Config.home-manager
      // lib.optionalAttrs (cfg.protocol == "wayland") waylandConfig.home-manager;

    services = lib.recursiveUpdate {
      displayManager.ly = {
        enable = true;
        settings = {
          animation = "doom";
          clear_password = true;
          clock = "%Y-%m-%d %X";
          numlock = true;
        };
      };
    } (lib.optionalAttrs (cfg.protocol == "x11") x11Config.services
        // lib.optionalAttrs (cfg.protocol == "wayland") waylandConfig.services);

    programs = lib.optionalAttrs (cfg.protocol == "x11") x11Config.programs
      // lib.optionalAttrs (cfg.protocol == "wayland") waylandConfig.programs;

    environment = lib.optionalAttrs (cfg.protocol == "x11") x11Config.environment
      // lib.optionalAttrs (cfg.protocol == "wayland") waylandConfig.environment;

    systemd = lib.optionalAttrs (cfg.protocol == "x11") x11Config.systemd
      // lib.optionalAttrs (cfg.protocol == "wayland") waylandConfig.systemd;

    xdg = lib.optionalAttrs (cfg.protocol == "x11") x11Config.xdg
      // lib.optionalAttrs (cfg.protocol == "wayland") waylandConfig.xdg;
  };
}

