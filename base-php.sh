#!/usr/bin/env bash

set -e

. lib.sh

git clone "https://${GITHUB_MACHINE_USER}:${GITHUB_MACHINE_USER_API_TOKEN}@github.com/anaxexp/base-php" /tmp/base-php
cd /tmp/base-php
git remote add upstream https://github.com/docker-library/php
#git fetch upstream
git pull upstream master --allow-unrelated-histories
git merge --strategy-option ours --no-edit upstream upstream/master

./anaxexp-meta-update.sh

git_commit ./ "Merge changes from upstream"

git push origin
