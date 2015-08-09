# CloudStack Git Tree Manipulation
Examples of git tree manipulation for different development and release scenarios

## Scenarios

For the scenarios and detailed explanations, please see our [Wiki](https://github.com/schubergphilis/cloudstack-git-tree-manipulation/wiki)

## Using the merge scripts

### git-pr

This script can be used to merge a pull request from a GitHub into the current local branch (tipically master, but not necessarily).

Requirements: basic Python (sys/json modules) and bash

The script takes the pull request number (a.k.a. id) as its only argument.
```bash
git-pr 1
```

If you put this script in your $PATH, or add the directory to the $PATH, you'll be able to use it like this:

```bash
git pr 1
```


### git-fwd-merge

This script can be used to merge a branch into another branch, while creating a merge message that indicates the merge to be about bringing a fix from a branch to another.

Requirements: basic Python (sys/json modules) and bash

The script takes the branch you want to merge as its only argument, and assumes the current checked-out branch is the branch you want to merge into.
The branch given as argument can be either local or remote (in which case the branch name is prepended with the name of the remote).
```bash
git-fwd-merge some-branch
```

If you put this script in your $PATH, or add the directory to the $PATH, you'll be able to use it like this:

```bash
git fwd-merge some-branch
```
