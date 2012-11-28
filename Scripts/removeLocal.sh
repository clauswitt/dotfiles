#!/bin/bash
TMPFILE=".tmpGitLocals"
git branch --merged > $TMPFILE
COMMIT=$1
if [[ $COMMIT == "commit" ]]; then 
	echo "deleting git branches"
else
	echo "dry run - call with commit to delete branches"
fi

function illegalBranch() {
    if [[ "$1" == "master" ]]; then 
         echo 1
         exit
    fi
    if [[ "$1" == "live" ]]; then 
         echo 1
         exit
    fi
    if [[ "$1" == "staging" ]]; then 
         echo 1
         exit
    fi
    if [[ "$1" == "* master" ]]; then 
         echo 1
         exit
    fi
    
    echo 0
}

while read line; do
    RESULT=`illegalBranch "$line"`
	if [ $RESULT -eq 0 ]; then
		if [[ $COMMIT == "commit" ]]; then 
			echo "running: git branch -d $line"
			git branch -d $line
		else
			echo "git branch -d $line"
		fi
	fi
done<$TMPFILE


rm $TMPFILE
