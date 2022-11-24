function fzf_dir -d "fuzzy search for a directory"
    commandline -i (fd -t d | fzf)
    commandline -f repaint
end
