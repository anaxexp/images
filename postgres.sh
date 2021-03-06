#!/usr/bin/env bash

set -e

. lib.sh

# http://www.databasesoup.com/2016/05/changing-postgresql-version-numbering.html
versions=(10 9.6 9.5 9.4 9.3)

user="${GITHUB_MACHINE_USER}"
token="${GITHUB_MACHINE_USER_API_TOKEN}"

git clone --depth=1 "https://${user}:${token}@github.com/anaxexp/postgres" /tmp/postgres
cd /tmp/postgres

for version in "${versions[@]}"; do
    tags=($(get_tags "postgres" | grep -oP "^(${version/\./\.}\.[0-9]+)(?=\-alpine$)" | sort -rV))
    latest_ver="${tags[0]}"

    cur_ver=$(grep -oP "(?<=POSTGRES_VER=)(${version}\.[0-9]+)" .travis.yml)

    validate_versions "${version}" "${cur_ver}" "${latest_ver}"

    if [[ "${cur_ver}" != "${latest_ver}" ]]; then
        echo "PostgreSQL ${cur_ver} is outdated, updating to ${latest_ver}"
        sed -i -E "s/(POSTGRES_VER)=${cur_ver}/\1=${latest_ver}/" .travis.yml

        # Update Makefiles.
        sed -i -E "s/(POSTGRES_VER \?= )${cur_ver}/\1${latest_ver}/" Makefile

        git_commit ./ "Updating PostgreSQL to ${latest_ver}"
        git push origin
    fi
done
