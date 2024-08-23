{ config, pkgs, lib, ... }: let
in {
  boot = {
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
    reverseSync.enable = true;
    allowExternalGpu = false;
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
      "umntp" = "sudo umount -l /mnt/previl";
    };
    systemPackages = with pkgs; [
      teams-for-linux
      wgnord
    ];
  };

  services = {
    autorandr.profiles = let
      primary = {
        enable = true;
        primary = true;
        position = "0x0";
        mode = "2560x1600";
        rate = "60.00";
        crtc = 0;
      };
    in {
      single = {
        fingerprint.eDP1 = "*";
        config.eDP-1 = primary;
      };
      home = {
        fingerprint = {
          eDP1 = "*";
          HDMI-1-0 = "*";
        };
        config = {
          eDP-1 = primary;
          HDMI-1-0 = {
            enable = true;
            position = "2560x0";
            mode = "2560x1440";
            rate = "60.00";
            crtc = 4;
          };
        };
      };
      work = {
        fingerprint = {
          eDP1 = "*";
          DP-1-0 = "*";
        };
        config = {
          eDP-1 = primary;
          DP-1-0 = {
            enable = true;
            position = "2560x0";
            mode = "3840x2160";
            rate = "60.00";
            crtc = 4;
          };
        };
      };
    };
    displayManager.autoLogin.enable = lib.mkForce false; # For security
    xserver.displayManager.sessionCommands = ''
      ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
      Xft.dpi: 144
      Xcursor.size: 32
      EOF
    '';
    gaming.enable = false;
    theme.background.terminal = "eve-online.png";
    theme.background.desktop = "rain-cyber-city.png";
  };
}
