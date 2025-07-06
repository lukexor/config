function web2app -d "create desktop launcher for a web app"
    set -l app_name $argv[1]
    set -l app_url $argv[2]
    set -l icon_url $argv[3]
    if test -z "$icon_url"
        echo "Usage: web2app <APP_NAME> <APP_URL> <ICON_URL> (IconURL must be in PNG -- use https://dashboardicons.com)"
        return 1
    end

    set -l icon_dir "$HOME/.local/share/applications/icons"
    set -l desktop_file "$HOME/.local/share/applications/$app_name.desktop"
    set -l icon_path "$icon_dir/$app_name.png"

    mkdir -p "$icon_dir"

    if ! curl -sL -o "$icon_path" "$icon_url"
        echo "Error: Failed to download icon."
        return 1
    end

    echo "\
    [Desktop Entry]
    Version=1.0
    Name=$app_name
    Comment=$app_name
    Exec=chromium --new-window --ozone-platform=wayland --app="$app_url" --name="$app_name" --class="$app_name"
    Terminal=false
    Type=Application
    Icon=$icon_path
    StartupNotify=true\
    " >"$desktop_file"

    chmod +x "$desktop_file"

    echo "Added $app_name"
end
