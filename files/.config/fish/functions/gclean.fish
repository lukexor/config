function gclean -d "Remove old branches"
    for branch in (git branch -v | rg "\[gone\]" | awk '/\s*\w*\s*/ {print $1}')
        git branch -d -f $branch
    end
end
