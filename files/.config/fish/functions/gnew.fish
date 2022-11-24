function gnew -d "Show new changes in the last day"
    git --no-pager log \
      --graph \
      --pretty=format:"%C(yellow)%h %ad%Cred%d %Creset%Cblue[%cn]%Creset  %s (%ar)" \
      --date=iso \
      --all \
      --since="23 hours ago"
end
