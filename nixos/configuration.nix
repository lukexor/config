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
#
# Alt+Space           wmenu
# Alt+Shift+Return    terminal
# Alt+Shift+C         chormium
# Alt+J               next stack focus
# Alt+K               prev stack focus
# Alt+I               increment master count
# Alt+D               decrement master count
# Alt+H               shrink master size
# Alt+L               grow master size
# Alt+Super+0         toggle gaps
# Alt+Return          toggle zoom
# Alt+Tab             alternate tag view
# Alt+Shift+W         kill application
# Alt+T               tile layout
# Alt+F               floating layout
# Alt+M               monocle layout
# Alt+Shift+Space     toggle floating
# Alt+0               view all tags
# Alt+Shift+0         apply all tags
# Alt+.               prev monitor focus
# Alt+,               next monitor focus
# Alt+Shift+.         prev monitor tag
# Alt+Shift+,         next monitor tag
# Alt+N               show tag numbers
# Super+Shift+V       clipmenu
# Super+Shift+P       screenshot
# Alt+#               view tag # (optional combo)
# Alt+Ctrl+#          toggle view tag #
# Alt+Shift+#         apply tag # (optional combo)
# Alt+Ctrl+Shift+#    toggle apply tag #
# Alt+Shift+R         restart dwm
# Alt+Shift+Q         kill dwm
{ config, pkgs, lib, ... }: let
  user = "luke";
  home-manager = (fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  });
  host-config = "/etc/nixos/host-configuration.nix";
  modules = builtins.map (file: (import /home/${user}/config/nixos/modules/${file} { inherit config pkgs lib user; })) (
    builtins.filter (path: builtins.match ".+\\.nix$" path != null)
    (builtins.attrNames (builtins.readDir /home/${user}/config/nixos/modules))
  );
