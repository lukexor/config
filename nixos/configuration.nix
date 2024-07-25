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
# sudo nix-channel --add http://nixos.org/channels/nixpkgs-unstable nixpkgs-unstable
#
# sudo nix-channel --update
# sudo nixos-rebuild switch --upgrade
{ config, pkgs, lib, ... }: let
  user = "luke";
  hostname = "lukex";
  home-manager = (fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/master.tar.gz";
    sha256 = "16lvcaxhq38kdw3g71p6fyr8g8ml2n6kny5mg8x5189axbk0szr4";
  });
  rust-overlay = (fetchTarball {
    url = "https://github.com/oxalica/rust-overlay/archive/master.tar.gz";
  });
  host-config = "/home/${user}/config/nixos/${hostname}.nix";
in {
  imports = [
    /etc/nixos/hardware-configuration.nix
    "${home-manager}/nixos"
  ] ++ (
    if builtins.pathExists host-config then
      [host-config]
    else
      []
  );

  nix = {
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
  nixpkgs.overlays = [
    (import rust-overlay)
  ];

  boot.supportedFilesystems = ["ntfs"];
  networking = {
    hostName = hostname;
    networkmanager.enable = true;
  };

  users.users.luke = {
    isNormalUser = true;
    home = "/home/${user}";
    description = "Luke";
    extraGroups = ["wheel" "vboxsf"];
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
        stateVersion = "24.11";
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
        enable = true;
        inherit user;
      };
      sddm = {
        enable = true;
        autoNumlock = true;
      };
      defaultSession = "plasmax11";
    };
    desktopManager.plasma6.enable = true;
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
      xkb = {
        layout = "us";
        variant = "";
      };
    };
  };

  hardware = {
    bluetooth.enable = true;
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
    direnv.enable = true;
    firefox.enable = true;
    fish.enable = true;
    git.enable = true;
    neovim = {
      defaultEditor = true;
      withNodeJs = true;
      withPython3 = true;
    };
    ssh.startAgent = true;
    starship.enable = true;
    steam.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; let
    rustPlatform = makeRustPlatform {
      cargo = rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
      rustc = rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
    };
    apps = with pkgs; [
      chromium
      discord
      dropbox
      dropbox-cli
      libreoffice
      kitty
      ncspot
      quickemu
      steam
      steam-run
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
      git
      gnumake
      just # make replacement
      neovim
      nix-direnv
      nodejs_20
      python3
      (rust-bin.selectLatestNightlyWith (toolchain: toolchain.default.override {
        extensions = ["rust-analyzer" "rust-src"];
        targets = ["wasm32-unknown-unknown"];
      }))
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
      appimage-run
      bat # cat replacement
      bottom # top replacement
      bridge-utils
      cifs-utils
      clolcat
      dust # du replacement
      eza # ls replacement
      fd # find replacement
      fish
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
      mprocs # run multiple processes in parallel
      procs # ps replacement
      ripgrep
      samba
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
  system.stateVersion = "24.11"; # Did you read the comment?
}
