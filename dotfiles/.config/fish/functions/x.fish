function x -a filename -d "extract compressed file"
    set -l filename $argv[1]
    switch $filename
        case "*.tar.bz2"
            tar xvjf $argv
        case "*.tar.gz"
            tar xvzf $argv
        case "*.tar.xz"
            tar --xz -xvf $argv
        case "*.tar.zma"
            tar --lzma -xvf $argv
        case "*.tar.zst"
            tar xvf $argv
        case "*.7z"
            7za x $argv
        case "*.Z"
            uncompress $argv
        case "*.bz2"
            bunzip2 $argv
        case "*.deb"
            ar vx $argv
        case "*.gz"
            gunzip $argv
        case "*.lzma"
            unlzma $argv
        case "*.rar"
            unrar e -ad $argv
        case "*.tar"
            tar xvf $argv
        case "*.tbz"
            tar xvjf $argv
        case "*.tbz2"
            tar xvjf $argv
        case "*.tgz"
            tar xvzf $argv
        case "*.tlz"
            tar --lzma -xvf $argv
        case "*.txz"
            tar --xz -xvf $argv
        case "*.xz"
            unxz $argv
        case "*.zip"
            unzip $argv
        case ""
            echo "Error! Must pass a file to extract"
            return 1
        case "*"
            echo "Error! Unsupported file extension"
            return 2
    end
end

complete -c x -F
