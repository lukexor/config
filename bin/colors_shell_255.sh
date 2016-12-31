#!/bin/bash

for c in {0..255} ; do
    echo -ne "\e[38;05;${c}m e38;05;${c}m Bash Color: e48;05;${c}m"
    echo -ne "\e[48;05;${c}m ${c}"
    echo -e "\e[00m"
done

