#!/usr/bin/env bash

set -e

. lib.sh
if [[ ! -z /tmp/base-php ]]; then
    rm -rf /tmp/base-php;
fi    
git clone "https://${GITHUB_MACHINE_USER}:${GITHUB_MACHINE_USER_API_TOKEN}@github.com/anaxexp/base-php" /tmp/base-php
cd /tmp/base-php
git remote add upstream https://github.com/docker-library/php --fetch
git fetch upstream --force 
git merge --strategy-option ours --no-edit upstream/master

./anaxexp-meta-update.sh

git_commit ./ "Merge changes from upstream"

git push origin
