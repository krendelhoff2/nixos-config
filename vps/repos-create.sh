#!/bin/sh

#creates a git repo in your repo directory

#input a cli argument with the git repo to create
set -e

. repos-setenvvars #set environment variables
if [ -z "$reposDir" ] || [ ! -d "$reposDir" ]; then
	echo "exiting, can't find reposDir or env variables not set"
	exit 1
fi

if [ -z "$1" ]; then
    echo "exiting, no repo name input to create"
    echo "usage: 'repos-create <name-of-repo-to-create>'"
    exit 1
fi

case "$1" in
	*.git)
		newRepoDir=$reposDir/$1 ;;
	*)
		newRepoDir=$reposDir/$1.git ;;
	esac

	if [ -d "$newRepoDir" ]; then
	    echo "repo: '$newRepoDir' already exists, exiting..."
            exit 1
		else
			    echo "creating new repo: '$newRepoDir'"
			        mkdir -p $newRepoDir
				    cd $newRepoDir
				        git init --bare
					    chown -R git:users $newRepoDir
					    echo "new repo: '$newRepoDir' created"

	fi
