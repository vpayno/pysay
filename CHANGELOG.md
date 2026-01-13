# Changelog

All notable changes to this project will be documented in this file.

## [0.6.1] - 2026-01-13

### Nix

- *(devshell)* Add doq python docstring generator
- Lock update

### Direnv

- Bump .envrc file to v20251210.0.0

### Devbox

- Add doq python docstring generator
- Lock update

### UV

- Lock update
- Update minimum dependency version constraints

### Documentation

- *(argparse)* Add notes on argparse update

### Miscellaneous Tasks

- *(style)* Use tabs with git files

## [0.6.0] - 2025-11-24

### Nix

- *(docker)* Update ubuntu base docker image digest/sha256
- Lock update

### Devbox

- Lock update

### UV

- Add argparse direct dependency
- Lock update
- Update minimum dependency version constraints

### Other

- Add -V/--version flag
- Add --message flag while preserving original behavior

### Miscellaneous Tasks

- *(lint)* Switch from typing.List to list
- *(lint)* Switch from typing.Union to |

## [0.5.21] - 2025-11-06

### Nix

- Lock update

### Devbox

- Lock update

### UV

- Lock update
- Update minimum dependency version constraints

### Documentation

- *(bundle)* Add notes on how to use nix bundle

## [0.5.20] - 2025-10-18

### Nix

- *(apps/tag-list)* Add script/app for listing latest tags
- Lock update

### Devbox

- Lock update

### UV

- Lock update
- Update minimum dependency version constraints

### Documentation

- Update release notes

## [0.5.19] - 2025-10-18

### Nix

- *(apps/tag-release)* Make sure fallback versions are updated in pyproject.toml

## [0.5.18] - 2025-10-11

### Nix

- *(apps/tag-release)* Add change log to annotated tags

## [0.5.17] - 2025-10-11

### Nix

- Change all pkgs.uv references to uv2nix uv-bin package
- Lock update

### Devbox

- Lock update
- Move hatch deps to pyproject.toml

### Python

- Bump to 3.13

### UV

- Lock update

## [0.5.16] - 2025-10-11

### Miscellaneous Tasks

- Upddate git-cliff config

## [0.5.15] - 2025-10-11

### Nix

- Lock update

### Devbox

- Lock update
- Update config to v0.16.0

### UV

- Lock update
- Update minimum dependency version constraints

## [0.5.14] - 2025-10-11

### Nix

- Start migration to flake-parts - part 1
- Start migration to flake-parts - part 2
- Start migration to flake-parts - part 3
- Start migration to flake-parts - part 4
- Start migration to flake-parts - part 5
- *(apps)* Move tag-release to local flake, fix python revbump

### UV

- Fix project version manually

## [0.5.13] - 2025-10-10

### Nix

- *(style)* Remove recursive attribute sets - missed fixes

### Security

- *(0.5.13)* Rec keyword removal fixes

## [0.5.12] - 2025-10-10

### Nix

- Use the uv2nix uv-bin packge in the flake and devbox shell
- Update flake before devbox since the flake defines packages in devbox
- *(apps)* Fix outdated execution and add audit checks in updateProjectLocks
- *(apps)* Check if lock updates were successful
- Lock update
- Lock update
- Lock update
- Lock update
- Lock update
- Lock update
- Lock update
- *(style)* Remove recursive attribute sets

### Direnv

- Update to 20250925.0.3
- Use current-system from gh:vpayno/nix-misc-tools
- Fix DEP_PATH bin paths

### Devbox

- Lock update
- Lock update
- Lock update
- Lock update
- Lock update
- Run .#updateProjectLocks in update_locks script
- Lock update

### UV

- Lock update
- Update minimum dependency version constraints
- Lock update
- Update minimum dependency version constraints
- Lock update
- Update minimum dependency version constraints
- Lock update
- Update minimum dependency version constraints
- Lock update
- Update minimum dependency version constraints

### Miscellaneous Tasks

- Switch to static versioning

### Security

- *(0.5.12)* Update improvements, lock updates, rec keyword removal, ci fixes, shell fixes

## [0.5.11] - 2025-07-18

### Nix

- *(docker)* Add ubuntu docker image
- Add names to devShells
- Update locks
- Add uv lock update app
- Switch default devShell to impure
- Update updateLocksUV script
- Update locks
- Update locks
- Update locks
- *(devshell)* Experimenting with isolated PATH
- *(docker)* Add dockerImageNixosStreamed and other clean up
- Update locks
- *(docker)* Add devcontainer package
- *(packages)* Use mkApplication to create a single file python application
- *(packages)* Add wheel and sdist outputs (broken)
- Update locks
- Move scripts from packages to scripts attribute set
- *(apps)* Add project lock update script
- Lock update
- Move data to data attribute set

### Direnv

- *(nix)* Setup devShell autoloading
- Add runme play to setup devbox shell use
- Add runme plays for allowing and disallowing direnv use
- Use gum to select between nix develop and devbox shell
- Add runme play for configuring direnv
- Use .#impure instead of .#uv2nix
- Set devbox as the default shell
- .envrc file that automatically populates devshell options
- Fixes/improvements
- Rename abort option to skip
- Update .envrc to v20250524.0.0
- Update .envrc to v20250524.0.0
- Set devbox shell as the default option

