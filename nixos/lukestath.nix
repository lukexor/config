{ config, pkgs, lib, ... }: let
in {
  boot.yt6801.enable = true;

  networking = {
    hostName = "lukestath";
    enableIPv6 = true; # required by wgnord
  };

  hardware.nvidia.prime = {
    offload.enable = true;
    offload.enableOffloadCmd = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  environment = {
    shellAliases = {
      # Install:
      #
      # $ cd ~/vms && quickget windows 11
      # $ quickemu --vm ~vms/windows-11.conf
      # $ sudo mkdir -p /mnt/windows
      # $ sudo mkdir -p /mnt/preveil
      # $ sudo ln -s /mnt/windows/Users/Quickemu/PreVeil-luke.petherbridge@statheros.tech /mnt/preveil
      #
      # $ sudo modprobe nbd max_part=1
      # $ sudo qemu-nbd --connect /dev/nbd0 ~/vms/windows-11/disk.qcow2
      # $ sudo fdisk /dev/nbd0 -l
      # $ sudo mount /dev/nbd0p4 /mnt/windows
      #
      # Teardown to sync files/run QEMU
      #
      # $ sudo umount /mnt/windows
      # $ sudo qemu-nbd --disconnect /dev/nbd0
      #
      # "mntp" = "sudo mount -t cifs //192.168.0.67/PreVeil /mnt/preveil -o username=Quickemu,uid=1000";
      "mntp" = "sudo sh -c 'modprobe nbd max_part=1 && qemu-nbd --connect /dev/nbd0 ~/vms/windows-11/disk.qcow2 && mount /dev/nbd0p4 /mnt/windows'";
    };
    systemPackages = with pkgs; [
      teams-for-linux
      upower # for battery status
      wgnord
    ];
    theme.background = {
      terminal = "eve-online.png";
      desktop = "rain-cyber-city.png";
    };
  };

  services = {
    autorandr.profiles = let
      primary = {
        enable = true;
        primary = true;
        position = "0x0";
        mode = "2560x1600";
        dpi = 120; # split the difference between 96 and 144
        crtc = 0;
      };
    in {
      single = {
        fingerprint.eDP1 = "*";
        config.eDP-1 = primary;
      };
      home = {
        fingerprint = {
          eDP-1 = "*";
          HDMI-1-0 = "*";
        };
        config = {
          eDP-1 = primary;
          HDMI-1-0 = {
            enable = true;
            position = "2560x0";
            mode = "2560x1440";
            crtc = 4;
          };
        };
      };
      work = {
        fingerprint = {
          eDP-1 = "*";
          DP-1-0 = "*";
        };
        config = {
          eDP-1 = primary;
          DP-1-0 = {
            enable = true;
            position = "2560x0";
            mode = "3840x2160";
            crtc = 4;
          };
        };
      };
    };
    gaming.enable = false;
    xserver.displayManager.sessionCommands = ''
      ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
      Xft.dpi: 120
      Xcursor.size: 32
      EOF
    '';
  };
}
