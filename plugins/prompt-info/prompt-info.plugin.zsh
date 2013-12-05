function active_screens { echo $(screen -ls | grep -c Detach) }
function bg_jobs { echo $(jobs -r | wc -l) }
function st_jobs { echo $(jobs -s | wc -l) }
function active_screens_prompt {
  scr=$(active_screens)

  if [ $scr -gt 2 ] ; then
    color='red'
  elif [ $scr -gt 0 ] ; then
    color='yellow'
  fi

  if [ $scr -gt 0 ] ; then
    echo "%{$fg[cyan]%}(%{$fg[$color]%}$(active_screens)%{$fg[cyan]%}) "
  fi
}

function bg_jobs_prompt {
  j=$(bg_jobs)

  if [ $j -gt 2 ] ; then
    color='red'
  elif [ $j -gt 0 ] ; then
    color='yellow'
  fi

  if [ $j -gt 0 ] ; then
    echo "%{$fg[cyan]%}[%{$fg[$color]%}$(bg_jobs)%{$fg[cyan]%}] "
  fi
}

function st_jobs_prompt {
  j=$(st_jobs)

  if [ $j -gt 2 ] ; then
    color='red'
  elif [ $j -gt 0 ] ; then
    color='yellow'
  fi

  if [ $j -gt 0 ] ; then
    echo "%{$fg[cyan]%}{%{$fg[$color]%}$(st_jobs)%{$fg[cyan]%}} "
  fi
}
