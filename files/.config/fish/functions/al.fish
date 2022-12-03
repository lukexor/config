function al -a "log entry" -d "log activity"
    set -l date (date +"%Y-%m-%d %H:%M")
    echo "[$date]: $argv" >> $activity_log 
end
