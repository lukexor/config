function gage -d "Show git branches by age"
    git branch -a \
        --sort=committerdate \
        --format="\
%(HEAD) %(color:yellow)%(align:20,left)%(refname:short)%(end)%(color:reset)%09\
%(color:red)%(align:left,10)%(objectname:short)%(end)%(color:reset)%09\
%(contents:subject)%09\
%(authorname)%09\
(%(color:green)%(committerdate:relative)%(color:reset))"
end
