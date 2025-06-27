#!/bin/env bash

is_git_dirty() {
	git diff --quiet --shortstat 2>/dev/null || return 0
	return 1
}

if is_git_dirty; then
	printf "ERROR: Please commit or stash your changes before running this script.\n"
	exit 1
fi

uv run poe test || exit
printf "\n"

nix flake update
printf "\n"

if ! is_git_dirty; then
	printf "No updates.\n"
	exit
fi

uv run poe test || exit
printf "\n"

if is_git_dirty; then
	git add flake.lock
	printf "\n"

	git commit -m "nix: update locks"
	printf "\n"

	git show --name-only
	printf "\n"
else
	printf "No updates.\n"
fi
