{ config, pkgs, lib, ... }: let
  cfg = config.networking.qemu;
in {
  options = {
    networking = {
      qemu = {
        enable = lib.mkOption {
          default = false;
          type = with lib.types; bool;
          description = ''
            Set up network bridge for QEMU to allow VMs to network with the host.
          '';
        };

        interface = lib.mkOption {
          default = null;
          type = with lib.types; uniq nonEmptyStr;
          description = ''
            Interface to bridge.
          '';
          example = lib.literalExample "en02";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    warnings = lib.optionals (cfg.interface == null || cfg.interface == "") [''
      You have enabled the qemu networking option but not specified an interface.
    ''];

    networking = {
      useDHCP = false;
      interfaces = {
        br0.useDHCP = true;
        "${cfg.interface}".useDHCP = true;
        wlo1.useDHCP = true;
      };
      bridges.br0.interfaces = [cfg.interface];
      networkmanager.unmanaged = ["br0" cfg.interface];
    };
    virtualisation.libvirtd.allowedBridges = ["br0" "virbr0"];
  };
}
