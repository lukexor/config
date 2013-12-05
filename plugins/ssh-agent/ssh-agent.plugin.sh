export _plugin__ssh_env="${HOME}/.ssh/ssh-agent-${HOSTNAME}"
export _plugin__ssh_ids

if [ $(ssh-add -L > /dev/null 2>&1 && echo "1") ]
then
    _plugin__ssh_ids="yes"
fi

function _plugin__start_agent()
{
    # start ssh-agent and setup environment

    /usr/bin/env ssh-agent | sed 's/^echo/#echo/' >| ${_plugin__ssh_env}
    chmod 600 ${_plugin__ssh_env}
    . ${_plugin__ssh_env} > /dev/null

    # Load identities
    echo "Starting ssh-agent..."
    # if [ ! -z "${IDENTITIES}" ] # If IDENTITIES is defined
    # then
    #     echo "Loading identities..."
    #     for id in ${IDENTITIES[@]}
    #     do
    #         if [ -f "${id}" ] # If the file exists
    #         then
    #             shopt -s nocasematch # Enable case insensitive regex
    #             if [[ "${id}" =~ pkcs11 ]]
    #             then
    #                 /usr/bin/ssh-add -s "${id}"
    #             else
    #                 /usr/bin/ssh-add "${id}"
    #             fi
    #             shopt -u nocasematch # Disable case insensitive regex
    #         else
    #             echo "Identity file '${id}' not found!"
    #         fi
    #     done
    # else
    #     echo "No identities defined!"
    # fi
}

# If FWD is enabled and theres an ssh-agent connected, set up symlink
if [[ ${SSH_AGENT_FWD} == "yes" && -n "$SSH_AUTH_SOCK" ]]
then
    # Add a nifty symlink for screen/tmux if agent forwarding
    [[ -L $SSH_AUTH_SOCK ]] || ln -sf "$SSH_AUTH_SOCK" /tmp/ssh-agent-$USER-screen 2>/dev/null
# If there are no identities in ssh-add and there's an env file, source it
elif [[ ${_plugin__ssh_ids} != "yes" && -f "${_plugin__ssh_env}" ]]
then
    # Source SSH settings, if applicable
    . ${_plugin__ssh_env} > /dev/null
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
      _plugin__start_agent;
    }
# Else just try to start agent if there are no identities
elif [[ ${_plugin__ssh_ids} != "yes" ]]
then
    _plugin__start_agent;
fi

# tidy up after ourselves
unset -f _plugin__start_agent
unset _plugin__forwarding
unset _plugin__ssh_env
unset _plugin__ssh_ids
