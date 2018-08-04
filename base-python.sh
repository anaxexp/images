#!/usr/bin/env bash

set -e

. lib.sh

git clone "https://${GITHUB_MACHINE_USER}:${GITHUB_MACHINE_USER_API_TOKEN}@github.com/anaxexp/base-python" /tmp/base-python
cd /tmp/base-python
git remote add upstream https://github.com/docker-library/python
git fetch upstream
git merge --strategy-option ours --no-edit upstream/master

./anaxexp-meta-update.sh

git_commit ./ "Merge changes from upstream"

git push origin
