
function gclean -d "Remove old branches"
    for branch in (git branch | rg "\[gone\]")
      git branch -d $branch
    end
end
