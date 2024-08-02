{ config, pkgs, lib, ... }: {
  networking = {
    hostName = "lukex";
    interfaces = {
      eno2.useDHCP = lib.mkDefault true;
      wlo1.useDHCP = lib.mkDefault true;
    };
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
      };
    };
  };
}
