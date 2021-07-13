#!/bin/bash
# modified from http://ficate.com/blog/2012/10/15/battery-life-in-the-land-of-tmux/

HEART='♥ '

if [[ `uname` == 'Linux' ]]; then
  current_charge=$(cat /proc/acpi/battery/BAT1/state | grep 'remaining capacity' | awk '{print $3}')
  total_charge=$(cat /proc/acpi/battery/BAT1/info | grep 'last full capacity' | awk '{print $4}')
  charged_slots=$(echo "((($current_charge/$total_charge)*10)/3)+1" | bc -l | cut -d '.' -f 1)
  if [[ $charged_slots -gt 3 ]]; then
    charged_slots=3
  fi

  echo -n '#[fg=colour196]'
  for i in `seq 1 $charged_slots`; do echo -n "$HEART"; done

  if [[ $charged_slots -lt 3 ]]; then
    echo -n '#[fg=colour254]'
    for i in `seq 1 $(echo "3-$charged_slots" | bc)`; do echo -n "$HEART"; done
  fi
else
  PERCENT=`pmset -g batt | \grep -o "[0-9]\{1,3\}%"`
  BAT=`echo $PERCENT | grep -o "[0-9]\{1,3\}"`
  if [[ $BAT -lt 20 ]]; then
    echo -n '#[fg=colour196]'
  elif [[ $BAT -lt 50 ]]; then
    echo -n '#[fg=colour226]'
  else
    echo -n '#[fg=colour155]'
  fi
  echo $PERCENT
fi
