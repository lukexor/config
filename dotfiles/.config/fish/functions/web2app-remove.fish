function web2app-remove -d "remove desktop launcher for a web app"
    set -l app_name $argv[1]
    if test -z "$app_name"
        echo "Usage: web2app-remove <APP_NAME>"
        return 1
    end

    set -l icon_dir "$HOME/.local/share/applications/icons"
    set -l desktop_file "$HOME/.local/share/applications/$app_name.desktop"
    set -l icon_path "$icon_dir/$app_name.png"

    rm -f "$desktop_file"
    rm -f "$icon_path"

    echo "Removed $app_name"
end
