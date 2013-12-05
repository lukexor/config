# function hax {
    msg=$1
    let lnstr=$(expr length "$msg")-1
    for (( i=0; i <= $lnstr; i++ ))
    do
            echo -n "${msg:$i:1}"
            sleep .1
    done
# }
