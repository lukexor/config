{ config, pkgs, lib, ... }: let
  cfg = config.networking.qemuBridge;
in {
  options = {
    networking = {
      qemuBridge = {
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
      You have enabled the qemuBridge networking option but not specified an interface.
    ''];

    networking = {
      interfaces = {
        br0.useDHCP = true;
      };
      bridges.br0.interfaces = [cfg.interface];
      networkmanager = {
        unmanaged = ["br0"];
      };
    };
  };
}
