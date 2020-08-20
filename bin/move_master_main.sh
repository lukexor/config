#!/bin/sh

echo "Renaming 'master' branch to 'main'"
git checkout master
git branch -m master main
echo "Pushing main to origin"
git push origin HEAD
read -rep $'\nPress enter once you\'ve changed your default branch to main\nGitHub: Settings -> Branches\n'
echo "Deleting origin/master"
git push origin :master
git remote set-head origin -a
