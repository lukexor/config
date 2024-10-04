function x -a "filename" -d "extract compressed file"
    set -l filename $argv[1]
    switch $filename
        case "*.tar.bz2"
            tar xvjf $filename
        case "*.tar.gz"
            tar xvzf $filename
        case "*.tar.xz"
            tar --xz -xvf $filename
        case "*.tar.zma"
            tar --lzma -xvf $filename
        case "*.tar.zst"
            tar xvf $filename
        case "*.7z"
            7za x $filename
        case "*.Z"
            uncompress $filename
        case "*.bz2"
            bunzip2 $filename
        case "*.deb"
            ar vx $filename
        case "*.gz"
            gunzip $filename
        case "*.lzma"
            unlzma $filename
        case "*.rar"
            unrar e -ad $filename
        case "*.tar"
            tar xvf $filename
        case "*.tbz"
            tar xvjf $filename
        case "*.tbz2"
            tar xvjf $filename
        case "*.tgz"
            tar xvzf $filename
        case "*.tlz"
            tar --lzma -xvf $filename
        case "*.txz"
            tar --xz -xvf $filename
        case "*.xz"
            unxz $filename
        case "*.zip"
            unzip $filename
        case ""
            echo "Error! Must pass a file to extract"
            return 1
        case "*"
            echo "Error! Unsupported file extension"
            return 2
    end
end

complete -c x -F
