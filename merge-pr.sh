#!/bin/bash

tmpMessageFile=".git-tmp-message.txt"
tmpGemfile="Gemfile"
tmpVendorDir="vendor"

rm -fr ${tmpMessageFile} ${tmpGemfile} ${tmpGemfile}.lock .bundle

set -e

prId=$1

if [ -z ${prId} ]; then
  echo "No PR number specified. Quiting."
  exit 1
fi

echo "source 'https://rubygems.org'" >> ${tmpGemfile}
echo "gem 'ghi'" >> ${tmpGemfile}
bundle install --path=${tmpVendorDir}/bundle --binstubs=${tmpVendorDir}/bin

prIssue=$(bundle exec ghi show ${prId} | head -n 2)
prAuthor=$(echo $prIssue | sed -e "s/^[^\@]*//" -e "s/ .*$//")
prTitle=$(echo $prIssue | sed -e "s/^[^[:alpha:]]*: //" -e "s/ @.*$//")

echo "Merge pull request #${prId} from ${prAuthor}" >> ${tmpMessageFile}
echo "" >> ${tmpMessageFile}
echo "${prTitle}" >> ${tmpMessageFile}

git fetch origin pull/${prId}/head:pr/${prId}
git merge --no-ff --log -m "$(cat .git-tmp-message.txt)" pr/${prId}
git commit --amend -s --allow-empty-message -m ''

git branch -D pr/${prId}

rm -fr ${tmpMessageFile} ${tmpGemfile} ${tmpGemfile}.lock ${tmpVendorDir} .bundle
