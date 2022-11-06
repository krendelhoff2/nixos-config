#!/bin/sh

#deletes a git repo in your repo directory

#input a cli argument with the git repo to delete
set -e

. repos-setenvvars #set environment variables
if [ -z "$reposDir" ] || [ ! -d "$reposDir" ]; then
		echo "exiting, can't find reposDir or env variables not set"
			exit 1
		elif [ -z "$1" ]; then
			    echo "exiting, no repo name input to delete"
			        echo "usage: 'repos-delete <name-of-repo-to-delete>'"
				    exit 1
fi

case "$1" in
	*.git)
		    deleteRepoDir=$reposDir/$1
		        deleteRepoBackupHash=$reposDir/sha-$1.sha256 ;;
		*)
			    deleteRepoDir=$reposDir/$1.git
			        deleteRepoBackupHash=$reposBackupDir/sha-$1.git.sha256 ;;
		esac

		if [ ! -d "$deleteRepoDir" ]; then
			    echo "exiting, git repo at: '$deleteRepoDir' does not exist"
			        exit 1
		fi

		#ask for confirmation that the use actually wants to delete the repo
		read -p "Confirmation, would you like to delete the git repo at: '$deleteRepoDir' (y/n)? " choice
		case "$choice" in 
			  y|Y ) echo "Yes selected, deleting: '$deleteRepoDir'" ;;
			    n|N ) echo "No selected, exiting" && exit 0 ;;
			      * ) echo "invalid option, exiting" && exit 1 ;;
		      esac

		      rm -rf $deleteRepoDir

		      if [ -f "$deleteRepoBackupHash" ]; then
			          rm $deleteRepoBackupHash
		      fi

		      echo "git repo '$deleteRepoDir' has been deleted"
