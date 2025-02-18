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

## nix-shell

Tried using `pip2nix` but it needs the project to support Python 3.9 which
creates other problems.

```text
$ nix run github:nix-community/pip2nix generate .

$ git add python-packages.nix

$ nix-shell
these 34 derivations will be built:
  /nix/store/6s836yxxy0yfhblwbv2ini3hq12rdwjh-python3.12-setuptools-75.1.0.drv
  /nix/store/c2nq6qzj1pdfap8api80gk1agawgsl9m-python3.12-typing-extensions-4.12.2.drv
  /nix/store/mrbazn7sr85q7qddcbzc3lbnz0jf8phz-python3.12-tomli-2.2.1.drv
  /nix/store/c1w027c4y11kcvfkinrv0qprpgvr8575-python3.12-setuptools-scm-8.1.0.drv
  /nix/store/7q8kn0ii0arz8rs3075jwfwjfvk2wj28-python3.12-trove-classifiers-2025.1.15.22.drv
  /nix/store/gxgfyxw6c18si7afiygqc6bscmsp6vj9-python3.12-hatchling-1.27.0.drv
  /nix/store/cr1fhxmbpp6qarcmbyr9w3d14a6dgiiw-python3.12-iniconfig-2.0.0.drv
  /nix/store/4wjrgfr5vzsc49kqj2v4ccbfgr7nfrr2-python3.12-pytest-8.3.3.drv
  /nix/store/77pvfmh3i6dh67mydy4axpc90wami3v0-pytest-check-hook.drv
  /nix/store/fkxlkg2y8467xawv6rfvgz19876al8zp-python3.12-hatch-vcs-0.4.0.drv
  /nix/store/fpgvmnjzgmr2iiivps9clvf1zmzmpm8z-python3.12-pytest-asyncio-0.23.8.drv
  /nix/store/gd4zr2v11kvnfnbnbifp7zf226yfqbl2-python3.12-pytest-mock-3.14.0.drv
  /nix/store/7384x6xbzchkl4clqv2skr4jm6jsk0c4-python3.12-filelock-3.16.1.drv
  /nix/store/6iy60wz43frad912kbh8p79ynlspnicq-python3.12-greenlet-3.1.1.drv
  /nix/store/i6d8naj0cbgwp7pc7i5hwar5s0lfckdv-setuptools-build-hook.drv
  /nix/store/5khv3x89zcfnqqy7lpcsg05j7ym2va7c-python3.12-toml-0.10.2.drv
  /nix/store/griyn5lxmgcv1gr6kg1fzzgypwivpalr-python3.12-zipp-3.20.2.drv
  /nix/store/c6vmdw6ihqv905r820g7x24ni3z7k8wg-python3.12-importlib-metadata-8.5.0.drv
  /nix/store/dkq41kdab9qav8d1j9wdggk4jzzcn2yd-python3.12-zope.event-4.6.drv
  /nix/store/fr6alnmpd0nak848kix0b8sxzgxh0qis-python3.12-cython-3.0.11-1.drv
  /nix/store/qf30yqi5385q03w8dh4p646fndrh4kff-python3.12-zope.interface-6.4.post2.drv
  /nix/store/xv7r20hc8jmnl7qdjlv8cabbrqawyp8z-python3.12-pycparser-2.22.drv
  /nix/store/x4w33pq7dya671yan81x8ajfdxfwg7iw-python3.12-cffi-1.17.1.drv
  /nix/store/6ia06dzkrj591sw6ywlisa4dkjnpgrg9-python3.12-gevent-24.2.1.drv
  /nix/store/m6fj70q8s11b6igd6ic6sqv9bixazsmi-python3.12-execnet-2.1.1.drv
  /nix/store/17y80za0lx86jnwpigjxxpwankvwrq5j-python3.12-pytest-xdist-3.6.1.drv
  /nix/store/34a21mslp0qizraimj9qkil2kpg8vf03-python3.12-brotlicffi-1.1.0.0.drv
  /nix/store/c0p5sdxx59wjm7qc6hsm30366g2nb9nc-python3.12-certifi-2024.08.30.drv
  /nix/store/l0q9yyf6a5729ifx60skz59khyk88agn-python3.12-idna-3.10.drv
  /nix/store/rk1i59gw5v66qc8knq0gh6ajn4i1fqni-python3.12-pysocks-1.7.1.drv
  /nix/store/w32n66zd685kqxd2gzrfygnbyzr0vwkd-python3.12-urllib3-2.2.3.drv
  /nix/store/zg78ack9cpy3yqnga5n03sr1kmmsd7xj-python3.12-charset-normalizer-3.3.2.drv
  /nix/store/0id1phq76j12byf6z2cgfimj5380znrq-python3.12-requests-2.32.3.drv
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
