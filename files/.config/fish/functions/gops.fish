function gops -d "git push origin"
    git push origin (git rev-parse --abbrev-ref HEAD | string trim) -u $argv
end
