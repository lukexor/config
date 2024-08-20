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

  hardware.nvidia.prime = {
    sync.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  environment = {
    shellAliases = {
      # Install:
      # $ cd ~/vms && quickget windows 11
      # $ quickemu --vm /home/luke/config/vms/windows-11.conf
      # Install PreVeil and share it on the network as `PreVeil`
      # $ sudo mkdir -p /mnt/preveil
      #
      # Restart headless and mount (pw: quickemu):
      # $ quickemu --vm /home/luke/config/vms/windows-11.conf --display none
      # $ sudo mount /mnt/preveil
      "mntph" = "sudo mount -t cifs //192.168.0.67/PreVeil /mnt/preveil -o username=Quickemu,uid=1000";
      "mntpw" = "sudo mount -t cifs //10.133.220.213/PreVeil /mnt/preveil -o username=Quickemu,uid=1000";
    };
    systemPackages = with pkgs; [
      teams-for-linux
      wgnord
    ];
    variables = {
      GDK_SCALE = "2.0";
      GDK_DPI_SCALE = ".5";
    };
  };

  services = {
    displayManager.autoLogin.enable = false; # For security
    xserver.dpi = 150;
    gaming.enable = false;
  };
}
