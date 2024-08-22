{ config, pkgs, lib, ... }: let
  cfg = config.services.theme;
  valid_bgs = builtins.attrNames (builtins.readDir cfg.background.path);
in {
  options = {
    services.theme = {
      background = {
        path = lib.mkOption {
          default = /home/luke/config/wallpapers;
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

  config = with lib; with cfg; {
    services.xserver.displayManager.sessionCommands = ''
      feh --bg-scale ${path.append background.path background.desktop}
    '';
    home-manager.users.luke.gtk.theme = {
      name = "Breeze-Dark";
      package = pkgs.libsForQt5.breeze-gtk;
    };
    environment.etc = let
      bg_cfg = {
        user = "nobody";
        group = "nobody";
        mode = "0644";
      };
    in {
      "wallpapers/terminal.png" = {
        inherit (bg_cfg) user group mode;
        source = path.append background.path background.terminal;
      };
      "wallpapers/desktop.png" = {
        inherit (bg_cfg) user group mode;
        source = path.append background.path background.desktop;
      };
    };
  };
}
