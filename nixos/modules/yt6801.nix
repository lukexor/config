{ config, pkgs, lib, ... }: let
  cfg = config.boot.yt6801;
  yt6801 = config.boot.kernelPackages.callPackage ../derivations/yt6801 {};
in {
  options = {
    boot.yt6801= {
      enable = lib.mkOption {
        default = false;
        type = with lib.types; bool;
        description = ''
          Add kernel module for Motorcomm Ethernet Card YT6801.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    boot.extraModulePackages = [yt6801];
  };
}