in {
  imports = [
    /etc/nixos/hardware-configuration.nix
    "${home-manager}/nixos"
  ]
  ++ modules
  ++ lib.optionals (builtins.pathExists host-config) [
    (import host-config { inherit config pkgs lib user; })
  ];
  boot = {
    kernelPatches = [
      {
        name = "rust support";
        patch = null;
        features = { rust = true; };
      }
    ];
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        enableCryptodisk = true;
        device = "nodev";
        useOSProber = true;
      };
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
    hostName = lib.mkDefault "ares";
    networkmanager.enable = true;
    wireless.enable = lib.mkForce false; # conflicts with network manager
    enableIPv6 = lib.mkDefault false;
  };

  users.users."${user}" = {
    isNormalUser = true;
    home = "/home/${user}";
    description = "Luke";
    extraGroups = [
      "docker"
      "gamemode" # For gamemoded
      "libvirtd"
      "networkmanager"
      "qemu-libvirtd"
      "video"
      "wheel"
    ];
  };
  home-manager = {
    backupFileExtension = "bak";
    users."${user}" = { config, pkgs, ...}: {
      dconf.enable = true;

      gtk = {
        enable = true;
        font = {
          name = "DejaVu Sans";
          package = pkgs.dejavu_fonts;
        };
        gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
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
          ".icons" = {
            source = mkOutOfStoreSymlink "${config}/.icons";
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
    autorandr.enable = true;
    spice-autorandr.enable = true;
    blueman.enable = true;
    gnome.gnome-keyring.enable = true;
    logind.killUserProcesses = true;
    libinput = {
      enable = true; # touchpad support
      touchpad = {
        tapping = false;
        disableWhileTyping = true;
      };
      mouse.accelSpeed = "-0.75";
    };
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
    printing.enable = true;
  };

  systemd = {
    # Fixes suspend/resume freezing
    services = let
      serviceConfig = {
        Environment = "SYSTEMD_SLEEP_FREEZE_USER_SESSIONS=false";
      };
    in {
      systemd-suspend = { inherit serviceConfig; };
      systemd-hibernate = { inherit serviceConfig; };
      systemd-hybrid-sleep = { inherit serviceConfig; };
      systemd-suspend-then-hibernate = { inherit serviceConfig; };
    };
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics = {
      enable = true; # enable opengl
      enable32Bit = true; # for wine
    };
    nvidia-container-toolkit.enable = true; # NVIDIA GPU passthrough
    pulseaudio.enable = false; # Must be disabled to use pipewire
    keyboard.qmk.enable = true;
  };
  security = {
    polkit.enable = true;
    rtkit.enable = true; # Used to prioritize pulse audio server
  };

  programs = {
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
      extensions = [
        "eimadpbcbfnmbkopoojfekhnkhdbieeh" # dark reader
        "hdokiejnpimakedhajhdlcegeplioahd" # lastpass
        "ennpfpdlaclocpomkiablnmbppdnlhoh" # rust search extension
      ];
      extraOpts = {
       ExtensionSettings = {
        "eimadpbcbfnmbkopoojfekhnkhdbieeh" = {
          toolbar_pin = "force_pinned";
        };
        "hdokiejnpimakedhajhdlcegeplioahd" = {
          toolbar_pin = "force_pinned";
        };
       };
       PasswordManagerEnabled = false;
       SpellcheckEnabled = true;
       SpellcheckLanguage = ["en-US"];
      };
    };
    dconf.enable = true;
    direnv = {
      enable = true;
      enableFishIntegration = true;
      nix-direnv.enable = true;
    };
    firefox = {
      enable = true;
      policies = {
        Bookmarks = [
          {
            Title = "nixpkgs";
            Url = "https://search.nixos.org/packages?channel=unstable";
            Favicon = "https://search.nixos.org/favicon.png";
            Placement = "toolbar";
          }
        ];
        DisplayBookmarksToolbar = "always";
        ExtensionSettings = let
          defaultSettings = {
            installation_mode = "normal_installed";
          };
        in {
          "matte-black-sky-blue" = {
            inherit defaultSettings;
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/matte-black-sky-blue/latest.xpi";
          };
          "adguard-adblocker" = {
            inherit defaultSettings;
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/adguard-adblocker/latest.xpi";
          };
          "darkreader" = {
            inherit defaultSettings;
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          };
          "rust-search-extension" = {
            inherit defaultSettings;
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/rust-search-extension/latest.xpi";
          };
          "lastpass-password" = {
            inherit defaultSettings;
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/lastpass-password-manager/latest.xpi";
          };
          "tranquility-reader" = {
            inherit defaultSettings;
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/tranquility-1/latest.xpi";
          };
        };
        OfferToSaveLoginsDefault = false;
      };
    };
    fish.enable = true;
    git.enable = true;
    gnupg.agent.enable = true;
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

  xdg.mime.defaultApplications = {
    "application/pdf" = "firefox.desktop";
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
    pathsToLink = [
      "/home/${user}/.cargo/bin"
    ];
    systemPackages = with pkgs; let
      apps = [
        # DRM support
        (chromium.override { enableWideVine = true; })
        google-chrome
        libreoffice
        kitty
        maestral # dropbox client
        maestral-gui
        ncspot # spotify
        tui-journal
        xarchiver # archive manager
      ];
      development = [
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
        docker-client
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
      language-servers = [
        clang-tools
        eslint_d
        lua-language-server
        markdownlint-cli
        nil # Nix
        nixpkgs-fmt
        nodePackages.bash-language-server
        nodePackages.jsonlint
        nodePackages.typescript-language-server
        playerctl # multi-media control
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
      utilities = [
        alsa-utils # for volume control
        bat # cat replacement
        bottom # top replacement
        cifs-utils # manage cifs filesystems
        clolcat # rainbow text
        dust # du replacement
        eza # ls replacement
        fd # find replacement
        flameshot # screenshot util
        fzf
        glxinfo # To debug opengl issues
        hexedit
        htop
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
        lsof # list open files
        lshw # list hardware configuration
        mprocs # run multiple processes in parallel
        networkmanagerapplet # GNOME applet
        parted # disk partition tool
        pciutils # utils to inspect pcidevices
        polkit_gnome # gui for polkit
        procs # ps replacement
        qmk
        ripgrep
        sd # sed replacement
        seahorse # keyring manager
        starship
        tealdeer # tldr in rust
        tokei # code statistics
        unzip
        usbutils # e.g. lsusub
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
  specialisation = {
    wayland.configuration = {
      services.displayManager.protocol = "wayland";
    };
  };

  virtualisation = {
    docker = {
      enable = true;
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
    earlySetup = true;
    packages = [terminus_font];
    font = "${terminus_font}/share/consolefonts/ter-i14b.psf.gz";
    useXkbConfig = true;
  };
  fonts = {
    enableDefaultPackages = true;
    packages = [
      (pkgs.nerdfonts.override {
        fonts = [
          "DejaVuSansMono"
          "RobotoMono"
        ];
      })
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
