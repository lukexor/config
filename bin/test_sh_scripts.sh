#!/bin/sh
#
# This is a script to run syntax check (via `sh -n $filename`) but it
# supports recursive checking and --quiet

QUIET=0
while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        --quiet)
            QUIET=1
            ;;
    esac
    shift
done

find . -name '*.sh' > /tmp/shell_script_list
failed_shell_scripts=""
while read filename ; do
    OUTPUT=`sh -n "$filename" 2>&1 >/dev/null 2>&1`
    if [ "$?" == "0" ]; then
        echo -n "."
    else
        if [ "$QUIET" == "1" ]; then
            echo -n "F"
        else
            echo "F"
            echo "$filename"
            sh -n "$filename"
            echo ""
        fi
    fi
done </tmp/shell_script_list
echo ""
if [ "$QUIET" == "0" ]; then
    echo "test with \"sh -n \$file\""
fi

