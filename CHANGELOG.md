# Changelog

All notable changes to this project will be documented in this file.

## [0.5.14] - 2025-10-11

### Nix

- Start migration to flake-parts - part 1
- Start migration to flake-parts - part 2
- Start migration to flake-parts - part 3
- Start migration to flake-parts - part 4
- Start migration to flake-parts - part 5
- *(apps)* Move tag-release to local flake, fix python revbump

### Other

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

### Other

- Lock update
- Lock update
- Update minimum dependency version constraints
- Lock update
- Lock update
- Lock update
- Update minimum dependency version constraints
- Lock update
- Lock update
- Update minimum dependency version constraints
- Lock update
- Lock update
- Update minimum dependency version constraints
- Update to 20250925.0.3
- Run .#updateProjectLocks in update_locks script
- Lock update
- Lock update
- Update minimum dependency version constraints
- Use current-system from gh:vpayno/nix-misc-tools
- Fix DEP_PATH bin paths

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

### Other

- *(nix)* Setup devShell autoloading
- Add runme play to setup devbox shell use
- Add runme plays for allowing and disallowing direnv use
- Use gum to select between nix develop and devbox shell
- Add runme play for configuring direnv
- Update locks
- Update locks
- Add cowsay prompt to hook
- Use .#impure instead of .#uv2nix
- Always use "uv pip" instead of "pip"
- Add lock update task
- Set devbox as the default shell
- Update locks
- .envrc file that automatically populates devshell options
- Fixes/improvements
- Rename abort option to skip
- Update .envrc to v20250524.0.0
- Update locks
- Update .envrc to v20250524.0.0
- Set devbox shell as the default option
- Updaet locks
- Add tomlq dev dependency
- Update minimum application dependency version constraints
- Update dependency locks
- Update minimum dependency version constraints
- Update update_locks script
- Remove tomlq dev dependency that conflicts with yq
- Add docker-client to shell
- Add pip-audit dev dependency
- Add poe command for running audit commands
- Fix constraint script bug which added dev deps as prod deps
- *(scripts)* Fix pip() in shell hook
- Update locks
- Update dependency locks
- Update minimum dependency version constraints
- Lock update
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

### Other

- Add hatch
- Fix vcs version settings
- Update locks
- Update scripts
- Fix license declaration for uv2nix
- Update classifiers metadata

## [0.5.7] - 2025-03-18

### Nix

- Fix name/version/pname
- Fix devShells and set default to impure
- Update locks

### Other

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

### Other

- Initialize config
- Recreate and update lock file
- Add python+uv config
- Python and lock updates

## [0.5.2] - 2025-03-09

### Nix

- Add formatter output
- Start working on adding more supported systems
- Fix mainainters, license, packages and apps
- Update locks

### Other

- Fix tool.poe.tasks in pyproject.toml

### Documentation

- Add notes on how to use poethepoet with uv

## [0.5.1] - 2025-02-19

### Other

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

### Other

- Add clean commands
- Add ruff lint and format options
- Add format command that uses ruff format
- Update dev dependencies
- Run pdm fix
- Update dependencies
- Add developer shell
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

### Other

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

### Other

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

### Other

- Switch to dynamic versioning

## [0.1.0] - 2024-01-23

### Other

- Initialize project using pdm
- Add entry points
- Add rich dependency
- Add entrypoints
- Update project description
- Update project urls

### Documentation

- Add MIT license
- Add top-level readme

<!-- generated by git-cliff -->
