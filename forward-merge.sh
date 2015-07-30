#!/bin/bash

tmpMessageFile=".git-tmp-message.txt"

rm -f ${tmpMessageFile}

set -e

branch=$1

if [ -z ${branch} ]; then
  echo "No branch specified. Quiting."
  exit 1
fi

currentBranch=$(git branch | grep "^*" | sed -e "s/^[*] //")
echo "Merge fix release ${branch} to ${currentBranch}" >> ${tmpMessageFile}

git merge --no-ff --log -m "$(cat .git-tmp-message.txt)" ${branch}

rm -fr ${tmpMessageFile}
