function fzf_dir -d "fuzzy search for a directory"
    commandline -i (fd -t d | fzf)
    set dir_status $status
    commandline -f repaint
    if test $dir_status -eq 0
        commandline -f execute
    else
        commandline -r ""
    end
end
