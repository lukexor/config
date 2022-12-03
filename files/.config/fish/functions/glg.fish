function glg -d "git log --pretty"
    git log --graph --pretty=format:"%C(yellow)%h (%p) %ai%Cred%d %Creset%Cblue[%ae]%Creset %s (%ar). %b %N" $argv
end
