{ config, pkgs, lib, ... }: {
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    interfaces = {
      eno2.useDHCP = lib.mkDefault true;
      wlo1.useDHCP = lib.mkDefault true;
      br0.useDHCP = lib.mkDefault true;
    };
    bridges.br0.interfaces = ["eno2"];
  };

  # Start headless VM
  # sudo quickemu --vm /home/luke/config/vms/windows-11.conf --display none
  # Mount with
  # $ sudo mount /mnt/preveil
  fileSystems."/mnt/preveil" = {
    device = "//192.168.0.67/PreVeil";
    fsType = "cifs";
    options = ["noauto" "user=Quickemu" "uid=1000"];
  };

  hardware = {
    graphics.enable = true;
    nvidia = {
      powerManagement = {
        enable = true; # Fixes black screen crashe when resuming from sleep
      };
      package = config.boot.kernelPackages.nvidiaPackages.production;
    };
  };
  services.xserver.videoDrivers = ["nvidia"];

  services = {
    displayManager = {
      autoLogin = {
        enable = true;
        inherit user;
      };
    };
  };
}
