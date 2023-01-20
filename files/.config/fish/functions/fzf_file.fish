function fzf_file -d "fuzzy search for a file"
    commandline -i (fzf)
    commandline -f repaint
    commandline -f execute
end

