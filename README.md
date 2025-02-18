# pysay

Like `cowsay` but with a `python` and written in `Python`.

From a `Real Python` tutorial.

It's a simple project that let's me focus on other things like CI, Releases,
Publishing, Pages, etc.

Once it's feature complete, I might treat it as an archived project and only
play with dependency update related maintenance.

## uv

Switched from `pdm` to `uv` to make working with the project using `uv2nix`
easier.

### uv tool install

The `uv tool install` command creates a private virtual environment for the
program you are installing. Unfortunately it doesn't also bundle in a Python
interpreter so it's still better to use `nix`.

## devbox shell

Added a `devbox` shell for development.

```bash
$ devbox shell

$ which python
/home/vpayno/git_vpayno/pysay-cr-uv/.venv/bin/python

$ which uv
/home/vpayno/git_vpayno/pysay-cr-uv/.devbox/nix/profile/default/bin/uv

$ which pysay
/home/vpayno/git_vpayno/pysay-cr-uv/.venv/bin/pysay

$ exit
```
