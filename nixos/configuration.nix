# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# Reference:
#
# Adding custom resolution:
# gtf 2560 1440 60                                   # Generate xrandr output for resolution 2560x1440 at 60hz
# xrandr --newmode <gtf output>                      # Create mode
# xrandr --addmode <monitor> "2560x1440_60.00"       # Add mode
# xrandr --output <monitor> --mode 2560x1440_60.00   # Set mode
#
# Channels:
# sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
# sudo nix-channel --update
#
# sudo nixos-rebuild switch --upgrade
{ config, pkgs, lib, ... }: let
  user = "luke";
  defaultHostname = "lukex";
  home-manager = (fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  });
  host-config = "/etc/nixos/host-configuration.nix";
  modules = builtins.map (file: import /home/${user}/config/nixos/modules/${file}) (
    builtins.filter (path: builtins.match ".+\\.nix$" path != null)
    (builtins.attrNames (builtins.readDir /home/${user}/config/nixos/modules))
  );
in {
  imports = [
    /etc/nixos/hardware-configuration.nix
    "${home-manager}/nixos"
  ]
  ++ modules
  ++ lib.optionals (builtins.pathExists host-config) [host-config];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = ["ntfs"];
    yt6801Module.enable = (config.networking.hostName == "lukestath");
  };

  nix = {
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  networking = {
    hostName = lib.mkDefault defaultHostname;
    networkmanager = {
      enable = true;
      appendNameservers = ["4.2.2.2"];
    };
    enableIPv6 = false;
    qemuBridge = with config.networking; {
      enable = true;
      interface =
        if hostName == defaultHostname then
          "en02"
        else if hostName == "lukestath" then
          "enp44s0"
        else
          throw "no qemuBridge interface defined for host ${hostName}";
    };
  };

  users.users.luke = {
    isNormalUser = true;
    home = "/home/${user}";
    description = "Luke";
    extraGroups = [
      "kvm"
      "libvirtd"
      "qemu"
      "vboxsf"
      "wheel"
    ];
    shell = pkgs.fish;
  };
  home-manager = {
    backupFileExtension = "bak";
    users.luke = { config, pkgs, ...}: {
      gtk = with pkgs; {
        enable = true;
        font = {
          name = "DejaVu Sans";
          package = dejavu_fonts;
        };
        gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
        theme = {
          name = "Breeze-Dark";
          package = libsForQt5.breeze-gtk;
        };
      };
      home = {
        username = user;
        homeDirectory = "/home/${user}";
        stateVersion = "24.05";
        file = with config.lib.file; let
          config = "/home/${user}/config";
        in {
          ".config/direnv" = {
            source = mkOutOfStoreSymlink "${config}/.config/direnv/";
            recursive = true;
          };
          ".config/fish" = {
            source = mkOutOfStoreSymlink "${config}/.config/fish";
            recursive = true;
          };
          ".config/kitty" = {
            source = mkOutOfStoreSymlink "${config}/.config/kitty";
            recursive = true;
          };
          ".config/nvim" = {
            source = mkOutOfStoreSymlink "${config}/.config/nvim";
            recursive = true;
          };
          ".config/starship.toml".source = mkOutOfStoreSymlink "${config}/.config/starship.toml";
          ".local/kitty/keybinds.conf".source = mkOutOfStoreSymlink "${config}/.config/kitty/linux-keybinds.conf";
          ".gitconfig".source = mkOutOfStoreSymlink "${config}/.gitconfig";
          ".gitignore".source = mkOutOfStoreSymlink "${config}/.gitignore";
          ".luarc.json".source = mkOutOfStoreSymlink "${config}/.luarc.json";
          ".markdownlint.json".source = mkOutOfStoreSymlink "${config}/.markdownlint.json";
          ".protolint.yaml".source = mkOutOfStoreSymlink "${config}/.protolint.yaml";
          ".rgignore".source = mkOutOfStoreSymlink "${config}/.rgignore";
          ".stylua.toml".source = mkOutOfStoreSymlink "${config}/.stylua.toml";
          "bin" = {
            source = mkOutOfStoreSymlink "${config}/bin";
            recursive = true;
          };
        };
      };

      programs = {
        home-manager.enable = true;
        gpg.enable = true;
        neovim.plugins = with pkgs.vimPlugins; [
          (nvim-treesitter.withPlugins (plugins: with plugins; [
            bash
            c
            cpp
            css
            dockerfile
            fish
            glsl
            graphql
            html
            javascript
            json
            lua
            make
            markdown
            markdown_inline
            proto
            python
            regex
            rust
            toml
            tsx
            typescript
            vim
            vimdoc
            yaml
          ]))
        ];
      };
      services.gpg-agent.enable = true;
    };
  };

  time.timeZone = "America/Los_Angeles";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  services = {
    displayManager = {
      autoLogin = {
        enable = (config.networking.hostName == defaultHostname);
        inherit user;
      };
      sddm = {
        enable = true;
        autoNumlock = true;
      };
      defaultSession = "plasma";
    };
    desktopManager.plasma6.enable = true;
    gaming.enable = (config.networking.hostName == defaultHostname);
    libinput.enable = true; # touchpad support
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = false;
    };
    printing.enable = true;
    xserver = {
      enable = true;
      windowManager.dwm.enable = true;
      videoDrivers = ["nvidia"];
      xkb = {
        layout = "us";
        variant = "";
      };
    };
  };
  # Don't wait for network on rebuild/boot
  systemd.services.NetworkManager-wait-online.enable = false;

  hardware = {
    bluetooth.enable = true;
    graphics.enable = true; # enable opengl
    nvidia = {
      powerManagement = {
        enable = true; # Fixes black screen crashe when resuming from sleep
      };
    };
    nvidia-container-toolkit.enable = true; # Nvidia GPU passthrough
    pulseaudio.enable = false; # Must be disabled to use pipewire
  };
  security.rtkit.enable = true; # Used to prioritize pulse audio server

  programs = {
    appimage.enable = true;
    chromium = {
      enable = true;
      enablePlasmaBrowserIntegration = true;
      extensions = [
        "eimadpbcbfnmbkopoojfekhnkhdbieeh" # dark reader
        "hdokiejnpimakedhajhdlcegeplioahd" # lastpass
        "ennpfpdlaclocpomkiablnmbppdnlhoh" # rust search extension
        "cimiefiiaegbelhefglklhhakcgmhkai" # plasma integration
      ];
      extraOpts = {
       PasswordManagerEnabled = false;
       ExtensionSettings = {
        "eimadpbcbfnmbkopoojfekhnkhdbieeh" = {
          toolbar_pin = "force_pinned";
        };
        "hdokiejnpimakedhajhdlcegeplioahd" = {
          toolbar_pin = "force_pinned";
        };
       };
      };
    };
    dconf.enable = true;
    gnupg.agent.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    firefox.enable = true;
    fish.enable = true;
    git.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
      withNodeJs = true;
      withPython3 = true;
    };
    ssh.startAgent = true;
    starship.enable = true;
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [];
  };
  environment.systemPackages = with pkgs; let
    apps = with pkgs; [
      chromium
      libreoffice
      kitty
      maestral # dropbox client
      maestral-gui
      ncspot
    ];
    development = with pkgs; [
      cargo-asm
      cargo-audit
      cargo-deny
      cargo-expand
      cargo-flamegraph
      cargo-leptos
      cargo-outdated
      cargo-udeps
      cargo-watch
      cmake
      docker
      gcc
      gnumake
      just # make replacement
      nodejs_20
      python3
      quickemu
      rust-analyzer
      rustup
      yarn
    ];
    language-servers = with pkgs; [
      eslint_d
      lua-language-server
      markdownlint-cli
      nodePackages.bash-language-server
      nodePackages.jsonlint
      nodePackages.typescript-language-server
      prettierd
      protolint
      pyright
      shellcheck
      stylelint
      stylua
      tailwindcss-language-server
      taplo # TOML language server
      vscode-extensions.vadimcn.vscode-lldb
      yamllint
      yaml-language-server
    ];
    utilities = with pkgs; [
      bat # cat replacement
      bottom # top replacement
      bridge-utils
      cifs-utils
      clolcat
      dust # du replacement
      eza # ls replacement
      fd # find replacement
      fzf
      glxinfo # To debug opengl issues
      hexedit
      (rustPlatform.buildRustPackage rec {
        pname = "irust";
        version = "1.71.23";
        src = fetchFromGitHub {
          owner = "sigmaSd";
          repo = "IRust";
          rev = version;
          hash = "sha256-Rp1v690teNloA35eeQxZ2KOi00csGcKemcWIheeFCgY=";
        };
        cargoHash = "sha256-Dz1bYaRD5sl1Y6kBDHm0aP6FqOQrQWBHkHo/G4Cr+/Q=";
        doCheck = false; # Tests fail trying to import dependencies
        meta = with lib; {
          description = "Cross Platform Rust Repl";
          homepage = "https://github.com/sigmaSd/IRust";
          license = licenses.mit;
          maintainers = ["sigmaSd"];
          mainProgram = "irust";
        };
      })
      jumpapp
      libsForQt5.kconfig # for kwriteconfig5
      # Not fully moved to plasma6 yet: https://github.com/NixOS/nixpkgs/issues/324406
      (stdenv.mkDerivation rec {
        name = "krohnkite";

        version = "0.9.7";
        src = fetchFromGitHub {
          owner = "anametologin";
          repo = "krohnkite";
          rev = version;
          hash = "sha256-8A3zW5tK8jK9fSxYx28b8uXGsvxEoUYybU0GaMD2LNw=";
        };

        dontWrapQtApps = true;
        buildInputs = with kdePackages; [
          kpackage
          kwin
          kwindowsystem
          p7zip
          typescript
        ];
        patches = [
          ./patches/krohnkite-build.patch
        ];

        buildPhase = ''
          make package
        '';

        installPhase = ''
          kpackagetool6 -t KWin/Script -i krohnkite-${version}.kwinscript -p $out/share/kwin/scripts
        '';

        meta = with lib; {
          description = "Dynamic tiling extension for KWin";
          license = licenses.mit;
          maintainers = [];
          inherit (src.meta) homepage;
          inherit (kwindowsystem.meta) platforms;
        };
      })
      konsave # to save/restore kde profile
      mprocs # run multiple processes in parallel
      procs # ps replacement
      ripgrep
      sd # sed replacement
      starship
      tealdeer # tldr in rust
      tokei # code statistics
      unzip
      xclip # required for neovim clipboard support
      xh # curl replacement
    ];
  in
    apps ++
    development ++
    language-servers ++
    utilities
  ;
  # Expose extension binaries so neovim can use it instead of just vscode
  environment.etc.lldb.source = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb";

  virtualisation = {
    docker.enable = true;
    libvirtd = {
      enable = true;
      allowedBridges = ["br0" "virtbr0"];
    };
  };
  security.wrappers = {
    # Allow quickemu to mount network bridge
    quickemu = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_admin+ep";
      source = "${pkgs.quickemu}/bin/quickemu";
    };
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      (nerdfonts.override { fonts = [
        "DejaVuSansMono"
        "RobotoMono"
      ]; })
    ];
    fontDir.enable = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = ["DejaVuSansM Nerd Font"];
        monospace = ["RobotoMono Nerd Font Mono" "DejaVuSansM Nerd Font Mono"];
      };
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
