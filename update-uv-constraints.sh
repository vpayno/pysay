#!/bin/env bash

is_git_dirty() {
	git diff-files --quiet || return 0

	return 1
}

is_git_staged() {
	git diff-index --quiet --cached HEAD -- || return 0

	return 1
}

if is_git_dirty || is_git_staged; then
	printf "ERROR: Please commit or stash your changes before running this script.\n"
	exit 1
fi

# $ uv run tomlq -r ".project.dependencies[]" pyproject.toml
# requests>=2.31.0

# $ uv run tomlq -r '.["dependency-groups"].dev[]' pyproject.toml
# bandit>=1.7.8

declare -a main_deps
mapfile -t main_deps < <(uv run tomlq -r ".project.dependencies[]" pyproject.toml | sed -r -e 's/(^[-_a-zA-Z0-9]*)[>=<]+.*/\1/g' | sort)

declare -a dev_deps
mapfile -t dev_deps < <(uv run tomlq -r '.["dependency-groups"].dev[]' pyproject.toml | sed -r -e 's/(^[-_a-zA-Z0-9]*)[>=<]+.*/\1/g' | sort)

declare freeze_data
freeze_data="$(uv pip freeze)"

declare old_dep
declare new_dep

for old_dep in "${main_deps[@]}"; do
	new_dep="$(grep -E "^${old_dep}[>=<]" <<<"${freeze_data}" | sed -r -e 's/==/>=/g')"

	[[ -z ${new_dep} ]] && continue

	echo uv add "${new_dep}"
	uv add "${new_dep}"
	printf "\n"
done

for old_dep in "${dev_deps[@]}"; do
	new_dep="$(grep -E "^${old_dep}[>=<]" <<<"${freeze_data}" | sed -r -e 's/==/>=/g')"

	[[ -z ${new_dep} ]] && continue

	echo uv add --dev "${new_dep}"
	uv add " --dev ${new_dep}"
	printf "\n"
done

if is_git_dirty; then
	git add pyproject.toml uv.lock
	printf "\n"

	git commit -m "uv: update minimum dependency version constraints"
	printf "\n"

	git show --name-only
	printf "\n"
else
	printf "No updates.\n"
fi
