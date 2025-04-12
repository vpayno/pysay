# pysay

Like `cowsay` but with a `python` and written in `Python`.

Python ASCII art is from a `Real Python` tutorial.

It's a simple project that let's me focus on other things like CI, Releases,
Publishing, Pages, etc.

Once it's feature complete, I might treat it as an archived project and only
play with dependency update related maintenance.

## Releases

To tag a release run:

```bash
nix run github:vpayno/nix-treefmt-conf#tag-release v0.5.8 'devbox shell, pyproject.toml and flake.nix fixes'
```

## Usage

To show the usage help screen run: `nix run github:vpayno/pysay#usage`

```text
$ nix run github:vpayno/pysay#usage
this derivation will be built:
  /nix/store/j7y81rm34jn8v6j001z7xzlh6zq9i3d0-showUsage.drv
building '/nix/store/j7y81rm34jn8v6j001z7xzlh6zq9i3d0-showUsage.drv'...
Available pysay flake commands:

  nix run .#usage

  nix run . -- message
    nix run .#default -- message
    nix run .#pysay -- message

  nix profile install github:vpayno/pysay
```

To to run `pysay` run: `nix run github:vpayno/pysay -- "Hello World!"`

```text
$ nix run github:vpayno/pysay -- "Hello World!"

     ______________
    ( Hello World! )
     --------------
       \    __
        \  {oo}
           (__)\
             λ \\
               _\\__
              (_____)_
             (________)0o°
```

To install `pysay` from the command line use `nix profile install`.

```text
$ nix profile install github:vpayno/pysay

$ nix profile list
Name:               pysay
Flake attribute:    packages.x86_64-linux.default
Original flake URL: github:vpayno/pysay
Locked flake URL:   github:vpayno/pysay/d935615aadd005e9a8c1bf1f8e2f1dc77a6aae79?narHash=sha256-fcp2HSmibZsXsdGBcOdue3k4EKBu5l5oND5JpkOOHV8%3D
Store paths:        /nix/store/m79i1q42qmbj21yxbgi6d37frzcs6ppk-pysay-prod-env

$ which pysay
/home/vpayno/.nix-profile/bin/pysay
```

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

### devenv shell

