{
  description = "Like cowsay but with a python";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.uv2nix.follows = "uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-conf = {
      url = "github:vpayno/nix-treefmt-conf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-conf = {
      url = "github:vpayno/neovim-nix-nvf-conf";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-parts,
      pyproject-nix,
      uv2nix,
      pyproject-build-systems,
      treefmt-conf,
      ...
    }@inputs:

    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
      ];

      imports = [
      ];

      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        let
          pname = "pysay";
          version = "0.5.18";
          name = "${pname}-${version}";

          # system = "x86_64-linux";
          arch = pkgs.lib.trim (builtins.toString (builtins.split "-linux$" system));

          inherit (nixpkgs) lib;

          inherit (pkgs.callPackages pyproject-nix.build.util { }) mkApplication;

          # we need to make sure we're always using the same uv version as uv2nix
          uv-bin = uv2nix.outputs.packages.${system}.uv-bin;

          nixpkgsOverlay = self: super: {
            uv-upstream = super.uv;
            uv = uv-bin;
          };

          # Load a uv workspace from a workspace root.
          # Uv2nix treats all uv projects as workspace projects.
          workspace = uv2nix.lib.workspace.loadWorkspace { workspaceRoot = ./.; };

          # Create package overlay from workspace.
          overlay = workspace.mkPyprojectOverlay {
            # Prefer prebuilt binary wheels as a package source.
            # Sdists are less likely to "just work" because of the metadata missing from uv.lock.
            # Binary wheels are more likely to, but may still require overrides for library dependencies.
            sourcePreference = "wheel"; # or sourcePreference = "sdist";
            # Optionally customise PEP 508 environment
            # environ = {
            #   platform_release = "5.10.65";
            # };
          };

          # Extend generated overlay with build fixups
          #
          # Uv2nix can only work with what it has, and uv.lock is missing essential metadata to perform some builds.
          # This is an additional overlay implementing build fixups.
          # See:
          # - https://pyproject-nix.github.io/uv2nix/FAQ.html
          pyprojectOverrides = _final: _prev: {
            # Implement build fixups here.
            # Note that uv2nix is _not_ using Nixpkgs buildPythonPackage.
            # It's using https://pyproject-nix.github.io/pyproject.nix/build.html
          };

          # pkgs = nixpkgs.legacyPackages.${system};
          pkgs = import nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
            };
            overlay = [
              nixpkgsOverlay
            ];
          };

          # Use Python 3.13 from nixpkgs
          python = pkgs.python313;

          # Construct package set
          pythonSet =
            # Use base package set from pyproject.nix builders
            (pkgs.callPackage pyproject-nix.build.packages {
              inherit python;
            }).overrideScope
              (
                lib.composeManyExtensions [
                  pyproject-build-systems.overlays.default
                  overlay
                  pyprojectOverrides
                ]
              );

          metadata = {
            homepage = "https://github.com/vpayno/pysay";
            description = "Like cowsay but with a python";
            license = with pkgs.lib.licenses; [ mit ];
            # maintainers = with pkgs.lib.maintainers; [vpayno];
            maintainers = {
              email = "vpayno@users.noreply.github.com";
              github = "vpayno";
              githubId = 3181575;
              name = "Victor Payno";
            };
            mainProgram = "pysay";
            inherit version;
          };

          data = {
            usageMessage = ''
              Available ${name} flake commands:

                nix run .#usage
                nix run .#tag-release v1.2.3 'release notes'

                nix run . -- "message"
                  nix run .#default -- "message"
                  nix run .#pysay -- "message"

                nix run .#dive
                nix run .#dockerCiCheck
                nix run .#dockerRun -- "message"

                nix profile install github:vpayno/pysay
            '';

            diveCiConfigFile = pkgs.writeText ".dive-ci.yaml" ''
              ---
              rules:
                # If the efficiency is measured below X%, mark as failed.
                # Expressed as a ratio between 0-1.
                lowestEfficiency: 0.95

                # If the amount of wasted space is at least X or larger than X, mark as failed.
                # Expressed in B, KB, MB, and GB.
                highestWastedBytes: 20MB

                # If the amount of wasted space makes up for X% or more of the image, mark as failed.
                # Note: the base image layer is NOT included in the total image size.
                # Expressed as a ratio between 0-1; fails if the threshold is met or crossed.
                highestUserWastedPercent: 0.20
            '';

            diveUiConfigFile = pkgs.writeText ".dive-ui.yaml" ''
              ---
              # supported options are "docker" and "podman"
              container-engine: docker
              # continue with analysis even if there are errors parsing the image archive
              ignore-errors: false
              log:
                enabled: true
                path: ./dive.log
                level: info

              # Note: you can specify multiple bindings by separating values with a comma.
              # Note: UI hinting is derived from the first binding
              keybinding:
                # Global bindings
                quit: ctrl+c
                toggle-view: tab
                filter-files: ctrl+f, ctrl+slash
                close-filter-files: esc
                up: up,k
                down: down,j
                left: left,h
                right: right,l

                # Layer view specific bindings
                compare-all: ctrl+a
                compare-layer: ctrl+l

                # File view specific bindings
                toggle-collapse-dir: space
                toggle-collapse-all-dir: ctrl+space
                toggle-added-files: ctrl+a
                toggle-removed-files: ctrl+r
                toggle-modified-files: ctrl+m
                toggle-unmodified-files: ctrl+u
                toggle-filetree-attributes: ctrl+b
                page-up: pgup,u
                page-down: pgdn,d

              diff:
                # You can change the default files shown in the filetree (right pane). All diff types are shown by default.
                hide:
                  # - added
                  # - removed
                  # - modified
                  - unmodified

              filetree:
                # The default directory-collapse state
                collapse-dir: false

                # The percentage of screen width the filetree should take on the screen (must be >0 and <1)
                pane-width: 0.5

                # Show the file attributes next to the filetree
                show-attributes: true

              layer:
                # Enable showing all changes from this layer and every previous layer
                show-aggregated-changes: false
            '';
          };

          scripts = {
            showUsage = pkgs.writeShellScriptBin "showUsage" ''
              printf "%s" "${data.usageMessage}"
            '';

            showVersion = pkgs.writeShellScriptBin "showVersion" ''
              printf "%s version: %s\n" "${pname}" "${version}"
            '';

            updateUvConstraints = pkgs.writeShellApplication {
              name = "update-uv-constraints";

              runtimeInputs =
                with pkgs;
                [
                  coreutils
                  gnused
                ]
                ++ [
                  self'.packages.uv
                ];

              text = ''
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

                printf "INFO: Updating pyproject.toml dependancy constraints.\n"
                printf "\n"

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

                for old_dep in "''${main_deps[@]}"; do
                  new_dep="$(grep -E "^''${old_dep}[>=<]" <<<"''${freeze_data}" | sed -r -e 's/==/>=/g')"

                  [[ -z ''${new_dep} ]] && continue

                  echo uv add "''${new_dep}"
                  uv add "''${new_dep}"
                  printf "\n"
                done

                for old_dep in "''${dev_deps[@]}"; do
                  new_dep="$(grep -E "^''${old_dep}[>=<]" <<<"''${freeze_data}" | sed -r -e 's/==/>=/g')"

                  [[ -z ''${new_dep} ]] && continue

                  echo uv add --dev "''${new_dep}"
                  uv add --dev "''${new_dep}"
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
              '';
            };

            updateProjectLocks = pkgs.writeShellApplication {
              name = "update-project-locks";

              runtimeInputs =
                with pkgs;
                [
                  coreutils
                  devbox
                ]
                ++ (with scripts; [
                  updateUvConstraints
                ])
                ++ [
                  self'.packages.uv
                ];

              text = ''
                is_git_clean() {
                  local -i retval=0

                  if ! git diff-files --quiet; then
                    (( retval += 1 ))
                  fi

                  if ! git diff-index --quiet --cached HEAD --; then
                    (( retval +=1 ))
                  fi

                  return ''${retval}
                }

                if ! is_git_clean; then
                  printf "ERROR: Please commit or stash your changes before running this script.\n"
                  exit 1
                fi

                printf "INFO: Checking for outdated python packages before lock update...\n"
                uv run poe outdated || true
                printf "\n"

                printf "INFO: Checking for python package CVEs before lock update...\n"
                uv run poe audit || true
                printf "\n"

                printf "INFO: Updating nix flake locks...\n"
                nix flake update
                if ! git diff --quiet ./flake.lock; then # command fails when file is dirty
                  git add ./flake.lock
                  git commit -m 'nix: lock update'
                else
                  printf "WARN: no nix flake updates found.\n"
                fi
                printf "\n"

                if [[ -f devbox.json ]]; then
                  printf "INFO: Updating devbox locks...\n"
                  devbox update
                  if ! git diff --quiet ./devbox.lock; then # command fails when file is dirty
                    git add ./devbox.lock
                    git commit -m 'devbox: lock update'
                  else
                    printf "WARN: no devbox updates found.\n"
                  fi
                  printf "\n"
                fi

                printf "INFO: Updating UV locks...\n"
                uv lock --upgrade
                if ! git diff --quiet ./uv.lock; then # command fails when file is dirty
                  git add ./uv.lock
                  git commit -m 'uv: lock update'
                else
                  printf "WARN: no UV updates found.\n"
                fi
                printf "\n"

                update-uv-constraints
                printf "\n"

                printf "INFO: Checking for outdated python packages after lock update...\n"
                uv run poe outdated || true
                printf "\n"

                printf "INFO: Checking for python package CVEs after lock update...\n"
                uv run poe audit || true
                printf "\n"
              '';
            };

            dockerCiCheck = pkgs.writeShellScriptBin "dockerCiCheck" ''
              printf "%s version: %s\n" "docker" "$("${pkgs.docker}/bin/docker" --version)"
              printf "%s version: %s\n" "dive" "$("${pkgs.lib.getExe pkgs.dive}" --version)"
              printf "\n"

              if [[ -S /run/docker.sock ]]; then
                export DOCKER_HOST="unix:///run/docker.sock"
                printf "DOCKER_HOST=\"%s\"\n" "$DOCKER_HOST"
                printf "\n"
              fi

              printf "Using CI config file: %s\n" "${data.diveCiConfigFile}"
              cat "${data.diveCiConfigFile}"
              printf "\n"

              image_file="${self'.packages.dockerImageNixos}"

              printf "Image file: %s\n" "$image_file"
              printf "\n"

              printf "Inspecting Image:\n"
              "${pkgs.lib.getExe pkgs.skopeo}" inspect docker-archive:"$image_file" | "${pkgs.lib.getExe pkgs.jq}" . | "${pkgs.coreutils}/bin/head" -n 15
              printf "\n"

              "${pkgs.lib.getExe pkgs.docker-client}" load < "$image_file"
              printf "\n"

              "${pkgs.lib.getExe pkgs.dive}" docker-image-nixos-pysay:${version} --ci --ci-config="${data.diveCiConfigFile}"
            '';

            dive = pkgs.writeShellScriptBin "dive" ''
              if [[ -S /run/docker.sock ]]; then
                export DOCKER_HOST="unix:///run/docker.sock"
                printf "DOCKER_HOST=\"%s\"\n" "$DOCKER_HOST"
                printf "\n"
              fi

              printf "Using UI config file: %s\n" "${data.diveUiConfigFile}"
              printf "\n"

              image_file="${self'.packages.dockerImageNixos}"

              printf "Image file: %s\n" "$image_file"
              printf "\n"

              printf "Inspecting Image:\n"
              "${pkgs.lib.getExe pkgs.skopeo}" inspect docker-archive:"$image_file" | "${pkgs.lib.getExe pkgs.jq}" . | "${pkgs.coreutils}/bin/head" -n 15
              printf "\n"

              "${pkgs.lib.getExe pkgs.docker-client}" load < "$image_file"
              printf "\n"

              "${pkgs.lib.getExe pkgs.dive}" --config="${data.diveUiConfigFile}" ''${@:-docker-image-nixos-pysay:${version}}
            '';

            dockerRun = pkgs.writeShellScriptBin "dockerRun" ''
              if [[ -S /run/docker.sock ]]; then
                export DOCKER_HOST="unix:///run/docker.sock"
                printf "DOCKER_HOST=\"%s\"\n" "$DOCKER_HOST"
                printf "\n"
              fi

              image_file="${self'.packages.dockerImageNixos}"

              printf "Image file: %s\n" "$image_file"
              printf "\n"

              printf "Inspecting Image:\n"
              "${pkgs.lib.getExe pkgs.skopeo}" inspect docker-archive:"$image_file" | "${pkgs.lib.getExe pkgs.jq}" . | "${pkgs.coreutils}/bin/head" -n 15
              printf "\n"

              "${pkgs.lib.getExe pkgs.docker-client}" load < "$image_file"
              printf "\n"

              "${pkgs.lib.getExe pkgs.docker-client}" image ls "docker-image-nixos-${pname}:${version}"

              "${pkgs.lib.getExe pkgs.docker-client}" run --rm -it "docker-image-nixos-${pname}:${version}" "''${@}"
            '';

            tag-release = pkgs.writeShellApplication {
              name = "tag-release";
              runtimeInputs =
                with pkgs;
                [
                  coreutils
                  git
                  git-cliff
                  gnugrep
                  gnused
                  gum
                ]
                ++ [
                  self'.packages.uv
                ];
              text = ''
                declare current_branch
                current_branch="$(git branch --show-current)"

                if [[ $current_branch != main ]]; then
                  printf "\n"
                  printf "ERROR: you must be on the main branch before running this script.\n"
                  printf "\n"
                  exit 1
                fi

                if ! git diff-index --quiet HEAD; then
                  printf "\n"
                  printf "ERROR: git repo is dirty, commit or stash all of your changes before running this script.\n"
                  printf "\n"
                  exit 1
                fi

                # the double single quotes escape the $ so we can use it as a bash variable instead of a nix variable
                declare version="''${1:-}"
                declare note="''${2:-}"

                if [[ -z $version ]] || [[ -z $note ]]; then
                  printf "\n"
                  printf "Usage: nix run .#tag-release -- %s \"%s\"\n" 1.2.3 "fixed blah blah"
                  printf "\n"
                  exit 1
                fi

                if [[ ! $version =~ ^[0-9]+[.][0-9]+[.][0-9]+$ ]]; then
                  printf "\n"
                  printf "ERROR: version string \"%s\" doesn't match the format \"^[0-9]+[.][0-9]+[.][0-9]+$\"\n" "$version"
                  printf "\n"
                  exit 1
                fi

                if git tag | grep -q -E "^$version$"; then
                  printf "\n"
                  printf "ERROR: tag %s already exists in the local checkout.\n" "$version"
                  printf "\n"
                  git show "$version"
                  printf "\n"
                  exit 1
                fi

                if git ls-remote --exit-code --tags --quiet origin | grep -q -E "refs/tags/$version$"; then
                  printf "\n"
                  printf "ERROR: tag %s already exists on the remote.\n" "$version"
                  printf "\n"
                  git show origin "$version"
                  printf "\n"
                  exit 1
                fi

                declare last_version
                last_version="$(git tag --list -n0 | sed -e 's/^v//g' | sort -V | tail -n 1)"

                printf "\n"
                printf " Tag: %s\n" "$version"
                printf "Note: %s\n" "$note"
                printf "\n"

                # flake.nix:        version = "v0.1.5";
                # flake.nix:        version = "0.1.5";
                sed -r -i -e "s/^( +version = \")v?[0-9]+.[0-9]+.[0-9]+(\")/\1$version\2/g" ./flake.nix
                printf "\n"

                git add ./flake.nix
                printf "\n"

                if [[ -f ./pyproject.toml ]]; then
                  # pyproject.toml:version = "v0.5.11"
                  # pyproject.toml:version = "0.5.11"
                  sed -r -i -e "s/^(version = \")v?[0-9]+.[0-9]+.[0-9]+(\")/\1$version\2/g" ./pyproject.toml
                  sed -r -i -e "s/^(fallback[-_]version = \")v?[0-9]+.[0-9]+.[0-9]+(\")/\1$version\2/g" ./pyproject.toml
                  printf "\n"

                  uv lock
                  printf "\n"

                  uv version
                  printf "\n"

                  git add ./pyproject.toml ./uv.lock
                  printf "\n"
                fi

                git-cliff --tag="$version" --output=CHANGELOG.md
                git add ./CHANGELOG.md
                printf "\n"

                git commit -m "release($version): $note

                $(git-cliff "$last_version".. --tag "$version")
                "
                printf "\n"

                git tag -a -m "release($version): $note

                $(git-cliff "$last_version".. --tag "$version")
                " "$version"
                printf "\n"

                git show "$version"
                printf "\n"

                if gum confirm "Push tag $version?"; then
                  git push origin main
                  printf "\n"
                  git push origin tag "$version"
                  printf "\n"
                else
                  printf "\n"
                  printf "Run \"%s\" to push commits and tags.\n" "git push --follow-tags"
                  printf "\n"
                fi
              '';
            };
          };
        in
        {
          formatter = treefmt-conf.formatter.${system};

          # Package a virtual environment as our main application.
          #
          # Enable no optional dependencies for production build.
          packages = {
            uv = uv-bin; # provide the uv version the flake uses to devbox

            default = self'.packages.pysayApp;

            pysay = pythonSet.mkVirtualEnv "${pname}-prod-env-${version}" workspace.deps.default // {
              inherit pname;
              inherit version;
              inherit name;
              meta = metadata;
            };

            pysayApp = mkApplication {
              inherit pname;
              inherit version;
              venv = self'.packages.pysay;
              package = pythonSet.pysay;
            };

            pysayWheel = pythonSet.pysay.override {
              pyprojectHook = pythonSet.pyprojectDistHook;
            };

            pysaySdist =
              (pythonSet.pysay.override {
                pyprojectHook = pythonSet.pyprojectDistHook;
              }).overrideAttrs
                (oldAttrs: {
                  env.uvBuildType = "sdist";
                });

            dockerImageNixos = self'.packages.dockerImageNixosBuild;

            dockerImageNixosBuild = pkgs.dockerTools.buildLayeredImage {
              name = "docker-image-nixos-${pname}";
              tag = "${version}";
              created = "now";
              maxLayers = 100; # max is 125

              # doesn't have access to most of the layer contents, this creates the top-most layer
              extraCommands = ''
                : do stuff
              '';

              # can be used for installation scripts that need an LFS in /
              enableFakechroot = true;

              # has access to all the layer contents, files owned by root, can be changed
              fakeRootCommands = ''
                : do stuff
              '';

              contents = [
                self'.packages.pysay
              ];

              config =
                let
                  entrypoint = "${self'.packages.default}/bin/pysay";
                in
                {
                  # startup executable
                  Entrypoint = [
                    "${entrypoint}"
                  ];
                  # arguments for entrypoint
                  Cmd = [
                    "Hello From NixOS+Docker!"
                  ];

                  Env = [
                    "ENTRYPOINT=${entrypoint}"
                  ];
                };
            };

            dockerImageNixosStreamed = pkgs.dockerTools.streamLayeredImage {
              name = "docker-image-nixos-${pname}-streamelayeredimage";

              # git rev-parse HEAD
              tag = self.rev or "dev";

              # leaves room to append
              maxLayers = 100; # max is 125

              config = {
                Entrypoint = [
                  "${pkgs.lib.getExe self'.packages.default}"
                ];

                # adds glibLocales and sets LOCALE_ARCHIVE
                Env = [
                  "LANG=C.UTF-8"
                ];
              };
            };

            dockerImageUbuntu = pkgs.dockerTools.buildLayeredImage {
              name = "docker-image-ubuntu-${pname}";
              tag = "${version}";
              created = "now";
              maxLayers = 100; # max is 125

              fromImage = pkgs.dockerTools.pullImage {
                imageName = "ubuntu";
                finalImageTag = "24.04";
                imageDigest = "sha256:1e622c5f073b4f6bfad6632f2616c7f59ef256e96fe78bf6a595d1dc4376ac02";
                sha256 = "sha256-UhZaL7KJLeTDzbkfgKawAHEoQ6JtwLrV4OG0GHfpRMg=";
                os = "linux";
                arch = "${arch}";
              };

              # doesn't have access to most of the layer contents, this creates the top-most layer
              extraCommands = ''
                : do stuff
              '';

              # can be used for installation scripts that need an LFS in /
              enableFakechroot = true;

              # has access to all the layer contents, files owned by root, can be changed
              # last layer
              # apt is missing from the image
              fakeRootCommands = ''
                # the ubuntu image forces looking for executables in /usr/bin which doesn't exist
                ls /
                mkdir -v /usr
                ln -sv /bin /usr/bin
              '';

              contents = [
                pkgs.neofetch # needs coreutils
                pkgs.coreutils
                self'.packages.pysay
              ];

              config =
                let
                  entrypoint = "${self'.packages.default}/bin/pysay";
                in
                {
                  # startup executable
                  Entrypoint = [
                    "${entrypoint}"
                  ];
                  # arguments for entrypoint
                  Cmd = [
                    "Hello From Nix+Ubuntu+Docker!"
                  ];

                  Env = [
                    "ENTRYPOINT=${entrypoint}"
                  ];
                };
            };

            devcontainer = pkgs.dockerTools.buildNixShellImage {
              name = "devcontainer-nixshell-${pname}";
              tag = "${version}-${arch}";

              drv = self'.devShells.uv2nix.overrideAttrs (oldAttrs: {
                packages = oldAttrs.packages or [ ] ++ [
                  inputs.nvim-conf.packages.${system}.default # lol, adds 10GB
                ];
              });
            };
          };

          # Make pysay runnable with `nix run`
          apps = {
            default = self'.apps.pysay;

            pysay = {
              type = "app";
              program = "${self'.packages.default}/bin/pysay";
              meta = pkgs.lib.attrsets.recursiveUpdate metadata {
                inherit pname;
                inherit name;
                inherit version;
              };
            };

            usage = {
              type = "app";
              program = "${pkgs.lib.getExe scripts.showUsage}";
              meta = pkgs.lib.attrsets.recursiveUpdate metadata {
                description = "Script that shows the flake usage message";
                pname = "usage";
                name = "${self'.apps.usage.meta.pname}-${version}";
                inherit version;
              };
            };

            version = {
              type = "app";
              program = "${pkgs.lib.getExe scripts.showVersion}";
              meta = pkgs.lib.attrsets.recursiveUpdate metadata {
                description = "Script that shows the flake version message";
                pname = "showVersion";
                name = "${self'.apps.version.meta.pname}-${version}";
                inherit version;
              };
            };

            updateProjectLocks = {
              type = "app";
              program = "${pkgs.lib.getExe scripts.updateProjectLocks}";
              meta = pkgs.lib.attrsets.recursiveUpdate metadata {
                description = "Script that updates all the project locks in the correct order";
                pname = "updateProjectLocks";
                name = "${self'.apps.updateProjectLocks.meta.pname}-${version}";
                inherit version;
              };
            };

            tag-release = {
              type = "app";
              program = "${pkgs.lib.getExe scripts.tag-release}";
              meta = pkgs.lib.attrsets.recursiveUpdate metadata {
                description = "Script that tags/releases the Python project";
                pname = "tag-release";
                name = "${self'.apps.tag-release.meta.pname}-${version}";
                inherit version;
              };
            };

            dockerCiCheck = {
              type = "app";
              program = "${pkgs.lib.getExe scripts.dockerCiCheck}";
              meta = pkgs.lib.attrsets.recursiveUpdate metadata {
                description = "Docker CI Job";
                pname = "dockerCiCheck";
                name = "${self'.apps.dockerCiCheck.meta.pname}-${version}";
                inherit version;
              };
            };

            dive = {
              type = "app";
              program = "${pkgs.lib.getExe scripts.dive}";
              meta = pkgs.lib.attrsets.recursiveUpdate metadata {
                description = pkgs.dive.meta.description + " (wrapper)";
                inherit (pkgs.dive) pname;
                inherit (pkgs.dive) name;
                inherit (pkgs.dive) version;
              };
            };

            dockerRun = {
              type = "app";
              program = "${pkgs.lib.getExe scripts.dockerRun}";
              meta = pkgs.lib.attrsets.recursiveUpdate metadata {
                description = "Run pysay using a docker container";
                pname = "dockerRun";
                name = "${self'.apps.dockerRun.meta.pname}-${version}";
                inherit version;
              };
            };
          };

          # This example provides two different modes of development:
          # - Impurely using uv to manage virtual environments
          # - Pure development using uv2nix to manage virtual environments
          devShells = {
            default = self'.devShells.impure; # don't use uv2nix as a "traditional" development environment

            # It is of course perfectly OK to keep using an impure virtualenv workflow and only use uv2nix to build packages.
            # This devShell simply adds Python and undoes the dependency leakage done by Nixpkgs Python infrastructure.
            impure = pkgs.mkShell {
              name = "devShells.${system}.impure";
              # becomes nativeBuildInputs
              packages = [
                python
                self'.packages.uv
                pkgs.hatch
                pkgs.git
                pkgs.bashInteractive
              ];
              env = {
                # Prevent uv from managing Python downloads
                UV_PYTHON_DOWNLOADS = "never";

                # Force uv to use nixpkgs Python interpreter
                UV_PYTHON = python.interpreter;
              }
              // lib.optionalAttrs pkgs.stdenv.isLinux {
                # Python libraries often load native shared objects using dlopen(3).
                # Setting LD_LIBRARY_PATH makes the dynamic library loader aware of libraries without using RPATH for lookup.
                # LD_LIBRARY_PATH = lib.makeLibraryPath pkgs.pythonManylinuxPackages.manylinux1;
              };
              shellHook = ''
                export PATH="$PATH:${
                  pkgs.lib.makeBinPath (
                    self'.devShells.impure.nativeBuildInputs
                    ++ (with pkgs; [
                      binutils
                      coreutils-full
                      gawk
                      gnugrep
                      gnused
                      less
                      moreutils
                      nix
                      openssh
                      which
                    ])
                  )
                }"
                unset PYTHONPATH

                ${pkgs.lib.getExe pkgs.cowsay} "Welcome to ${name}'s ${self'.devShells.impure.name} devShell!"
                printf "\n"
                which python uv
                printf "\n"

                printf "Commands:\n"
                printf "\tRun pysay: %s\n" "uv run pysay"
                printf "\tUpdate Nix Locks: %s\n" "nix lock update"
                printf "\tUpdate UV Locks: %s\n" "uv lock --upgrade"
                printf "\tReload shell: %s\n" "direnv reload"
                printf "\n"
              '';
            };

            # This devShell uses uv2nix to construct a virtual environment purely from Nix, using the same dependency specification as the application.
            # The notable difference is that we also apply another overlay here enabling editable mode ( https://setuptools.pypa.io/en/latest/userguide/development_mode.html ).
            #
            # This means that any changes done to your local files do not require a rebuild.
            #
            # Note: Editable package support is still unstable and subject to change.
            uv2nix =
              let
                # Create an overlay enabling editable mode for all local dependencies.
                editableOverlay = workspace.mkEditablePyprojectOverlay {
                  # Use environment variable
                  root = "$REPO_ROOT";
                  # Optional: Only enable editable for these packages
                  members = [ "pysay" ];
                };

                # Override previous set with our overrideable overlay.
                editablePythonSet = pythonSet.overrideScope (
                  lib.composeManyExtensions [
                    editableOverlay

                    # Apply fixups for building an editable package of your workspace packages
                    (final: prev: {
                      pysay = prev.pysay.overrideAttrs (old: {
                        # It's a good idea to filter the sources going into an editable build
                        # so the editable package doesn't have to be rebuilt on every change.
                        src = lib.fileset.toSource {
                          root = old.src;
                          fileset = lib.fileset.unions [
                            (old.src + "/pyproject.toml")
                            (old.src + "/README.md")
                            (old.src + "/src/pysay/__init__.py")
                          ];
                        };

                        # Hatchling (our build system) has a dependency on the `editables` package when building editables.
                        #
                        # In normal Python flows this dependency is dynamically handled, and doesn't need to be explicitly declared.
                        # This behaviour is documented in PEP-660.
                        #
                        # With Nix the dependency needs to be explicitly declared.
                        nativeBuildInputs =
                          old.nativeBuildInputs
                          ++ final.resolveBuildSystem {
                            editables = [ ];
                          };
                      });
                    })
                  ]
                );

                # Build virtual environment, with local packages being editable.
                #
                # Enable all optional dependencies for development.
                virtualenv = editablePythonSet.mkVirtualEnv "${pname}-dev-env-${version}" workspace.deps.all;
              in
              pkgs.mkShell {
                name = "devShells.${system}.uv2nix";

                packages = [
                  virtualenv
                  self'.packages.uv
                  pkgs.hatch
                  pkgs.git
                  pkgs.bashInteractive
                ];

                env = {
                  # Don't create venv using uv
                  UV_NO_SYNC = "1";

                  # Force uv to use Python interpreter from venv
                  UV_PYTHON = "${virtualenv}/bin/python";

                  # Prevent uv from downloading managed Python's
                  UV_PYTHON_DOWNLOADS = "never";
                };

                shellHook = ''
                  # Undo dependency propagation by nixpkgs.
                  unset PYTHONPATH

                  # Get repository root using git. This is expanded at runtime by the editable `.pth` machinery.
                  export REPO_ROOT=$(git rev-parse --show-toplevel)

                  ${pkgs.lib.getExe pkgs.cowsay} "Welcome to ${name}'s ${self'.devShells.uv2nix.name} devShell!"
                  printf "\n"
                '';
              };
          };
        };

      # old legacy flake (migrate to modules and perSystem)
      # also for nixosConfiguration, darwinConfigurations, etc
      flake = {
      };
    };
}
