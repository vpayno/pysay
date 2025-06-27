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

uv run poe outdated
printf "\n"

uv lock --upgrade
printf "\n"

if ! is_git_dirty; then
	printf "No updates.\n"
	exit
fi

uv sync
printf "\n"

uv run poe outdated
printf "\n"

if is_git_dirty; then
	git add pyproject.toml uv.lock
	printf "\n"

	git commit -m "uv: update dependency locks"
	printf "\n"

	git show --name-only
	printf "\n"
else
	printf "No updates.\n"
fi