[devenv](https://devenv.sh/getting-started/) is another `nix` based development
environment.

To start the shell run `devenv shell`.

```bash
$ devenv shell
• Building shell ...
• Using Cachix: devenv
✔ Building shell in 51.5ms
Entering shell
warning: unknown experimental feature 'pipe-operators'
Running tasks     devenv:enterShell
Succeeded         devenv:enterShell 3ms
1 Succeeded                         4.62ms

Resolved 53 packages in 5ms
Audited 52 packages in 0.18ms

devenv for Python Project pysay

$ which python uv pysay pip
/home/vpayno/git_vpayno/pysay/.venv/bin/python
/nix/store/w7cs06nn9vvk8a59nv48y4biv9zzv43x-uv-0.4.30/bin/uv
/home/vpayno/git_vpayno/pysay/.venv/bin/pysay
/nix/store/ykq20bhiw8khiyg4nwwl6qc6i5gh9ing-pip/bin/pip

$ cat /nix/store/ykq20bhiw8khiyg4nwwl6qc6i5gh9ing-pip/bin/pip
#!/nix/store/p6k7xp1lsfmbdd731mlglrdj2d66mr82-bash-5.2p37/bin/bash
/nix/store/w7cs06nn9vvk8a59nv48y4biv9zzv43x-uv-0.4.30/bin/uv pip "$@"
```

I'm having issues with `uv.lock` incompatibilities. It's not compatible with the
`uv.lock` file generated by `devbox`.

```text
Creating virtual environment at: .venv
error: Failed to parse `uv.lock`
  Caused by: TOML parse error at line 564, column 1
    |
564 | [[package]]
    | ^^^^^^^^^^^
missing field `version`
```

The `devbox` `virtualenv` integration doesn't generate the version field in the
project.

```toml
 [[package]]
 name = "pysay"
-version = "0.5.2.dev7+gc835dc1.d19800101"
 source = { editable = "." }
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

To run a specific version from GitHub using a specific version use the
`?tag=v0.5.0` argument:

```text
$ nix run github:vpayno/pysay?tag=v0.5.0 -- hello

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

```bash
$ devbox run uv tool install git+https://github.com/vpayno/pysay

$ which pysay
/home/vpayno/.local/bin/pysay

$ ls -lh /home/vpayno/.local/bin/pysay
lrwxrwxrwx 1 vpayno vpayno 50 Feb 17 22:37 /home/vpayno/.local/bin/pysay -> /home/vpayno/.local/share/uv/tools/pysay/bin/pysay

$ tree /home/vpayno/.local/share/uv/tools/pysay/
/home/vpayno/.local/share/uv/tools/pysay/
├── bin
│   ├── activate
│   ├── activate.bat
│   ├── activate.csh
│   ├── activate.fish
│   ├── activate.nu
│   ├── activate.ps1
│   ├── activate_this.py
│   ├── deactivate.bat
│   ├── markdown-it
│   ├── pydoc.bat
│   ├── pygmentize
│   ├── pysay
│   ├── python -> /home/vpayno/git_vpayno/pysay-cr-nix/.devbox/nix/profile/default/bin/python
│   ├── python3 -> python
│   └── python3.12 -> python
├── CACHEDIR.TAG
├── lib
│   └── python3.12
│       └── site-packages
│           ├── markdown_it
│           ├── markdown_it_py-3.0.0.dist-info
│           ├── mdurl
│           ├── mdurl-0.1.2.dist-info
│           ├── pygments
│           ├── pygments-2.19.1.dist-info
│           ├── pysay
│           │   ├── __init__.py
│           │   ├── __main__.py
│           │   ├── main.py
│           │   ├── snake.py
│           │   └── _version.py
│           ├── pysay-0.4.1.dev8+gba124be.dist-info
│           │   ├── direct_url.json
│           │   ├── entry_points.txt
│           │   ├── INSTALLER
│           │   ├── licenses
│           │   │   └── LICENSE
│           │   ├── METADATA
│           │   ├── RECORD
│           │   ├── REQUESTED
│           │   └── WHEEL
│           ├── rich
│           ├── rich-13.9.4.dist-info
│           ├── _virtualenv.pth
│           └── _virtualenv.py
├── lib64 -> lib
├── pyvenv.cfg
└── uv-receipt.toml

29 directories, 552 files
```

### nix profile

To install it use `nix profile install`:

```text
$ nix profile install github:vpayno/pysay?tag=v0.5.0

$ nix profile list
...
Name:               pysay
Flake attribute:    packages.x86_64-linux.default
Original flake URL: github:vpayno/pysay
Locked flake URL:   github:vpayno/pysay/79f80c9284550319b192ddae60f5c9fff76f6478?narHash=sha256-gbCb0mQyRSWkS8ctaSvvwWN7yvtJr/5jVljE7SVW/vU%3D
Store paths:        /nix/store/61i2bx85wzvpww6bjcgzwx1f2psvyznf-pysay-prod-env
...

$ which pysay
/home/vpayno/.nix-profile/bin/pysay
```

## Running UV Tools

`uv` doesn't support custom commands like `pdm` does so I'm using `poethepoet`
to define and run them.

To see a list of available commands run:

```text
devbox run uv run poe
```

## Docker

### Using NixOS Containers

#### Building the container

```text
$ nix build .#dockerImageNixos

$ ls -lh ./result
lrwxrwxrwx 1 vpayno vpayno   75 Apr 11 10:25 result -> /nix/store/vnrqz28p0xv5iph9xm52b7cfx5shbpfa-docker-image-nixos-pysay.tar.gz
```

#### Caching/Installing the container

```text
$ docker load < ./result
bac1ce201147: Loading layer [==================================================>]  2.079MB/2.079MB
73c3619fb187: Loading layer [==================================================>]  399.4kB/399.4kB
d49827920aca: Loading layer [==================================================>]    215kB/215kB
c8eacd12fc04: Loading layer [==================================================>]  30.78MB/30.78MB
3904c3bfe5fb: Loading layer [==================================================>]  143.4kB/143.4kB
c1794f64bf67: Loading layer [==================================================>]  5.202MB/5.202MB
185acf266499: Loading layer [==================================================>]   1.72MB/1.72MB
cc16370331d9: Loading layer [==================================================>]    215kB/215kB
9d4dc07856d6: Loading layer [==================================================>]   1.69MB/1.69MB
eef160dc49d3: Loading layer [==================================================>]  92.16kB/92.16kB
25d5f0ab16e8: Loading layer [==================================================>]    297kB/297kB
829e9138c982: Loading layer [==================================================>]  10.02MB/10.02MB
690ae98a8704: Loading layer [==================================================>]  491.5kB/491.5kB
b011966820c8: Loading layer [==================================================>]  81.92kB/81.92kB
7926448bbffa: Loading layer [==================================================>]  143.4kB/143.4kB
3b0071b79b5f: Loading layer [==================================================>]  133.1kB/133.1kB
6a1dc9365436: Loading layer [==================================================>]  235.5kB/235.5kB
abcb277ace82: Loading layer [==================================================>]  8.264MB/8.264MB
abc445bff6ba: Loading layer [==================================================>]  491.5kB/491.5kB
67fe4cdb969c: Loading layer [==================================================>]  2.929MB/2.929MB
6b1cb7f6fab8: Loading layer [==================================================>]  2.017MB/2.017MB
3af9d70cfe80: Loading layer [==================================================>]  911.4kB/911.4kB
fa922ca941c6: Loading layer [==================================================>]  118.5MB/118.5MB
4db172c1d0a2: Loading layer [==================================================>]  757.8kB/757.8kB
c5c02fcf2467: Loading layer [==================================================>]  81.92kB/81.92kB
ac435e72ae6a: Loading layer [==================================================>]  9.574MB/9.574MB
840c9d39c4b1: Loading layer [==================================================>]  61.44kB/61.44kB
d916d045ef48: Loading layer [==================================================>]  2.376MB/2.376MB
1b320df473e0: Loading layer [==================================================>]  61.44kB/61.44kB
0eeef386fb1f: Loading layer [==================================================>]  30.72kB/30.72kB
Loaded image: docker-image-nixos-pysay:v0.5.9
```

```text
$ docker image ls docker-image-nixos-pysay:v0.5.9
REPOSITORY                 TAG       IMAGE ID       CREATED         SIZE
docker-image-nixos-pysay   v0.5.9    b9df191303bc   4 minutes ago   189MB
```

#### Using dive to inspect the image

Having issues mixing `nixpkgs#dive` with `debian#docker`.

```text
$ nix run nixpkgs#dive -- ./result --source docker-archive --ci
Image Source: docker-archive://./result
Extracting image from docker-archive... (this can take a while for large images)
archive/tar: invalid tar header

$ nix run nixpkgs#dive -- docker-image-nixos-pysay:v0.5.9 --ci
  Using default CI config
Image Source: docker://docker-image-nixos-pysay:v0.5.9
Extracting image from docker-engine... (this can take a while for large images)
> could not determine docker host: context "default": context not found: open /home/vpayno/.docker/contexts/meta/37a8eec1ce19687d132fe29051dca629d164e2c4958ba141d5f4133a33f
0688f/meta.json: no such file or directory
cannot fetch image
unable to parse docker host ``
```

Using a shell with the required tools instead.

```text
$ nix-shell -p docker-client dive --command 'dive docker-image-nixos-pysay:v0.5.9 --ci'
  Using default CI config
Image Source: docker://docker-image-nixos-pysay:v0.5.9
Fetching image... (this can take a while for large images)
Analyzing image...
  efficiency: 100.0000 %
  wastedBytes: 0 bytes (0 B)
  userWastedPercent: 0.0000 %
Inefficient Files:
Count  Wasted Space  File Path
None
Results:
  PASS: highestUserWastedPercent
  SKIP: highestWastedBytes: rule disabled
  PASS: lowestEfficiency
Result:PASS [Total:3] [Passed:2] [Failed:0] [Warn:0] [Skipped:1]
```

#### Using skopeo to inspect the image

```text
$ nix run nixpkgs#skopeo -- inspect docker-archive:./result
{
    "Digest": "sha256:99fdb56b3d8d4bfa80ead30db2adce757dcb863ea755d8eb38ea35dc1eb183d2",
    "RepoTags": [],
    "Created": "2025-04-11T17:24:56.667003Z",
    "DockerVersion": "",
    "Labels": null,
    "Architecture": "amd64",
    "Os": "linux",
    "Layers": [
        "sha256:bac1ce201147bfaef5591ae3e3f77d8baa10468410e80520ca08d4be9ed425ca",
        "sha256:73c3619fb187b9129dcb3380ca18f27e7de5c4cc992170c41b079af66d839d56",
        "sha256:d49827920acab921e0bfa976477bad46f8b94188cd022aecc5f62614708eefe7",
        "sha256:c8eacd12fc040a3c8eb38e03465a29d436540973a26a1a63931f11c57dc78cc4",
        "sha256:3904c3bfe5fbfe7d68abcbc91e5b21783aa36e72bb7427303e2faf6477c68e6f",
        "sha256:c1794f64bf676e2fb25dfb58e85d5336b32982f6b4a799622f077f40e96b7234",
        "sha256:185acf2664997c97f173ef199bbc7504f82b846cd1808efc0dd22ed8a6049ca2",
        "sha256:cc16370331d928b90506a67348d91a8737625ed041fe01d9ed349f22c25ee699",
        "sha256:9d4dc07856d6f0b4bd884600279c724420ac72a640c7b61dc049a3947712b919",
        "sha256:eef160dc49d394c1800881543d17c50556f2cf6bb31c05aedc3adeded2bfe2b1",
        "sha256:25d5f0ab16e86a4eef8cf4fd235a02fa234c2a1f7137a7463e6c3e3ebd03423f",
        "sha256:829e9138c98268da65671b0234152637a5bf6fdda417af058a0cbbd268588218",
        "sha256:690ae98a8704d22a8615f65202f09efc9e080cc35abc19145299b90c17923d6e",
        "sha256:b011966820c86414f0356040315bf038f8073b404c3a6a58e5d8145b1dcc5d85",
        "sha256:7926448bbffad18f1bdc471d8b0fc50b22e98c7ca748a77e54addec48cbbdf74",
        "sha256:3b0071b79b5f08b1151a49a826bd989a18951689b23e9ddc5f0d50e25c161e57",
        "sha256:6a1dc936543612b09ab70e1a6dde9fd60f921be781db91166ebb24dffbe7e5e8",
        "sha256:abcb277ace828f13e9d3aa4fe46149dddb1feac0b6148113577172dbb2f4d5e9",
        "sha256:abc445bff6bae22c9b362b7dee5f387ee167d60f92686a35e8f55c2d738ca97b",
        "sha256:67fe4cdb969cc13f67728b848d6ef725a707781961ff7b1d65b0d15d81fecff3",
        "sha256:6b1cb7f6fab8e706823ac6a52664cc4f5a61259426b82dff90c5863d4dfb0fc1",
        "sha256:3af9d70cfe804a029b9f6277bf82d4359f22803fa3c60380736ee90fd45aee54",
        "sha256:fa922ca941c62a97c059a7e33e0221095a1f1abcbd1ae25dcc5a579ef644c056",
        "sha256:4db172c1d0a216abe85ea729db9b00ea9d6bdf3e61aa324f2fa6770337eb661d",
        "sha256:c5c02fcf2467e4c2876cae84cbac3f4290e312eface931dd941f2acee4ff8b66",
        "sha256:ac435e72ae6a274c966419e260e411eb62fc58f0d3a95426d2b2bba31ce54e97",
        "sha256:840c9d39c4b12828cf15a7151a1cae3edd456a09eb25cfeb34863c6eae6a50aa",
        "sha256:d916d045ef481d98c27e08fd5883c6f9839fc1a86564387bd02fc06b23e734a3",
        "sha256:1b320df473e032a29fe33c53b77f0976b4821747af3497cb28c7184e37c9612c",
        "sha256:0eeef386fb1f9a45060471639c41b039e8caf392411f4ed9c1ed144dec8cf843"
    ],
    "LayersData": [
        {
            "MIMEType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
            "Digest": "sha256:bac1ce201147bfaef5591ae3e3f77d8baa10468410e80520ca08d4be9ed425ca",
            "Size": 2078720,
            "Annotations": null
        },
        {
            "MIMEType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
            "Digest": "sha256:73c3619fb187b9129dcb3380ca18f27e7de5c4cc992170c41b079af66d839d56",
            "Size": 399360,
            "Annotations": null
        },
        {
            "MIMEType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
            "Digest": "sha256:d49827920acab921e0bfa976477bad46f8b94188cd022aecc5f62614708eefe7",
            "Size": 215040,
            "Annotations": null
        },
        {
            "MIMEType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
            "Digest": "sha256:c8eacd12fc040a3c8eb38e03465a29d436540973a26a1a63931f11c57dc78cc4",
            "Size": 30781440,
            "Annotations": null
        },
        {
            "MIMEType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
            "Digest": "sha256:3904c3bfe5fbfe7d68abcbc91e5b21783aa36e72bb7427303e2faf6477c68e6f",
            "Size": 143360,
            "Annotations": null
        },
        {
            "MIMEType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
            "Digest": "sha256:c1794f64bf676e2fb25dfb58e85d5336b32982f6b4a799622f077f40e96b7234",
            "Size": 5201920,
            "Annotations": null
        },
        {
            "MIMEType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
            "Digest": "sha256:185acf2664997c97f173ef199bbc7504f82b846cd1808efc0dd22ed8a6049ca2",
            "Size": 1720320,
            "Annotations": null
        },
        {
            "MIMEType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
            "Digest": "sha256:cc16370331d928b90506a67348d91a8737625ed041fe01d9ed349f22c25ee699",
            "Size": 215040,
            "Annotations": null
        {
            "MIMEType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
            "Digest": "sha256:9d4dc07856d6f0b4bd884600279c724420ac72a640c7b61dc049a3947712b919",
            "Size": 1689600,
            "Annotations": null
        },
        {
            "MIMEType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
            "Digest": "sha256:eef160dc49d394c1800881543d17c50556f2cf6bb31c05aedc3adeded2bfe2b1",
            "Size": 92160,
            "Annotations": null
        },
        {
            "MIMEType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
            "Digest": "sha256:25d5f0ab16e86a4eef8cf4fd235a02fa234c2a1f7137a7463e6c3e3ebd03423f",
            "Size": 296960,
            "Annotations": null
        },
        {
            "MIMEType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
            "Digest": "sha256:829e9138c98268da65671b0234152637a5bf6fdda417af058a0cbbd268588218",
            "Size": 10024960,
            "Annotations": null
        },
        {
            "MIMEType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
            "Digest": "sha256:690ae98a8704d22a8615f65202f09efc9e080cc35abc19145299b90c17923d6e",
            "Size": 491520,
            "Annotations": null
        },
        {
            "MIMEType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
            "Digest": "sha256:b011966820c86414f0356040315bf038f8073b404c3a6a58e5d8145b1dcc5d85",
            "Size": 81920,
            "Annotations": null
        },
        {
            "MIMEType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
            "Digest": "sha256:7926448bbffad18f1bdc471d8b0fc50b22e98c7ca748a77e54addec48cbbdf74",
            "Size": 143360,
            "Annotations": null
        },
        {
            "MIMEType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
            "Digest": "sha256:3b0071b79b5f08b1151a49a826bd989a18951689b23e9ddc5f0d50e25c161e57",
            "Size": 133120,
            "Annotations": null
        },
        {
            "MIMEType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
            "Digest": "sha256:6a1dc936543612b09ab70e1a6dde9fd60f921be781db91166ebb24dffbe7e5e8",
            "Size": 235520,
            "Annotations": null
        },
        {
            "MIMEType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
            "Digest": "sha256:abcb277ace828f13e9d3aa4fe46149dddb1feac0b6148113577172dbb2f4d5e9",
            "Size": 8263680,
            "Annotations": null
        },
        {
            "MIMEType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
            "Digest": "sha256:abc445bff6bae22c9b362b7dee5f387ee167d60f92686a35e8f55c2d738ca97b",
            "Size": 491520,
            "Annotations": null
        },
        {
            "MIMEType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
            "Digest": "sha256:67fe4cdb969cc13f67728b848d6ef725a707781961ff7b1d65b0d15d81fecff3",
            "Size": 2928640,
            "Annotations": null
        },
        },
        {
            "MIMEType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
            "Digest": "sha256:6b1cb7f6fab8e706823ac6a52664cc4f5a61259426b82dff90c5863d4dfb0fc1",
            "Size": 2017280,
            "Annotations": null
        },
        {
            "MIMEType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
            "Digest": "sha256:3af9d70cfe804a029b9f6277bf82d4359f22803fa3c60380736ee90fd45aee54",
            "Size": 911360,
            "Annotations": null
        },
        {
            "MIMEType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
            "Digest": "sha256:fa922ca941c62a97c059a7e33e0221095a1f1abcbd1ae25dcc5a579ef644c056",
            "Size": 118517760,
            "Annotations": null
        },
        {
            "MIMEType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
            "Digest": "sha256:4db172c1d0a216abe85ea729db9b00ea9d6bdf3e61aa324f2fa6770337eb661d",
            "Size": 757760,
            "Annotations": null
        },
        {
            "MIMEType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
            "Digest": "sha256:c5c02fcf2467e4c2876cae84cbac3f4290e312eface931dd941f2acee4ff8b66",
            "Size": 81920,
            "Annotations": null
        },
        {
            "MIMEType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
            "Digest": "sha256:ac435e72ae6a274c966419e260e411eb62fc58f0d3a95426d2b2bba31ce54e97",
            "Size": 9574400,
            "Annotations": null
        },
        {
            "MIMEType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
            "Digest": "sha256:840c9d39c4b12828cf15a7151a1cae3edd456a09eb25cfeb34863c6eae6a50aa",
            "Size": 61440,
            "Annotations": null
        },
        {
            "MIMEType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
            "Digest": "sha256:d916d045ef481d98c27e08fd5883c6f9839fc1a86564387bd02fc06b23e734a3",
            "Size": 2375680,
            "Annotations": null
        },
        {
            "MIMEType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
            "Digest": "sha256:1b320df473e032a29fe33c53b77f0976b4821747af3497cb28c7184e37c9612c",
            "Size": 61440,
            "Annotations": null
        },
        {
            "MIMEType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
            "Digest": "sha256:0eeef386fb1f9a45060471639c41b039e8caf392411f4ed9c1ed144dec8cf843",
            "Size": 30720,
            "Annotations": null
        }
    ],
    "Env": [
        "ENTRYPOINT=/nix/store/m353j8ynv7cki5dlzm2fdvpyxc2nsmpk-pysay-prod-env-v0.5.9/bin/pysay"
    ]
}
```

#### Using dive to inspect the image layers

```text
$ nix run .#dive
DOCKER_HOST="unix:///run/docker.sock"

Using UI config file: /nix/store/522m88vm1r315pm8yjzy0xdg1bp4f7mi-dive-ui.yaml

Using config file: /nix/store/522m88vm1r315pm8yjzy0xdg1bp4f7mi-dive-ui.yaml
Image Source: docker://docker-image-nixos-pysay:v0.5.9
Extracting image from docker-engine... (this can take a while for large images)
Analyzing image...
Building cache...

Image file: /nix/store/rxl3ys5ql65xk1apcj2ss3m27blgmbx3-docker-image-nixos-pysay.tar.gz

Inspecting Image:
{
  "Digest": "sha256:677f4689750a77ff38e794e432c76a050e5a5410ee188a90fcf1a6ab08f228f7",
  "RepoTags": [],
  "Created": "2025-04-12T02:03:49.749271Z",
  "DockerVersion": "",
  "Labels": null,
  "Architecture": "amd64",
  "Os": "linux",
  "Layers": [
    "sha256:bac1ce201147bfaef5591ae3e3f77d8baa10468410e80520ca08d4be9ed425ca",
    "sha256:73c3619fb187b9129dcb3380ca18f27e7de5c4cc992170c41b079af66d839d56",
    "sha256:d49827920acab921e0bfa976477bad46f8b94188cd022aecc5f62614708eefe7",
    "sha256:c8eacd12fc040a3c8eb38e03465a29d436540973a26a1a63931f11c57dc78cc4",
    "sha256:3904c3bfe5fbfe7d68abcbc91e5b21783aa36e72bb7427303e2faf6477c68e6f",
    "sha256:c1794f64bf676e2fb25dfb58e85d5336b32982f6b4a799622f077f40e96b7234",

Loaded image: docker-image-nixos-pysay:v0.5.9

                                                                                      │ Current Layer Contents ├───────────────────────────────────────────────────────────
┃ ● Layers ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ Permission     UID:GID       Size  Filetree
Cmp   Size  Command                                                                   drwxr-xr-x         0:0        0 B  ├── bin
    864 kB                                                                            -rwxrwxrwx         0:0        0 B  │   ├── Activate.ps1 → /nix/store/334ah0x9bpfnpaxh
    113 MB                                                                            -rwxrwxrwx         0:0        0 B  │   ├── activate → /nix/store/334ah0x9bpfnpaxh9ir0
    473 kB                                                                            -rwxrwxrwx         0:0        0 B  │   ├── activate.csh → /nix/store/334ah0x9bpfnpaxh
     40 kB                                                                            -rwxrwxrwx         0:0        0 B  │   ├── activate.fish → /nix/store/334ah0x9bpfnpax
    8.3 MB                                                                            -rwxrwxrwx         0:0        0 B  │   ├── markdown-it → /nix/store/334ah0x9bpfnpaxh9
     39 kB                                                                            -rwxrwxrwx         0:0        0 B  │   ├── pygmentize → /nix/store/334ah0x9bpfnpaxh9i
    2.1 MB                                                                            -rwxrwxrwx         0:0        0 B  │   ├── pysay → /nix/store/334ah0x9bpfnpaxh9ir0i30
     32 kB                                                                            -rwxrwxrwx         0:0        0 B  │   ├── python → python3.12
       0 B                                                                            -rwxrwxrwx         0:0        0 B  │   ├── python3 → python3.12
                                                                                      -rwxrwxrwx         0:0        0 B  │   └── python3.12 → /nix/store/334ah0x9bpfnpaxh9i
│ Layer Details ├──────────────────────────────────────────────────────────────────── drwxr-xr-x         0:0        0 B  ├── include
                                                                                      drwxr-xr-x         0:0        0 B  │   └── python3.12
Tags:   (unavailable)                                                                 drwxr-xr-x         0:0        0 B  ├── lib
Id:     blobs                                                                         drwxr-xr-x         0:0        0 B  │   └── python3.12
Size:   0 B                                                                           drwxr-xr-x         0:0        0 B  │       └── site-packages
Digest: sha256:02696cb685f886caefb6c2420b06237ea0d788e61c8493bd0e07b25d75fb9240       -rwxrwxrwx         0:0        0 B  │           ├── markdown_it → /nix/store/nlg36q3vi
Command:                                                                              -rwxrwxrwx         0:0        0 B  │           ├── markdown_it_py-3.0.0.dist-info → /
                                                                                      -rwxrwxrwx         0:0        0 B  │           ├── mdurl → /nix/store/f1yxy650k0f02kq
                                                                                      -rwxrwxrwx         0:0        0 B  │           ├── mdurl-0.1.2.dist-info → /nix/store
                                                                                      -rwxrwxrwx         0:0        0 B  │           ├── pygments → /nix/store/sb6qb2s2fyb5
                                                                                      -rwxrwxrwx         0:0        0 B  │           ├── pygments-2.19.1.dist-info → /nix/s
                                                                                      -rwxrwxrwx         0:0        0 B  │           ├── pysay → /nix/store/b0ghhphgf9wf8dg
│ Image Details ├──────────────────────────────────────────────────────────────────── -rwxrwxrwx         0:0        0 B  │           ├── pysay-0.0.0.dist-info → /nix/store
                                                                                      -rwxrwxrwx         0:0        0 B  │           ├── rich → /nix/store/9mllf5546jlpnw52
Image name: docker-image-nixos-pysay:v0.5.9                                           -rwxrwxrwx         0:0        0 B  │           └── rich-13.9.4.dist-info → /nix/store
Total Image size: 189 MB                                                              -rwxrwxrwx         0:0        0 B  ├── lib64 → lib
Potential wasted space: 0 B                                                           -rwxrwxrwx         0:0        0 B  └── pyvenv.cfg → /nix/store/334ah0x9bpfnpaxh9ir0i3
Image efficiency score: 100 %

Count   Total Space  Path



▏^C Quit ▏Tab Switch view ▏^F Filter ▏^L Show layer changes ▏^A Show aggregated changes ▏
```

#### Running the container without arguments for the entry point

````text
$ docker run --rm -it docker-image-nixos-pysay:v0.5.9

     __________________________
    ( Hello From NixOS+Docker! )
     --------------------------
       \    __
        \  {oo}
           (__)\
             λ \\
               _\\__
              (_____)_
             (________)0o°


#### Running the container with arguments for the entry point

```text
$ docker run --rm -it docker-image-nixos-pysay:v0.5.9 "Hello from command-line!"

     __________________________
    ( Hello from command-line! )
     --------------------------
       \    __
        \  {oo}
           (__)\
             λ \\
               _\\__
              (_____)_
             (________)0o°
````

#### Using nix run to run docker run

```text
$ nix run .#dockerRun -- 'Hello from Nix!'
DOCKER_HOST="unix:///run/docker.sock"

Image file: /nix/store/rxl3ys5ql65xk1apcj2ss3m27blgmbx3-docker-image-nixos-pysay.tar.gz

Inspecting Image:
{
  "Digest": "sha256:677f4689750a77ff38e794e432c76a050e5a5410ee188a90fcf1a6ab08f228f7",
  "RepoTags": [],
  "Created": "2025-04-12T02:03:49.749271Z",
  "DockerVersion": "",
  "Labels": null,
  "Architecture": "amd64",
  "Os": "linux",
  "Layers": [
    "sha256:bac1ce201147bfaef5591ae3e3f77d8baa10468410e80520ca08d4be9ed425ca",
    "sha256:73c3619fb187b9129dcb3380ca18f27e7de5c4cc992170c41b079af66d839d56",
    "sha256:d49827920acab921e0bfa976477bad46f8b94188cd022aecc5f62614708eefe7",
    "sha256:c8eacd12fc040a3c8eb38e03465a29d436540973a26a1a63931f11c57dc78cc4",
    "sha256:3904c3bfe5fbfe7d68abcbc91e5b21783aa36e72bb7427303e2faf6477c68e6f",
    "sha256:c1794f64bf676e2fb25dfb58e85d5336b32982f6b4a799622f077f40e96b7234",

Loaded image: docker-image-nixos-pysay:v0.5.9

REPOSITORY                 TAG       IMAGE ID       CREATED       SIZE
docker-image-nixos-pysay   v0.5.9    04735ffe72d8   7 hours ago   189MB

     _________________
    ( Hello from Nix! )
     -----------------
       \    __
        \  {oo}
           (__)\
             λ \\
               _\\__
              (_____)_
             (________)0o°
```
