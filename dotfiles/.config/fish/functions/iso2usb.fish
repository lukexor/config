function iso2usb -d dd
    set -l src $argv[1]
    set -l dst $argv[2]
    if test -z "$dst"
        echo "Usage: iso2sd <input_file> <output_device>"
        echo "Example: iso2sd ~/Downloads/ubuntu-25.04-desktop-amd64.iso /dev/sda"
        echo -e "\nAvailable devices:\n"
        lsblk
    else
        sudo dd bs=4M status=progress conv=fsync oflag=direct if="$src" of="$dst"
        sudo sync
        sudo eject $dst
    end
end
