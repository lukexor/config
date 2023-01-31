function fzf_file -d "fuzzy search for a file"
    commandline -i (fzf)
    set file_status $status
    commandline -f repaint
    if test $file_status -eq 0
        commandline -f execute
    else
        commandline -r ""
    end
end

