{ config, pkgs, lib, user, ... }: let
  cfg = config.environment.theme;
  valid_bgs = builtins.attrNames (builtins.readDir cfg.background.path);
in {
  options = {
    environment.theme = {
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
  config = with cfg; {
    home-manager.users.${user}.gtk.theme = {
      name = "Breeze-Dark";
      package = pkgs.libsForQt5.breeze-gtk;
    };

    environment = {
      etc = let
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
      systemPackages = with pkgs; [
        swww
      ];
    };

    systemd.user.services = {
      swww = {
        description = "swww service";
        wantedBy = ["graphical-session.target"];
        after = ["graphical-session.target"];
        partOf = ["graphical-session.target"];
        startLimitIntervalSec = 0;
        serviceConfig = {
          ExecStart = "/bin/sh -c '${pkgs.swww}/bin/swww-daemon & ${pkgs.swww}/bin/swww img ${lib.path.append background.path background.desktop}'";
          Restart = "always";
          RestartSec = "1s";
        };
      };
    };
  };
}
