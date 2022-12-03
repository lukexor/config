function fbroken -a "path" -w find -d "find broken symlinks"
    set -l path $argv[0] or "."
    find $path -maxdepth 1 -type l ! -exec test -e '{}' ';' -print $argv
end

complete -c fbroken -F
