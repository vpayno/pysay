{
  description = "Like cowsay but with a python";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

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
  };

  outputs =
    {
      self,
      nixpkgs,
      pyproject-nix,
      uv2nix,
      pyproject-build-systems,
      treefmt-conf,
      ...
    }:
    let
      pname = "pysay";
      version = "0.5.10";
      name = "${pname}-${version}";

      system = "x86_64-linux";

      inherit (nixpkgs) lib;

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

      pkgs = nixpkgs.legacyPackages.${system};

      # Use Python 3.12 from nixpkgs
      python = pkgs.python312;

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
      };

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
    in
    rec {
      formatter.${system} = treefmt-conf.formatter.${system};

      # Package a virtual environment as our main application.
      #
      # Enable no optional dependencies for production build.
      packages.${system} = rec {
        pysay = pythonSet.mkVirtualEnv "${pname}-prod-env-${version}" workspace.deps.default // {
          inherit pname;
          inherit version;
          inherit name;
          meta = metadata;
        };
        default = pysay;

        showUsage = pkgs.writeShellScriptBin "showUsage" ''
          printf "%s" "${usageMessage}"
        '';

        showVersion = pkgs.writeShellScriptBin "showVersion" ''
          printf "%s version: %s\n" "${pname}" "${version}"
        '';

        dockerCiCheck = pkgs.writeShellScriptBin "dockerCiCheck" ''
          printf "%s version: %s\n" "docker" "$("${pkgs.docker}/bin/docker" --version)"
          printf "%s version: %s\n" "dive" "$("${pkgs.lib.getExe pkgs.dive}" --version)"
          printf "\n"

          if [[ -S /run/docker.sock ]]; then
            export DOCKER_HOST="unix:///run/docker.sock"
            printf "DOCKER_HOST=\"%s\"\n" "$DOCKER_HOST"
            printf "\n"
          fi

          printf "Using CI config file: %s\n" "${diveCiConfigFile}"
          cat "${diveCiConfigFile}"
          printf "\n"

          image_file="${self.packages.x86_64-linux.dockerImageNixos}"

          printf "Image file: %s\n" "$image_file"
          printf "\n"

          printf "Inspecting Image:\n"
          "${pkgs.lib.getExe pkgs.skopeo}" inspect docker-archive:"$image_file" | "${pkgs.lib.getExe pkgs.jq}" . | "${pkgs.coreutils}/bin/head" -n 15
          printf "\n"

          "${pkgs.lib.getExe pkgs.docker-client}" load < "$image_file"
          printf "\n"

          "${pkgs.lib.getExe pkgs.dive}" docker-image-nixos-pysay:${version} --ci --ci-config="${diveCiConfigFile}"
        '';

        dive = pkgs.writeShellScriptBin "dive" ''
          if [[ -S /run/docker.sock ]]; then
            export DOCKER_HOST="unix:///run/docker.sock"
            printf "DOCKER_HOST=\"%s\"\n" "$DOCKER_HOST"
            printf "\n"
          fi

          printf "Using UI config file: %s\n" "${diveUiConfigFile}"
          printf "\n"

          image_file="${self.packages.x86_64-linux.dockerImageNixos}"

          printf "Image file: %s\n" "$image_file"
          printf "\n"

          printf "Inspecting Image:\n"
          "${pkgs.lib.getExe pkgs.skopeo}" inspect docker-archive:"$image_file" | "${pkgs.lib.getExe pkgs.jq}" . | "${pkgs.coreutils}/bin/head" -n 15
          printf "\n"

          "${pkgs.lib.getExe pkgs.docker-client}" load < "$image_file"
          printf "\n"

          "${pkgs.lib.getExe pkgs.dive}" --config="${diveUiConfigFile}" ''${@:-docker-image-nixos-pysay:${version}}
        '';

        dockerRun = pkgs.writeShellScriptBin "dockerRun" ''
          if [[ -S /run/docker.sock ]]; then
            export DOCKER_HOST="unix:///run/docker.sock"
            printf "DOCKER_HOST=\"%s\"\n" "$DOCKER_HOST"
            printf "\n"
          fi

          image_file="${self.packages.x86_64-linux.dockerImageNixos}"

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

        dockerImageNixos = pkgs.dockerTools.buildLayeredImage {
          name = "docker-image-nixos-pysay";
          tag = "${version}";
          created = "now";
          maxLayers = 125; # max is 125

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
            self.packages.${system}.pysay
          ];

          config =
            let
              entrypoint = "${self.packages.${system}.default}/bin/pysay";
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

        dockerImageUbuntu = pkgs.dockerTools.buildLayeredImage {
          name = "docker-image-ubuntu-pysay";
          tag = "${version}";
          created = "now";
          maxLayers = 125; # max is 125

          fromImage = pkgs.dockerTools.pullImage {
            imageName = "ubuntu";
            finalImageTag = "24.04";
            imageDigest = "sha256:1e622c5f073b4f6bfad6632f2616c7f59ef256e96fe78bf6a595d1dc4376ac02";
            sha256 = "sha256-UhZaL7KJLeTDzbkfgKawAHEoQ6JtwLrV4OG0GHfpRMg=";
            os = "linux";
            arch = "${system}";
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
            self.packages.${system}.pysay
          ];

          config =
            let
              entrypoint = "${self.packages.${system}.default}/bin/pysay";
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
      };

      # Make pysay runnable with `nix run`
      apps.${system} = rec {
        inherit (treefmt-conf.apps.${system}) tag-release;

        default = pysay;

        pysay = {
          type = "app";
          inherit pname;
          inherit version;
          inherit name;
          program = "${self.packages.${system}.default}/bin/pysay";
          meta = metadata;
        };

        usage = {
          type = "app";
          pname = "usage";
          name = "${pname}-${version}";
          inherit version;
          program = "${pkgs.lib.getExe packages.${system}.showUsage}";
          meta = metadata;
        };

        version = {
          type = "app";
          name = "version";
          pname = "${name}-${version}";
          inherit version;
          program = "${pkgs.lib.getExe packages.${system}.showVersion}";
          meta = metadata;
        };

        dockerCiCheck = {
          type = "app";
          name = "dockerCiCheck";
          pname = "${name}-${version}";
          inherit version;
          program = "${pkgs.lib.getExe packages.${system}.dockerCiCheck}";
          meta = metadata;
        };

        dive = {
          type = "app";
          name = "dive";
          pname = "${name}-${version}";
          inherit version;
          program = "${pkgs.lib.getExe packages.${system}.dive}";
          meta = metadata;
        };

        dockerRun = {
          type = "app";
          name = "dockerRun";
          pname = "${name}-${version}";
          inherit version;
          program = "${pkgs.lib.getExe packages.${system}.dockerRun}";
          meta = metadata;
        };
      };

      # This example provides two different modes of development:
      # - Impurely using uv to manage virtual environments
      # - Pure development using uv2nix to manage virtual environments
      devShells.${system} = rec {
        default = uv2nix;

        # It is of course perfectly OK to keep using an impure virtualenv workflow and only use uv2nix to build packages.
        # This devShell simply adds Python and undoes the dependency leakage done by Nixpkgs Python infrastructure.
        impure = pkgs.mkShell {
          name = "devShell.impure";
          packages = [
            python
            pkgs.uv
            pkgs.hatch
            pkgs.git
            pkgs.bashInteractive
          ];
          env =
            {
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
            unset PYTHONPATH
            ${pkgs.lib.getExe pkgs.cowsay} "Welcome to ${name}'s ${impure.name} devShell!"
            printf "\n"
            which python uv
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
              # members = [ "pysay" ];
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
            name = "devShell.uv2nix";
            packages = [
              virtualenv
              pkgs.uv
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

              ${pkgs.lib.getExe pkgs.cowsay} "Welcome to ${name}'s ${uv2nix.name} devShell!"
              printf "\n"
            '';
          };
      };
    };
}