### Devbox

- Update locks
- Add cowsay prompt to hook
- Update locks
- Updaet locks
- Update update_locks script
- Add docker-client to shell
- *(scripts)* Fix pip() in shell hook
- Update locks
- Lock update

### Python

- Always use "uv pip" instead of "pip"
- Add lock update task

### UV

- Update locks
- Update locks
- Add tomlq dev dependency
- Update minimum application dependency version constraints
- Update dependency locks
- Update minimum dependency version constraints
- Remove tomlq dev dependency that conflicts with yq
- Add pip-audit dev dependency
- Add poe command for running audit commands
- Fix constraint script bug which added dev deps as prod deps
- Update dependency locks
- Update minimum dependency version constraints
- Lock update
- Update minimum dependency version constraints

### Documentation

- *(security)* Add notes on how to use vulnix
- *(direnv)* Update .envrc menu example
- Add notes on wheel and uv2nix app releases

### Miscellaneous Tasks

- *(style)* Update .editorconfig file
- *(tools)* Add pyproject.toml constraint update script
- *(tools)* Add uv.lock update script
- *(tools)* Add flake lock update script
- *(tools)* Add devbox lock update script
- *(tools)* Fix typo in update-uv-constraints.sh

### Security

- *(0.5.11)* Devshell and lock update

## [0.5.10] - 2025-04-13

### Nix

- Update locks
- Update locks
- *(docker)* Add nixos docker image and commands
- Update locks

## [0.5.9] - 2025-04-04

### Nix

- Add tag-release app from nix-treefmt-conf
- Update locks

### Documentation

- Add note on how to tag a release
- Fix note on source of ascii art

### Miscellaneous Tasks

- Remove release commits from change log

## [0.5.8] - 2025-04-03

### Nix

- Fix pname/version/name usage
- Add hack and git to shells
- Update locks
- Update locks
- Switch default devShell from impure to uv2nix
- Update locks

### Devbox

- Add hatch
- Update scripts

### Python

- Fix vcs version settings
- Update locks
- Fix license declaration for uv2nix
- Update classifiers metadata

## [0.5.7] - 2025-03-18

### Nix

- Fix name/version/pname
- Fix devShells and set default to impure
- Update locks

### Python

- Bump minimum pythoon version to 3.12

## [0.5.6] - 2025-03-16

### Nix

- Update locks

### Miscellaneous Tasks

- Add git-cliff config

## [0.5.5] - 2025-03-15

### Nix

- Add pysay package/app and set it as the default
- Add usage help message app
- Add flake/project version

### Documentation

- Add usage notes

## [0.5.4] - 2025-03-11

### Nix

- Switch formatter to github:vpayno/nix-treefmt-conf
- Update locks

### Miscellaneous Tasks

- Format with nix fmt
- Format files with nix fmt

## [0.5.3] - 2025-03-09

### Devbox

- Python and lock updates

### UV

- Recreate and update lock file

### Other

- Initialize config
- Add python+uv config

## [0.5.2] - 2025-03-09

### Nix

- Add formatter output
- Start working on adding more supported systems
- Fix mainainters, license, packages and apps
- Update locks

### Python

- Fix tool.poe.tasks in pyproject.toml

### Documentation

- Add notes on how to use poethepoet with uv

## [0.5.1] - 2025-02-19

### Python

- Add outdated command
- Add poethepoet tool

### Documentation

- Update uv tool install notes
- Add nix run with version
- Add nix profile with version

## [0.5.0] - 2025-02-18

### Nix

- Add shell.nix and python-packages.nix
- Add flake with uv2nix and devshell

### Devbox

- Add developer shell

### Python

- Add clean commands
- Add ruff lint and format options
- Add format command that uses ruff format
- Update dev dependencies
- Run pdm fix
- Update dependencies
- Switch from pdm to uv

### Documentation

- Reorganize and update top-level readme

### Testing

- Add tests for main and snake modules

### Miscellaneous Tasks

- Update .editorconfig

## [0.4.0] - 2024-01-23

### Bug Fixes

- Pylint consider-using-from-import
- Add missing typing information

### Python

- Add more project urls
- Update "pdm run lint" command
- Add pyright config
- Update "pdm run test" command
- Add documentation commands
- Add ruff config
- Add black config
- Add isort config
- Add mypy command
- Add more testing deps

### Documentation

- Add more project notes
- Add/update docstrings

### Testing

- Add no cover pragmas to main entrypoints

## [0.3.0] - 2024-01-23

### Python

- Fix dynamic versioning
- Fix script entrypoint section name
- Add maintainers list
- Use LICENSE file in pyproject.toml
- Add pypi project keywords

### Miscellaneous Tasks

- Add .editorconfig

## [0.2.0] - 2024-01-23

### Features

- Draw snake and speech bubble

### Python

- Switch to dynamic versioning

## [0.1.0] - 2024-01-23

### Python

- Initialize project using pdm
- Add entry points
- Add rich dependency
- Update project description
- Update project urls

### Other

- Add entrypoints

### Documentation

- Add MIT license
- Add top-level readme

<!-- generated by git-cliff -->
