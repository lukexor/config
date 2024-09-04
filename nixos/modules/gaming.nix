{ config, pkgs, lib, ... }: let
  cfg = config.services.gaming;
in {
  options = {
    services.gaming = {
      enable = lib.mkOption {
        default = true;
        type = with lib.types; bool;
        description = ''
          Set up gaming dependencies (Steam, lutris, etc).
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      gamemode.enable = true;
      steam.enable = true;
    };

    environment.systemPackages = with pkgs; [
        discord
        dosbox
        # gaming compatibility
        lutris
        scummvm
        winetricks
        (wineWowPackages.full.override {
          wineRelease = "staging";
          mingwSupport = true;
        })
        wineWowPackages.waylandFull
    ];
  };
}
