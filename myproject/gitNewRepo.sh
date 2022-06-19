#!/usr/bin/env bash
#
# Usage:  ./gitNewRepo <github user> <project name> <--visibility>
#
# Copyright (C) 2022 Albert <albert@go-forward.net>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#

#readonly PROJDIR=\\wsl$\Debian\home\albert\projects
readonly PROJDIR=~/Projects

readonly USER="$1"
readonly PROJ="$2"
readonly VISB="$3"

main() {
#   Check if correct number of arguments exist
if [[ "$#" -lt 3 ]]; then
    usage
    exit 1
fi

# GitHub REST API OAuth using gh CLI
gh auth login --with-token < mytoken.txt

#. . . Create local git repository
cd $PROJDIR
mkdir $PROJ
cd $PROJ
echo ". . . Creating local Git repository and pushing it to the remote GitHub repository"
echo "# $USER/$PROJ" >> README.md
git init
git add .
git commit -m "initial commit"
git branch -M main
git remote add origin git@github.com:siralbert/$PROJ.git

#. . . Create remote repository on Github using gh CLI
if [[ "$VISB" == "--public" ]]; then
    gh repo create --public --source .
else  # [[ "$VISB" == "--private" ]]
    gh repo create --private --source .
fi

#git remote add origin git@github.com:siralbert/$PROJ.git
git push -u origin main
}

usage() {
    prettyprint "      (c) 2022 Albert" $LIGHTBLUE
    prettyprint "      Licensed under the GPL 3.0" $LIGHTBLUE
    echo ""
    echo "Creates a new local git repo and a remote repo on Github."
    echo ""
    prettyprint "usage: $0  <github user> <project name> <--visibility>" $YELLOW
    echo ""
    echo "BETA VERSION - bugs are present and not all features are correctly implemented"
}


declare NONEWLINE=1
# colours (v1.0)
declare BLUE='\E[1;49;96m' LIGHTBLUE='\E[2;49;96m'
declare RED='\E[1;49;31m' LIGHTRED='\E[2;49;31m'
declare GREEN='\E[1;49;32m' LIGHTGREEN='\E[2;49;32m'
declare YELLOW='\E[1;33m'
declare RESETSCREEN='\E[0m'
# prettyprint (v1.0)
prettyprint() {
#    (($loglevel&$QUIET)) && return
    [[ -z $nocolor ]] && echo -ne $2
    if [[ "$3" == "$NONEWLINE" ]]; then
        echo -n "$1"
    else
        echo "$1"
    fi
    [[ -z $nocolor ]] && echo -ne ${RESETSCREEN}
}

main "$@"
