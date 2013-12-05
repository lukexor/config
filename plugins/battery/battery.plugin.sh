# ==========================================================
# == Battery Charge Indicator
# This plugin prints the percentage of battery remaining and the time only while
# the battery is discharging or re-charging

if [[ $(acpi 2> /dev/null | grep -c '^Battery') -gt 0 ]]
then
    function battery_pct_remaining()
    {
        echo $(acpi | cut -f2 -d ',' | tr -cd '[:digit:]');
    }
    function battery_time_remaining()
    {
        echo $(acpi | cut -f3 -d ',' | grep -Po '\d{2}:\d{2}:\d{2}');
    }
    # Whether the batter is charging or not
    function battery_charging()
    {
        echo $(acpi | cut -f3 -d ','| grep 'until charged');
    }
    # Sets the prompt formatting
    function battery_pct_prompt()
    {
        percent=$(battery_pct_remaining)

        # Set time to charge/discharge
        if [ "$(battery_time_remaining)" ] && [ "$(battery_charging)" ]
        then
            time=' +'$(battery_time_remaining)
        elif [ "$(battery_time_remaining)" ]
        then
            time=' -'$(battery_time_remaining)
        else
            time=''
        fi

        if [ $percent -gt 50 ]
        then
            color="${FGgreen}"
        elif [ $percent -gt 20 ]
        then
            color="${FGyellow}"
        else
            color="${FGred}"
        fi

        if [ $(battery_pct_remaining) -lt 100 ]
        then
            echo -e " \[${color}\]("$(battery_pct_remaining)"%$time)\[${RCLR}\]"
        fi
    }
else
    error_msg=''
    function battery_pct_remaining() { echo $error_msg; }
    function battery_time_remaining() { echo $error_msg; }
    function battery_pct_prompt() { echo ''; }
fi
