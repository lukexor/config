function fzf_file -d "fuzzy search for a file"
    commandline -i (fzf)
    set file_status $status
    commandline -f repaint
end
