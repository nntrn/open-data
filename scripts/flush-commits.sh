#!/usr/bin/env bash

LOG_BEFORE=gitbefore.txt
LOG_AFTER=gitafter.txt

_bye() {
  echo -e "\033[0;31mERROR: \033[0m${1}\033[0m" 3>&2 2>&1 >&3 3>&-
  exit 1
}

regex_check() {
  eval "ls -1 $1" &>/dev/null
  return $?
}

cd "$(git rev-parse --show-toplevel)" || exit 1

## CHECKS ######################
UNSTAGED_FILES=($(git ls-files -m))
[[ ${#UNSTAGED_FILES[@]} -gt 0 ]] &&
  _bye "Resolve unstaged files before rerunning"

[[ -z $1 ]] &&
  _bye "Provide path to scrub from history. Example: catalog/*.md"

! regex_check "$1" &&
  _bye "Invalid path"

### MAIN ########################
[[ ! -f $LOG_BEFORE ]] && git log --name-status >$LOG_BEFORE

# remove history for provided path
git filter-branch --index-filter "git rm --cached --ignore-unmatch $1" HEAD

# remove empty commits created from previous step
git filter-branch --commit-filter 'git_commit_non_empty_tree "$@"' -f HEAD

git log --name-status >$LOG_AFTER

sdiff -s $LOG_BEFORE $LOG_AFTER
