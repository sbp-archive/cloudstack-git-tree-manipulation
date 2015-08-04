#!/bin/bash

# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

# Vars we need
tmpMessageFile=".git-tmp-message.txt"
tmpGemfile="Gemfile"
tmpVendorDir="vendor"

# Clean up
rm -fr ${tmpMessageFile} ${tmpGemfile} ${tmpGemfile}.lock .bundle

# Stop executing when we encounter errors
set -e

# Check if a pull request id was specified
prId=$1
if [ -z ${prId} ]; then
  echo "No PR number specified. Quiting."
  exit 1
fi

# Get ghi
echo "source 'https://rubygems.org'" >> ${tmpGemfile}
echo "gem 'ghi'" >> ${tmpGemfile}
bundle install --path=${tmpVendorDir}/bundle --binstubs=${tmpVendorDir}/bin 2>&1 >/dev/null

# Get vars from the GigHub API
prIssue=$(bundle exec ghi show ${prId} | head -n 2)
prAuthor=$(echo $prIssue | sed -e "s/^[^\@]*//" -e "s/ .*$//")
prTitle=$(echo $prIssue | sed -e "s/^[^[:alpha:]]*: //" -e "s/ @.*$//")

# Construct the subject line of the commit message
prSubject=$(echo "Merging #${prId} (${prAuthor}) ${prTitle}" | awk '{print substr($0,1,59)}')

# Add dots when we shortened the subject
subjectSize=${#prSubject}
if [ ${subjectSize} -eq 59 ]; then
    prSubject+=".."
fi

# Construct commit merge message
echo "${prSubject}" >> ${tmpMessageFile}
echo "" >> ${tmpMessageFile}

# Do the actual merge
git fetch origin pull/${prId}/head:pr/${prId}
git merge --no-ff --log -m "$(cat .git-tmp-message.txt)" pr/${prId}
git commit --amend -s --allow-empty-message -m ''

# Clean up
git branch -D pr/${prId}
rm -fr ${tmpMessageFile}${tmpGemfile} ${tmpGemfile}.lock ${tmpVendorDir} .bundle

