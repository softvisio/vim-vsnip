#!/usr/bin/env bash

set -Eeuo pipefail
trap 'echo "⚠  Error ($0:$LINENO, exit code: $?): $BASH_COMMAND" >&2' ERR

old_commit=$(git rev-parse upstream)

git fetch upstream

new_commit=$(git rev-parse upstream)

if [ "$old_commit" = "$new_commit" ]; then
  echo "No updates available"

  exit
fi

git switch update-metadata
git merge --no-edit upstream/master

git switch feat/migrate-treesitter
git merge --no-edit upstream/master

git switch main
git reset --hard $(git rev-list --max-parents=0 HEAD)
git merge --no-edit upstream/master

# git merge --no-edit update-metadata feat/migrate-treesitter
git merge --no-edit update-metadata
git merge --no-edit feat/migrate-treesitter

git push --all --force
