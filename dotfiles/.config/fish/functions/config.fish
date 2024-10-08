function config -a config -d "edit a configuration file"
    set -l config $argv[1]
    switch $config
        case nvim
            nvim ~/.config/nvim/init.lua
        case kitty
            nvim ~/.config/kitty/kitty.conf
        case fish
            nvim ~/.config/fish/config.fish
        case fishl
            nvim ~/.local/config.fish
        case nix
            nixos-rebuild.sh
        case starship
            nvim ~/.config/starship.toml
        case ""
            echo "Error! must pass a config to edit"
            return 1
        case "*"
            echo "Error! `$config` is not a valid config"
            return 2
    end
end

complete -c config -fr -a "nvim kitty fish nu nu_env starship"
