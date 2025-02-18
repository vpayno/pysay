# pysay

Like `cowsay` but with a `python` and written in `Python`.

From a `Real Python` tutorial.

It's a simple project that let's me focus on other things like CI, Releases,
Publishing, Pages, etc.

Once it's feature complete, I might treat it as an archived project and only
play with dependency update related maintenance.

## pdm to uv

Switched from `pdm` to `uv` to make working with the project using `uv2nix`
easier.

## Development environment

Using [devbox](https://github.com/jetify-com/devbox) to manage the development
environment.

Using [runme](https://github.com/stateful/runme) to add runnable markdown
playbooks to the project.

### devbox

Before starting development, run `devbox shell` to enter the `devbox`
development environment.

The development shell manages compiler and tool installations so you don't have
to and uses the versions specified by the project so you don't have to have them
installed locally.

To start the development shell run:

```bash
devbox shell
```

To see the list of available "scripts" run:

```bash
devbox run --list
```

To run an individual command in a devbox shell run:

```bash { name=uv-02-update_locks }
devbox update_locks
```

### runme

To see the list of available plays run:

```bash
devbox run runme list
```

To run a single play type:

```bash
devbox run runme run uv-02-update_locks
```

### devbox shell

Use the `devbox shell` for development.

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

### nix develop

To start a nix flake development shell with pysay run `nix develop`:

```bash
$ nix develop

$ which pysay
/nix/store/0256lx2lafd5vlvz8lqpks5vji0q0zjs-pysay/bin/pysay
```

## Running

### uv

You can use devbox shell and uv to run the main application.

```text
$ devbox run uv run pysay hello
     _______
    ( hello )
     -------
       \    __
        \  {oo}
           (__)\
             λ \\
               _\\__
              (_____)_
             (________)0o°
```

### nix run

To use `pysay` without installing it use `nix run`.

To run it from GitHub without a local git checkout:

```text
$ nix run github:vpayno/pysay -- hello

     _______
    ( hello )
     -------
       \    __
        \  {oo}
           (__)\
             λ \\
               _\\__
              (_____)_
             (________)0o°
```

To run it from a local git checkout:

```text
$ nix run . -- hello

     _______
    ( hello )
     -------
       \    __
        \  {oo}
           (__)\
             λ \\
               _\\__
              (_____)_
             (________)0o°
```

### nix-shell

To start a nix shell with `pysay` installed in it use `nix shell`.

Note: Tried using `pip2nix` but it needs the project to support Python 3.9 which
creates other problems.

```text
$ nix run github:nix-community/pip2nix generate .

$ git add python-packages.nix

$ nix-shell
these 34 derivations will be built:
  /nix/store/6s836yxxy0yfhblwbv2ini3hq12rdwjh-python3.12-setuptools-75.1.0.drv
...
  /nix/store/6akq3b0pzs85wyfwdzc369qhnl79syf0-python3-3.12.7-env.drv
building '/nix/store/6s836yxxy0yfhblwbv2ini3hq12rdwjh-python3.12-setuptools-75.1.0.drv'...
adding 'setuptools-75.1.0.post0.dist-info/RECORD'
removing build/bdist.linux-x86_64/wheel
Successfully built setuptools-75.1.0.post0-py3-none-any.whl
Finished creating a wheel...
Finished executing pypaBuildPhase
Running phase: pythonRuntimeDepsCheckHook
Executing pythonRuntimeDepsCheck
Checking runtime dependencies for setuptools-75.1.0.post0-py3-none-any.whl
  + Exception Group Traceback (most recent call last):
  |   File "/nix/store/gdxd1rn8zgjjw08ijghvpazj18n4sjl6-python-runtime-deps-check-hook.py", line 93, in <module>
  |     metadata = get_metadata(args.wheel)
  |                ^^^^^^^^^^^^^^^^^^^^^^^^
  |   File "/nix/store/gdxd1rn8zgjjw08ijghvpazj18n4sjl6-python-runtime-deps-check-hook.py", line 58, in get_metadata
  |     metadata = Metadata.from_raw(raw)
  |                ^^^^^^^^^^^^^^^^^^^^^^
  |   File "/nix/store/81sxy2crwqi6wx8bgils8s96j8sq8fy9-python3.12-packaging-24.2/lib/python3.12/site-packages/packaging/metadata.py", line 752, in from_raw
  |     raise ExceptionGroup("invalid metadata", exceptions)
  | ExceptionGroup: invalid metadata (1 sub-exception)
  +-+---------------- 1 ----------------
    | packaging.metadata.InvalidMetadata: license-file introduced in metadata version 2.4, not 2.1
    +------------------------------------
error: builder for '/nix/store/6s836yxxy0yfhblwbv2ini3hq12rdwjh-python3.12-setuptools-75.1.0.drv' failed with exit code 1;
       last 25 log lines:
       > adding 'setuptools/_vendor/zipp-3.19.2.dist-info/RECORD'
       > adding 'setuptools/_vendor/zipp-3.19.2.dist-info/REQUESTED'
       > adding 'setuptools/_vendor/zipp-3.19.2.dist-info/WHEEL'
       > adding 'setuptools/_vendor/zipp-3.19.2.dist-info/top_level.txt'
       > adding 'setuptools-75.1.0.post0.dist-info/RECORD'
       > removing build/bdist.linux-x86_64/wheel
       > Successfully built setuptools-75.1.0.post0-py3-none-any.whl
       > Finished creating a wheel...
       > Finished executing pypaBuildPhase
       > Running phase: pythonRuntimeDepsCheckHook
       > Executing pythonRuntimeDepsCheck
       > Checking runtime dependencies for setuptools-75.1.0.post0-py3-none-any.whl
       >   + Exception Group Traceback (most recent call last):
       >   |   File "/nix/store/gdxd1rn8zgjjw08ijghvpazj18n4sjl6-python-runtime-deps-check-hook.py", line 93, in <module>
       >   |     metadata = get_metadata(args.wheel)
       >   |                ^^^^^^^^^^^^^^^^^^^^^^^^
       >   |   File "/nix/store/gdxd1rn8zgjjw08ijghvpazj18n4sjl6-python-runtime-deps-check-hook.py", line 58, in get_metadata
       >   |     metadata = Metadata.from_raw(raw)
       >   |                ^^^^^^^^^^^^^^^^^^^^^^
       >   |   File "/nix/store/81sxy2crwqi6wx8bgils8s96j8sq8fy9-python3.12-packaging-24.2/lib/python3.12/site-packages/packaging/metadata.py", line 752, in from_raw
       >   |     raise ExceptionGroup("invalid metadata", exceptions)
       >   | ExceptionGroup: invalid metadata (1 sub-exception)
       >   +-+---------------- 1 ----------------
       >     | packaging.metadata.InvalidMetadata: license-file introduced in metadata version 2.4, not 2.1
       >     +------------------------------------
       For full logs, run 'nix log /nix/store/6s836yxxy0yfhblwbv2ini3hq12rdwjh-python3.12-setuptools-75.1.0.drv'.
error: 1 dependencies of derivation '/nix/store/c0p5sdxx59wjm7qc6hsm30366g2nb9nc-python3.12-certifi-2024.08.30.drv' failed to build
error: 1 dependencies of derivation '/nix/store/x4w33pq7dya671yan81x8ajfdxfwg7iw-python3.12-cffi-1.17.1.drv' failed to build
error: 1 dependencies of derivation '/nix/store/4wjrgfr5vzsc49kqj2v4ccbfgr7nfrr2-python3.12-pytest-8.3.3.drv' failed to build
error: 1 dependencies of derivation '/nix/store/gd4zr2v11kvnfnbnbifp7zf226yfqbl2-python3.12-pytest-mock-3.14.0.drv' failed to build
error: 1 dependencies of derivation '/nix/store/c1w027c4y11kcvfkinrv0qprpgvr8575-python3.12-setuptools-scm-8.1.0.drv' failed to build
error: 1 dependencies of derivation '/nix/store/i6d8naj0cbgwp7pc7i5hwar5s0lfckdv-setuptools-build-hook.drv' failed to build
error: 1 dependencies of derivation '/nix/store/6akq3b0pzs85wyfwdzc369qhnl79syf0-python3-3.12.7-env.drv' failed to build
```

## Installation

### uv tool install

The `uv tool install` command creates a private virtual environment for the
program you are installing. Unfortunately it doesn't also bundle in a Python
interpreter so it's still better to use `nix`.

### nix profile

To install it use `nix profile install`:

```text
$ nix profile install github:vpayno/pysay

$ nix profile list
...
Name:               pysay
Flake attribute:    packages.x86_64-linux.default
Original flake URL: github:vpayno/pysay/uv
Locked flake URL:   github:vpayno/pysay/f2b5541991355534abc668c17053081817b10f5d?narHash=sha256-Xvt50%2B5CvqEv4aNxEEHX6WMiIQgWIESwBRn1nLf8yZQ%3D
Store paths:        /nix/store/wd9g39zv4f8j92k518fmx500s66p5zz3-pysay-prod-env
...

$ which pysay
/home/vpayno/.nix-profile/bin/pysay
```
