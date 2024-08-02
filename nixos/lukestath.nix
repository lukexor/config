{ config, pkgs, lib, ... }: let
  # Custom derivation for Motorcomm ethernet YT6801
  yt6801 = config.boot.kernelPackages.callPackage ./modules/yt6801 {};
in {
  boot.extraModulePackages = [ yt6801 ];

  networking = {
    hostName = "lukestath";
    interfaces = {
      enp44s0.useDHCP = true;
      wlo1.useDHCP = true;
      br0.useDHCP = true;
    };
    bridges.br0.interfaces = ["enp44s0"];
    networkmanager = {
      unmanaged = ["enp44s0" "br0"];
    };
  };

  # Install:
  # $ cd ~/vms && quickget windows 11
  # $ quickemu --vm /home/luke/config/vms/windows-11.conf
  # Install PreVeil and share it on the network as `PreVeil`
  # $ sudo mkdir -p /mnt/preveil
  #
  # Restart headless and mount (pw: quickemu):
  # $ quickemu --vm /home/luke/config/vms/windows-11.conf --display none
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
    };
  };
  services.xserver.videoDrivers = ["nvidia"];
}
