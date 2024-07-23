function glg -d "git log --pretty"
    git log --no-merges --pretty=format:"%C(yellow)%h (%p) %ai%Cred%d %Creset%Cblue[%ae]%Creset %s (%ar). %b %N" $argv
end
