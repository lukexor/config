{ config, pkgs, lib, user, ... }: let
  cfg = config.environment.theme;
  dcfg = config.services.displayManager;
  valid_bgs = builtins.attrNames (builtins.readDir cfg.background.path);
in {
  options = {
    environment.theme = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Breeze-Dark";
        description = ''
          Name of the theme to use.
        '';
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.libsForQt5.breeze-gtk;
        defaultText = lib.literalExpression "pkgs.gnome-themes-extra";
        description = ''
          The package path that contains the theme given in the name option.
        '';
      };
      background = {
        path = lib.mkOption {
          default = /home/${user}/config/wallpapers;
          type = with lib.types; nullOr path;
          description = ''
            Path to background images.
          '';
        };
        terminal = lib.mkOption {
          default = "2b-dual-wield.png";
          type = with lib.types; nullOr (enum valid_bgs);
          description = ''
            Set terminal background.
          '';
        };
        desktop = lib.mkOption {
          default = "nier-automata.png";
          type = with lib.types; nullOr (enum valid_bgs);
          description = ''
            Set desktop background.
          '';
        };
      };
    };
  };
  config = with cfg; lib.mkMerge [
    {
      home-manager.users.${user}.gtk.theme = {
        inherit (cfg) name;
      };

      environment.etc = let
        bgCfg = {
          user = "nobody";
          group = "nobody";
          mode = "0644";
        };
      in {
        "wallpapers/terminal.png" = {
          inherit (bgCfg) user group mode;
          source = lib.path.append background.path background.terminal;
        };
        "wallpapers/desktop.png" = {
          inherit (bgCfg) user group mode;
          source = lib.path.append background.path background.desktop;
        };
      };
    }
    (lib.mkIf (dcfg.protocol == "wayland") {
      environment.systemPackages = with pkgs; [
        swww
      ];

      systemd.user.services = {
        swww = {
          description = "swww service";
          wantedBy = ["graphical-session.target"];
          after = ["graphical-session.target"];
          partOf = ["graphical-session.target"];
          startLimitIntervalSec = 0;
          serviceConfig = {
            Environment="WAYLAND_DISPLAY=wayland-0"; # FIXME: better way than hardcoding this?
            ExecStart = "${pkgs.swww}/bin/swww-daemon";
            # TODO: fix setting background on startup
            # ${pkgs.swww}/bin/swww img ${lib.path.append background.path background.desktop}"
            Restart = "always";
            RestartSec = "1s";
          };
        };
      };
    })
    (lib.mkIf (dcfg.protocol == "x11") {
      home-manager = {
        users."${user}" = { config, pkgs, ...}: {
          home.file = with cfg; {
            ".background-image".source = (lib.path.append background.path background.desktop);
          };
        };
      };
      services.xserver.desktopManager.wallpaper.mode = "fill";
      environment.systemPackages = with pkgs; [
        feh # image/wallpaper utility
      ];
    })
  ];
}
