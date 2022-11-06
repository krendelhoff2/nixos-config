#!/bin/sh

#backs up git repos in your repo directory

. repos-setenvvars #set environment variables
if [ -z "$reposDir" ] || [ ! -d "$reposDir" ]; then
	echo "exiting, can't find reposDir or env variables not set"
	exit 1
fi

mkdir -p $reposBackupDir

for repo in $(ls -d $reposDir/*.git)
do
	repobase=$(basename $repo)
	checkSumFile=$reposBackupDir/sha-$repobase.sha256
	checkSumFileContents=$(cat $checkSumFile)
	checkSum=$(find $repo -type f -exec sha256sum {} \; | sha256sum)
	#check the old checksum vs the new one to see if the repo has changed
	if [ "$checkSum" == "$checkSumFileContents" ]; then
		echo "repo: '$repo' has not changed..."
		#don't need to do anything as the repo hasn't been updated
	else
		#tar the repo and then back it up to the cloud... remove the tar file when we're done
		echo "repo: '$repo' has changed... backing up..."
		tarFile=$reposBackupDir/$repobase.tar.gz
		tar -zcvf $tarFile $repo
		#TODO: transfer the tar file to cloud storage here
		rm -f $tarFile
		echo "finished backing up repo: '$repo'"
	fi
	#update the checksums 
	rm -f $checkSumFile
	echo "$checkSum" &> $checkSumFile
done
