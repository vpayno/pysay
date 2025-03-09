{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  # https://devenv.sh/basics/
  env = {
    GREET = "devenv";
    UV_PYTHON = "${pkgs.lib.getExe pkgs.python39Full}";
    UV_PYTHON_PREFERENCE = "only-system";
  };

  # https://devenv.sh/packages/
  packages = with pkgs; [
    bashInteractive
    coreutils
    moreutils
    git
    tig
    tree
    glow
    runme
    uv
    python39Full
  ];

  # https://devenv.sh/languages/
  # languages.rust.enable = true;

  # https://devenv.sh/processes/
  # processes.cargo-watch.exec = "cargo-watch";

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/scripts/
  scripts = {
    versions.exec = ''
      which git python uv
      printf "\n"
      printf "%s: %s\n" "git" "${pkgs.git.version}"
      printf "%s: %s\n" "python" "${pkgs.python39Full.version}"
      printf "%s: %s\n" "uv" "${pkgs.uv.version}"
    '';

    "uv-venv-create" = {
      exec = ''
        if ! ${pkgs.lib.getExe pkgs.uv} venv "$@"; then
          rm -rf .venv
          ${pkgs.lib.getExe pkgs.uv} lock "$@"
          ${pkgs.lib.getExe pkgs.uv} venv "$@"
        fi
      '';
    };
    "uv-sync" = {
      exec = ''
        if ! ${pkgs.lib.getExe pkgs.uv} sync "$@"; then
          rm -rf .venv
          ${pkgs.lib.getExe pkgs.uv} lock "$@"
          ${pkgs.lib.getExe pkgs.uv} sync "$@"
        fi
      '';
    };
    "uv-build" = {
      exec = ''
        ${pkgs.lib.getExe pkgs.uv} build "$@"
      '';
    };
    "uv-test" = {
      exec = ''
        ${pkgs.lib.getExe pkgs.uv} run poe test "$@"
      '';
    };
    "pip" = {
      exec = ''
        ${pkgs.lib.getExe pkgs.uv} pip "$@"
      '';
    };
    "showUsage" = {
      exec = ''
        printf "\n"
        printf "devenv for Python Project %s\n" "pysay"
        printf "\n"
      '';
    };
  };

  enterShell = ''
    unset PYTHONPATH
    if [ ! -d .venv ]; then
      uv-venv-create
    fi
    . .venv/bin/activate
    uv-sync
    showUsage
  '';

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    uv-test
  '';

  # https://devenv.sh/pre-commit-hooks/
  # pre-commit.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/

  languages = {
    python = {
      uv = {
        enable = true;
        package = pkgs.uv;
        sync = {
          enable = true;
          allExtras = true;
          extras = [ ];
        };
      };
      venv = {
        enable = false;
      };
      version = "3.9";
    };
  };
}
