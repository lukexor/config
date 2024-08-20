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
# sudo nix-channel --add https://channels.nixos.org/nixpkgs-unstable
# sudo nix-channel --update
#
# sudo nixos-rebuild switch --upgrade
{ config, pkgs, lib, ... }: let
  user = "luke";
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
    hostName = lib.mkDefault "luke";
    networkmanager.enable = true;
    enableIPv6 = lib.mkDefault false;
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
  };
  home-manager = {
    backupFileExtension = "bak";
    users.luke = { config, pkgs, ...}: {
      dconf.enable = true;

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
    clipmenu.enable = true;
    displayManager.defaultSession = "none+dwm";
    dwm-status = {
      enable = true;
      order = ["cpu_load" "audio" "battery" "time"];
      extraConfig = ''
        [audio]
        mute = "󰝟"
        template = " {VOL}%"

        [battery]
        charging = ""
        discharging = ""
        no_battery = "󱉞"
      '';
    };
    gaming.enable = lib.mkDefault true;
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
      extraConfig = ''
        Section "InputClass"
          Identifier "game mouse speed"
          MatchDriver "libinput"
          MatchProduct "SINOWEALTH Game Mouse"
          Option "AccelSpeed" "-0.75"
        EndSection
      '';
      windowManager.dwm = {
        enable = true;
        package = pkgs.dwm.override {
          patches = [
            ./patches/dwm.patch
          ];
        };
      };
      displayManager = {
        lightdm = {
          enable = true;
          background = "/etc/wallpapers/nier-automata.png";
          greeters.gtk.theme.name = "Adwaita-dark";
        };
        sessionCommands = ''
          feh --bg-scale /etc/wallpapers/nier-automata.png
        '';
      };
      videoDrivers = ["nvidia"];
      xautolock = {
        enable = true;
        time = 5;
        extraOptions = [
          "-detectsleep"
          "-lockaftersleep"
        ];
        nowlocker = "/run/wrappers/bin/slock";
        locker = "/run/wrappers/bin/slock";
        killer = "/run/current-system/systemd/bin/systemctl suspend";
      };
      xkb = {
        layout = "us";
        variant = "";
      };
    };
  };
  systemd = {
    # Fixes suspend/resume freezing
    services = let serviceConfig = {
      Environment = "SYSTEMD_SLEEP_FREEZE_USER_SESSIONS=false";
    }; in {
      systemd-suspend = { inherit serviceConfig; };
      systemd-hibernate = { inherit serviceConfig; };
      systemd-hybrid-sleep = { inherit serviceConfig; };
      systemd-suspend-then-hibernate = { inherit serviceConfig; };
    };
    # alsa "Master" is not always available immediately at boot
    user.services.dwm-status.serviceConfig.Restart = "always";
  };

  hardware = {
    bluetooth.enable = true;
    graphics = {
      enable = true; # enable opengl
      enable32Bit = true; # for wine
    };
    nvidia = {
      powerManagement = {
        enable = lib.mkDefault true; # Fixes black screen crashe when resuming from sleep
      };
    };
    nvidia-container-toolkit.enable = true; # Nvidia GPU passthrough
    pulseaudio.enable = false; # Must be disabled to use pipewire
  };
  security = {
    polkit.enable = true;
    rtkit.enable = true; # Used to prioritize pulse audio server
  };

  programs = {
    appimage.enable = true;
    bash = {
      # See https://nixos.wiki/wiki/Fish#Setting_fish_as_your_shell
      interactiveShellInit = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };
    chromium = {
      enable = true;
      enablePlasmaBrowserIntegration = true;
      extensions = [
        "eimadpbcbfnmbkopoojfekhnkhdbieeh" # dark reader
        "hdokiejnpimakedhajhdlcegeplioahd" # lastpass
        "ennpfpdlaclocpomkiablnmbppdnlhoh" # rust search extension
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
    slock.enable = true;
    ssh.startAgent = true;
    starship.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (import (fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz"))
    ];
  };
  environment = {
    # Expose extension binaries so neovim can use it instead of just vscode
    etc.lldb.source = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb";
    systemPackages = with pkgs; let
      apps = with pkgs; [
        # DRM support
        (chromium.override { enableWideVine = true; })
        libreoffice
        kitty
        maestral # dropbox client
        maestral-gui
        ncspot
        xfce.thunar
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
        # Currently failing to build
        # cpplint
        docker
        gcc
        gnumake
        just # make replacement
        nodejs_20
        python3
        quickemu
        (rust-bin.stable.latest.default.override {
          extensions = ["rust-analyzer" "rust-src"];
          targets = ["wasm32-unknown-unknown" "wasm32-wasi"];
        })
        yarn
      ];
      language-servers = with pkgs; [
        clang-tools
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
        alsa-utils # required for dwm-status
        bat # cat replacement
        bottom # top replacement
        bridge-utils
        cifs-utils
        clipmenu
        clolcat
        dmenu # dynamic menu
        dust # du replacement
        dwm-status
        eza # ls replacement
        feh
        fd # find replacement
        flameshot # screenshot util
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
        mprocs # run multiple processes in parallel
        networkmanager_dmenu
        pciutils
        procs # ps replacement
        ripgrep
        sd # sed replacement
        slock # screen locker
        starship
        tealdeer # tldr in rust
        tokei # code statistics
        unzip
        upower # required by dwm-status
        xautolock # auto lock
        xclip # required for neovim clipboard support
        xh # curl replacement
      ];
    in
      apps ++
      development ++
      language-servers ++
      utilities;
    variables = {
      CARGO_TARGET_DIR = "/home/${user}/.cargo-target";
      EDITOR = "nvim";
      FZF_CTRL_T_COMMAND = "rg --files --hidden";
      FZF_DEFAULT_COMMAND = "rg --files --hidden";
      FZF_DEFAULT_OPTS = "--height 50% --layout=reverse --border --inline-info";
      LESS = "-RFX";
      MANPAGER = "nvim +Man!";
      PAGER = "nvim +Man!";
      RUST_BACKTRACE = "full";
      TERMINAL = "kitty";
      VISUAL = "nvim";
    };
  };

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = false;
      autoPrune.enable = true;
    };
    libvirtd.enable = true;
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

  console = with pkgs; {
    packages = [terminus_font];
    font = "${terminus_font}/share/consolefonts/ter-i14b.psf.gz";
    useXkbConfig = true;
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
