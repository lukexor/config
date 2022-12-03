function gopsn -d "git push origin --no-verify"
    git push origin (git rev-parse --abbrev-ref HEAD | string trim) -u --no-verify $argv
end
