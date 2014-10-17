# ==========================================================
# == .bashrc
# Loaded if interactive non-login shell

# Exit if not interactive
case "$-" in
    *i* ) ;;
    * ) return ;;
esac

# ----------------------------------------------------------
# -- Source

[ -f "/etc/bashrc" ] && source "/etc/bashrc"

# ----------------------------------------------------------
# -- Interactive Shell Variables

# Set ls colors
if type "dircolors" > /dev/null 2>&1&& [ -f "${HOME}/.dircolors-custom" ]; then
    eval $(dircolors ${HOME}/.dircolors-custom)
fi

# Misc
export EDITOR="vim"
export CLICOLOR=1
# export LSCOLORS="Gxfxcxdxbxegedabagacad"
export LSCOLORS="gxBxhxDxfxhxhxhxhxcxcx"

# ----------------------------------------------------------
# -- Colors

# Foreground
function setfg() { tput setaf $1; }
function setbfg() { tput bold; tput setaf $1; }
function setbg() { tput setab $1; }

FGblack=$(setfg 0)
FGred=$(setfg 1)
FGgreen=$(setfg 2)
FGyellow=$(setfg 3)
FGblue=$(setfg 4)
FGmagenta=$(setfg 5)
FGcyan=$(setfg 6)
FGwhite=$(setfg 7)

# Bold Foreground
FGgray=$(setbfg 0)
FGbred=$(setbfg 1)
FGbgreen=$(setbfg 2)
FGbyellow=$(setbfg 3)
FGbblue=$(setbfg 4)
FGbmagenta=$(setbfg 5)
FGbcyan=$(setbfg 6)
FGbwhite=$(setbfg 7)

# Background
BGblack=$(setbg 0)
BGred=$(setbg 1)
BGgreen=$(setbg 2)
BGyellow=$(setbg 3)
BGblue=$(setbg 4)
BGmagenta=$(setbg 5)
BGcyan=$(setbg 6)
BGwhite=$(setbg 7)

# RCLR="${S}0m"
RCLR=$(tput sgr0)

# ----------------------------------------------------------
# -- Shell Options

# Bash 4.00 specific options
if [[ $BASH_VERSINFO > 3 ]]; then
    shopt -s autocd # Allow cding to directories by typing the directory name
    shopt -s checkjobs # Defer exiting shell if any stopped or running jobs
    shopt -s dirspell # Attempts spell correction on directory names
fi

shopt -s cdable_vars # Allow passing directory vars to cd
shopt -s cdspell # Correct slight mispellings when cd'ing
shopt -s checkhash # Try to check hash table before path search
shopt -s cmdhist # Saves multi-line commands to history
shopt -s expand_aliases # Allows use of aliases
# shopt -s extdebug # Enables extra debug options like declare -F
shopt -s extglob # Extended pattern matching
shopt -s extquote # String quoting within parameter expansions
shopt -s histappend # Append history from a session to HISTFILE instead of overwriting
shopt -s no_empty_cmd_completion # Don't try to path search on an empty line
shopt -s nocaseglob # Case insensitive pathname expansion
shopt -s progcomp # Programmable completion capabilities
shopt -s promptvars # Expansion in prompt strings

set -o noclobber # Prevent clobbering of files with redirects

# ----------------------------------------------------------
# -- Plugins

function sourcefile() { [ -r "${1}" ] && source ${1}; }

# Autojump
sourcefile "/etc/profile.d/autojump.bash" # root install
sourcefile "${HOME}/.autojump/etc/profile.d/autojump.bash" # non-root install

# perlbrew
sourcefile "${HOME}/perl5/perlbrew/etc/bashrc"

export PLUGIN_DIR="${HOME}/.plugins/"
export BASH_THEME="${HOME}/.themes/zhayedan.sh"

plugins=(host aliases functions git git-completion github perl python django battery prompt-info svn ssh-agent)
export SSH_AGENT_FWD="yes"

# Load all of the plugins
for plugin in ${plugins[@]}
do
    if [ "${plugin}" == "host" ]
    then
        pfile="$PLUGIN_DIR/$plugin/${HOSTNAME}.plugin.sh"
        sfile="$PLUGIN_DIR/$plugin/secure/${HOSTNAME}.plugin.sh"
    else
        pfile="$PLUGIN_DIR/$plugin/$plugin.plugin.sh"
    fi
    sourcefile $pfile
    sourcefile $sfile
    unset pfile
done

# Load theme
sourcefile $BASH_THEME

# Load virtualenvwrapper
sourcefile /usr/local/bin/virtualenvwrapper.sh

# ----------------------------------------------------------
# -- Startup

# Alert if no journal entries have been added in the last day
if [ -d "${HOME}/.journal" ]; then
    date=$(date "+%Y-%m-%d")
    entries=$(journal -v "$date" | grep -Pc '^\[')
    if [ $entries -lt 8 ]; then
        remaining=$(expr 8 - $entries)
        entry='entries'
        if [[ $remaining == 1 ]]; then entry='entry'; fi
        echo ""
        echo -e "${FGyellow}Don't forget to add at least $remaining more journal $entry this month!!${RCLR}"
        echo ""
        unset remaining
        unset entry
    fi
    unset date
    unset entries
fi

echo -e "Vim Shortcuts"
echo -e "-------------"
echo "<F1>  NERDTree/TagBar         --  <F2>  Toggle paste          --  <F3>  Toggle wrap/list     --  <F4>  Toggle line #s        -- <F5>  SyntasticCheck"
echo ",,    Search files            --  ,.    Search tags           --  ,m    Search recent        --  ,r    Show yanks            "
echo ",tn   New tab                 --  ,ep   Edit snippets         --  ,s    Strip trailing       --  ,rt   Retab spaces w/ tabs  "
echo ",mt   Toggle ShowMarks        --  ,ma   Clear all marks       --  <tab> Word completion      --"
echo "cs\"'  Replace \" with '        --  ysiw] Surround with ]       --  ds]   Delete surounding ]  -- "

n ${HOSTNAME}
