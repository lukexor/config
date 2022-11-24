function fzf_history -d "fuzzy search history to execute"
    commandline -r (builtin history | fzf)
    commandline -f repaint
end
