{ config, pkgs, lib, ... }: {
  networking = {
    hostName = "lukestath";
    interfaces = {
      # eno2.useDHCP = lib.mkDefault true;
      wlo1.useDHCP = lib.mkDefault true;
      # br0.useDHCP = lib.mkDefault true;
    };
    # bridges.br0.interfaces = ["eno2"];
  };

  # Install:
  # $ cd ~/vms && quickget windows 11
  #
  # Start headless:
  # $ sudo quickemu --vm /home/luke/config/vms/windows-11.conf --display none
  #
  # Mount:
  # $ sudo mount /mnt/preveil
  fileSystems."/mnt/preveil" = {
    device = "//192.168.0.67/PreVeil";
    fsType = "cifs";
    options = ["noauto" "user=Quickemu" "uid=1000"];
  };

  # hardware = {
  #   graphics.enable = true;
  #   nvidia = {
  #     powerManagement = {
  #       enable = true; # Fixes black screen crashe when resuming from sleep
  #     };
  #     package = config.boot.kernelPackages.nvidiaPackages.production;
  #   };
  # };
  # services.xserver.videoDrivers = ["nvidia"];
}
