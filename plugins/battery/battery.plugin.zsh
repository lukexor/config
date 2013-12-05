if [[ $(acpi 2&>/dev/null | grep -c '^Battery') -gt 0 ]] ; then
  function battery_pct_remaining() { echo $(acpi | cut -f2 -d ',' | tr -cd '[:digit:]') }
  function battery_time_remaining() { echo $(acpi | cut -f3 -d ',' | grep -Po '\d{2}:\d{2}:\d{2}') }
  function battery_charging { echo $(acpi | cut -f3 -d ','|grep 'until charged') }
  function battery_pct_prompt() {
    b=$(battery_pct_remaining)

    # Set time to charge/discharge
    if [ "$(battery_time_remaining)" ] && [ "$(battery_charging)" ]; then
      t=' (+'$(battery_time_remaining)')'
    elif [ "$(battery_time_remaining)" ]; then
      t=' (-'$(battery_time_remaining)')'
    else
      t=''
    fi

    if [ $b -gt 50 ] ; then
      color='green'
    elif [ $b -gt 20 ] ; then
      color='yellow'
    else
      color='red'
    fi

    if [ $(battery_pct_remaining) -lt 100 ]; then
      echo "%{$fg[$color]%}$(battery_pct_remaining)%%$t%{$reset_color%}"
    fi
  }
else
  error_msg=''
  function battery_pct_remaining() { echo $error_msg }
  function battery_time_remaining() { echo $error_msg }
  function battery_pct_prompt() { echo '' }
fi
