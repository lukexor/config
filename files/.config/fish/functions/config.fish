function config -a "config" -d "edit a configuration file"
    set -l config $argv[1]
    switch $config
        case "nvim"
            nvim ~/.config/nvim/init.lua
        case "kitty"
            nvim ~/.config/kitty/kitty.conf
        case "fish"
            nvim ~/.config/fish/config.fish
        case "nu"
            nvim ~/.config/nu/config.nu
        case "nu_env"
            nvim ~/.config/nu/env.nu
        case "starship"
            nvim ~/.config/starship.toml
        case ""
            echo "must pass a config option"
            return 1
        case "*"
            echo "`$config` is not a valid configuration file"
            return 1
    end
end

complete -c config -fr -a "nvim kitty fish nu nu_env starship"
