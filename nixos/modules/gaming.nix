{ config, pkgs, lib, ... }: let
  cfg = config.services.gaming;
in {
  options = {
    services.gaming = {
      enable = lib.mkOption {
        default = false;
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
        wine-staging
    ];
  };
}
