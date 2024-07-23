function ra -d "Start or Restart ssh-agent and add ssh-keys"
    echo "Restarting ssh-agent..."

    pkill ssh-agent
    rm -f $agent_info $agent_file

    set -l agent (ssh-agent -s -a $agent_file | string collect)
    echo $agent > $agent_info

    set -gx SSH_AUTH_SOCK $agent_file
    set -gx SSH_AGENT_PID (rg -o '=\d+' $agent_info | string replace = '' | string trim)

    for file in id_rsa id_ed25519
        if test -f ~/.ssh/$file
            ssh-add ~/.ssh/$file
        end
    end
end
