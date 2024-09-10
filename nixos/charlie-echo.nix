{ config, pkgs, lib, user, ... }: let
in {
  boot = {
    initrd.luks.devices.crypted = {
      device = "/dev/disk/by-uuid/ad1cca17-62dc-4978-a5ce-665fd1615b32";
      preLVM = true;
    };
    consoleLogLevel = 3; # Only print errors during boot
    yt6801.enable = true;
  };

  networking = {
    hostName = "charlie-echo";
    enableIPv6 = true; # required by wgnord
  };

  hardware.nvidia.prime = {
    offload.enable = true;
    offload.enableOffloadCmd = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # rke2
  networking.firewall.enable = lib.mkForce false;
  virtualisation.docker.enable = lib.mkForce false; # docker can't run alongside rke2
  virtualisation.podman.enable = lib.mkForce false; # podman can't run alongside rke2
  services.rke2 = {
    enable = true;
    extraFlags = [
      "--write-kubeconfig-mode=0644"
    ];
  };
  nixpkgs.overlays = [
    (final: prev: {
      rke2 = prev.rke2.overrideAttrs (old: {
        ldflags = old.ldflags ++ [
          "-X github.com/rancher/rke2/pkg/images.DefaultEtcdImage=rancher/hardened-etcd:v3.5.13-k3s1-build20240531"
        ];
      });
    })
  ];
  systemd.services.rke2-server.path = ["/var/lib/rancher/rke2"];
  environment.sessionVariables.PATH = ["/var/lib/rancher/rke2/bin"];
  # TODO: Add custom rke2 group, chown paths and add user to group

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
      "mntp" = "sudo sh -c 'modprobe nbd max_part=1; qemu-nbd --connect /dev/nbd0 /home/${user}/vms/windows-11/disk.qcow2; mount /dev/nbd0p4 /mnt/windows'";
      "umntp" = "sudo sh -c 'qemu-nbd --disconnect /dev/nbd0; umount /dev/nbd0p4 /mnt/windows'";
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
