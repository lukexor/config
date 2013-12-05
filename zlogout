##==========================================================================##
# zlogout
##==========================================================================##

if [[ -o login ]]; then
    clear
    # if [ ! -z $SSH_AGENT_PID ]; then
        # kill $SSH_AGENT_PID
        # ssh-add -D
        # ssh_agent=${HOME}/.ssh/ssh-agent

        # [ -f $ssh_agent ] && rm -f $ssh_agent
    # fi
else
    exit
fi
