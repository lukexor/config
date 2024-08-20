{ config, pkgs, lib, ... }: let
in {
  boot = {
    initrd.kernelModules = ["intel_lpss_pci"];
    yt6801Module.enable = true;
  };
  networking = {
    hostName = "lukestath";
    enableIPv6 = true; # required by wgnord
    qemu = {
      enable = true;
      interface = "enp44s0";
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

  services.xserver.dpi = 150;
  environment.variables = {
    GDK_SCALE = "2.0";
    GDK_DPI_SCALE = ".5";
  };
  hardware.nvidia.prime = {
    sync.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  environment.systemPackages = with pkgs; [
    teams-for-linux
    wgnord
  ];

  services = {
    displayManager.autoLogin.enable = false; # For security
    gaming.enable = false;
  };
}
