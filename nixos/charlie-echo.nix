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

  hardware.nvidia.powerManagement.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      # FIPS compatible key exchange algorithms
      # See: https://www.stigviewer.com/stig/red_hat_enterprise_linux_8/2022-12-06/finding/V-255924
      KexAlgorithms = [
        "ecdh-sha2-nistp256"
        "ecdh-sha2-nistp384"
        "ecdh-sha2-nistp521"
        "diffie-hellman-group-exchange-sha256"
        "diffie-hellman-group14-sha256"
        "diffie-hellman-group16-sha512"
        "diffie-hellman-group18-sha512"
      ];
    };
  };

  # rke2
  networking.firewall.enable = lib.mkForce false;
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
      # 1. cd ~/vms && quickget windows 11
      # 2. Add line `windows-11.conf`
      #     ```
      #     port_forwards=("8445:445") # Bind SMB port to 8445 on host
      #     ```
      #
      # 3. quickemu --vm ~/vms/windows-11.conf
      # 4. sudo mkdir -p /mnt/preveil /mnt/windows
      # 5. Mount/Unmount
      "mntp" = "sudo mount -t cifs //127.0.0.1/PreVeil /mnt/preveil/ -o user=QuickEmu,password=quickemu,port=8445,uid=1000,gid=100";
      # Offline mounting
      "mntpo" = "sudo sh -c 'modprobe nbd max_part=1; qemu-nbd --connect /dev/nbd0 /home/${user}/vms/windows-11/disk.qcow2; mount /dev/nbd0p4 /mnt/windows'";
      "umntp" = "sudo umount /mnt/preveil";
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
    displayManager.autoLogin.enable = lib.mkForce false; # For security
    xserver.displayManager.sessionCommands = ''
      ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
      Xft.dpi: 120
      Xcursor.size: 32
      EOF
    '';
  };
}
