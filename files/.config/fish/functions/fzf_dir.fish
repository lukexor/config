function fzf_dir -d "fuzzy search for a directory"
    commandline -i (fd -t d | fzf)
    set dir_status $status
    commandline -f repaint
end
