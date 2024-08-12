{ config, pkgs, lib, ... }: let
in {
  networking = {
    hostName = "lukestath";
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

  environment.systemPackages = with pkgs; [
    teams-for-linux
  ];
}
