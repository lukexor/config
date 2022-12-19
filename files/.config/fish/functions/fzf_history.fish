function fzf_history -d "fuzzy search history to execute"
    commandline -r (builtin history | fzf +s --history-size=200)
    commandline -f repaint
end
