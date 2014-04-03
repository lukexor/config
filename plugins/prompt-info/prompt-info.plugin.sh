# ==========================================================
# == prompt-info plugin
# Provides functions for adding information to the command prompt

function active_screens()
{
    echo $(screen -ls 2>/dev/null | grep -c Detach)
}
function bg_jobs()
{
    echo $(jobs -r | wc -l)
}
function st_jobs()
{
    echo $(jobs -s | wc -l)
}
function active_screens_prompt()
{
  scr=$(active_screens)

  if [ $scr -gt 2 ] ; then
    color="${FGred}"
  elif [ $scr -gt 0 ] ; then
    color="${FGyellow}"
  fi

  if [ $scr -gt 0 ] ; then
    echo -e " \033${FGcyan}(\033${color}s$(active_screens)\033${FGcyan})"
  fi
}

function bg_jobs_prompt()
{
  j=$(bg_jobs)

  if [ $j -gt 2 ] ; then
    color="${FGred}"
  elif [ $j -gt 0 ] ; then
    color="${FGyellow}"
  fi

  if [ $j -gt 0 ] ; then
    echo -e " \033${FGcyan}(\033${color}b$(bg_jobs)\033${FGcyan})"
  fi
}

function st_jobs_prompt()
{
  j=$(st_jobs)

  if [ $j -gt 2 ] ; then
    color="${FGred}"
  elif [ $j -gt 0 ] ; then
    color="${FGyellow}"
  fi

  if [ $j -gt 0 ] ; then
    echo -e " \033${FGcyan}(\033${color}st$(st_jobs)\033${FGcyan})"
  fi
}
