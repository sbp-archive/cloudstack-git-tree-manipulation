# cloudstack-git-tree-manipulation
Examples of git tree manipulation for different development and release scenarios (see [Wiki](https://github.com/schubergphilis/cloudstack-git-tree-manipulation/wiki))

## Using the merge scripts

### merge-pr.sh

This script can be used to merge a pull request from a GitHub into the current local branch (tipically master, but not necessarily).

In order to write a nice merge commit message that includes the pull request title and author, the script uses a tool [ghi](https://github.com/stephencelis/ghi) that queries GitHub API, and that is executed in a temporary ruby environment created with the bundle tool. So, that means ruby (with bundle) is a requirement to run this script.

For example, on a mac with brew, installing ruby with a bundle tool is as easy as `brew install ruby`.

The script takes the pull request number (a.k.a. id) as its only argument.
```bash
merge-pr.sh 1
```

### forward-merge.sh

This script can be used to merge a branch into another branch, while creating a merge message that indicates the merge to be about bringing a fix from a branch to another.

There are no additional requirements for running this script (besides git, and normal command line tools like grep and sed).

The script takes the branch you want to merge as its only argument, and assumes the current checked-out branch is the branch you want to merge into.
The branch given as argument can be either local or remote (in which case the branch name is prepended with the name of the remote).
```bash
forward-merge.sh some-branch
```
