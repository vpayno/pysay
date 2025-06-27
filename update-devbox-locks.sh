#!/bin/env bash

is_git_dirty() {
	git diff --quiet --shortstat 2>/dev/null || return 0
	return 1
}

if is_git_dirty; then
	printf "ERROR: Please commit or stash your changes before running this script.\n"
	exit 1
fi

devbox update
printf "\n"

if is_git_dirty; then
	git add devbox.lock
	printf "\n"

	git commit -m "devbox: update locks"
	printf "\n"

	git show --name-only
	printf "\n"
else
	printf "No updates.\n"
fi
