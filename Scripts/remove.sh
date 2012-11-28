#!/bin/bash
TMPFILE=".tmpGitRemotes"
REMOTENAME="origin"
COMMIT=$1
git fetch
git branch -a --merged |grep "remotes/$REMOTENAME/" > $TMPFILE

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
    if [[ "$1" == "HEAD" ]]; then 
         echo 1
         exit
    fi
    echo 0
}


while read line; do
	BRANCHNAME=`basename $line`
    RESULT=`illegalBranch "$BRANCHNAME"`
	if [ $RESULT -eq 0 ]; then
		if [[ $COMMIT == "commit" ]]; then 
			echo "running: git push $REMOTENAME :$BRANCHNAME"
			git push $REMOTENAME :$BRANCHNAME
		else
			echo "git push $REMOTENAME :$BRANCHNAME"
		fi
	fi
done<$TMPFILE


rm $TMPFILE
