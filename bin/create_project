#!/bin/bash

if [[ -z $1 ]]; then
    echo "usage: create_project <project_name>"
    exit 1
fi

if [[ -d $1 ]]; then
    echo "A project named '$1' already exists."
    exit 1
fi

mkdir $1
cd $1

DIRS=(
    'bin'
    'build'
    'doc'
    'ide'
    'lib'
    'log'
    'res/asset'
    'res/config'
    'res/data'
    'res/template'
    'src/test/automated'
    'src/test/manual'
    'src/util'
    'www/css'
    'www/js'
    'www/images'
    'tmp'
)
for dir in ${DIRS[@]}; do
    mkdir -p $dir
done

FILES=(
    'INSTALL'
    'LICENSE'
    'README'
)
for file in ${FILES[@]}; do
    touch $file
done

exit 0
