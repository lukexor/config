{ config, pkgs, lib, user, ... }: let
  cfg = config.display;
  defaultConfig = {
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
  };
  waylandConfig = lib.mkIf (cfg.protocol == "wayland") {
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

    home-manager = with config.environment.theme; {
      users."${user}" = { config, pkgs, ...}: {
        home.file = with config.lib.file; let
          config = "/home/${user}/config";
        in {
          ".config/yambar" = {
            source = mkOutOfStoreSymlink "${config}/.config/yambar";
            recursive = true;
          };
        };
        services.swayidle = let
          bg = lib.path.append background.path background.desktop;
          swaylockCmd = "${pkgs.swaylock}/bin/swaylock -fi ${bg} -s fill";
        in {
          enable = true;
          timeouts = [
            { timeout = 300; command = swaylockCmd; }
            { timeout = 600; command = "${pkgs.systemd}/bin/systemctl suspend"; }
          ];
          events = [
            { event = "before-sleep"; command = swaylockCmd; }
            { event = "lock"; command = "lock"; }
          ];
        };
      };
    };

    services.displayManager.sessionPackages = [pkgs.dwl];
    services.xserver.videoDrivers = ["nvidia"];

    systemd.user.services = {
      yambar = {
        enable = true;
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
    };

    xdg = {
      # TODO inode mime type
      mime.defaultApplications."inode/directory" = "";
      portal = {
        enable = true;
        wlr.enable = true; # required for screensharing on Wayland
        config.common.default = [
          "gtk"
        ];
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      };
    };

    security.pam.services.swaylock = {}; # required for swaylock to authenticate
    environment.systemPackages = with pkgs; [
      bemenu # dmenu for wlroots
      brightnessctl # monitor brightness
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
  x11Config = lib.mkIf (cfg.protocol == "x11") {
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

    environment.systemPackages = with pkgs; [
      xfce.thunar
      clipmenu
      dmenu # dynamic menu
      dwm-status
      xautolock # auto lock
      xclip # required for neovim clipboard support
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

  config = lib.mkMerge [
    defaultConfig
    waylandConfig
    x11Config
  ];
}

