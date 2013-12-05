#!/bin/bash
# Author - Kasun Gajasinghe
HEAD="HEAD"
limit="${1}"
[[ -z "$1" ]] && limit=5

if [[ -d .svn ]]
then
    revisions=($(svn log -l "${limit}" | grep -r "r[0-9][0-9]*\w" -o | grep -r "[0-9][0-9]*" -o))
    mkdir -p diffs
    echo "${revisions}" > diffs/revisions.log

    for revision in ${revisions[@]}
    do
            diff=$(svn diff --config-dir="/tmp" -r ${revision}:${HEAD})
            echo "${diff}" | tee diffs/diffs-${revision}-${HEAD}.log
            echo "=======================" | tee diffs/diffs-${revision}-${HEAD}.log
            HEAD="${revision}"
    done
else
    echo "Not a SVN repository."
fi
