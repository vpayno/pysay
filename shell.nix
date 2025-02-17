# shell.nix
{pkgs ? import <nixpkgs> {}}:
with pkgs;
  mkShell {
    packages =
      (
        with pkgs.python312Packages; [
          hatch-vcs
          hatchling
          rich
        ]
      )
      ++ (with pkgs; [
        python312
        pdm
        uv
        git
        hatch
      ]);
    buildInputs = [
      nixfmt-rfc-style
    ];

    shellHook = ''
      unset PYTHONPATH
      [[ -d .venv ]] || python -m venv .venv
      [[ -d .venv ]] && source .venv/bin/activate
      which python
      which pdm
      which uv
      which git
    '';
  }
