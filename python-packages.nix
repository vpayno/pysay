# Generated by pip2nix 0.8.0.dev1
# See https://github.com/nix-community/pip2nix

{ pkgs, fetchurl, fetchgit, fetchhg }:

self: super: {
  "hatch-vcs" = super.buildPythonPackage rec {
    pname = "hatch-vcs";
    version = "0.4.0";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/82/0f/6cbd9976160bc334add63bc2e7a58b1433a31b34b7cda6c5de6dd983d9a7/hatch_vcs-0.4.0-py3-none-any.whl";
      sha256 = "0b4bmz73aqpi86507lc1j2ffayh1j0wbfbbnjgygkxjcwnzbd8mq";
    };
    format = "wheel";
    doCheck = false;
    buildInputs = [];
    checkInputs = [];
    nativeBuildInputs = [];
    propagatedBuildInputs = [
      self."hatchling"
      self."setuptools-scm"
    ];
  };
  "hatchling" = super.buildPythonPackage rec {
    pname = "hatchling";
    version = "1.27.0";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/08/e7/ae38d7a6dfba0533684e0b2136817d667588ae3ec984c1a4e5df5eb88482/hatchling-1.27.0-py3-none-any.whl";
      sha256 = "0ywkblmgmj1p22p8iqn8r636d7p9qwjgkka9k2inx4jggibg78nk";
    };
    format = "wheel";
    doCheck = false;
    buildInputs = [];
    checkInputs = [];
    nativeBuildInputs = [];
    propagatedBuildInputs = [
      self."packaging"
      self."pathspec"
      self."pluggy"
      self."tomli"
      self."trove-classifiers"
    ];
  };
  "markdown-it-py" = super.buildPythonPackage rec {
    pname = "markdown-it-py";
    version = "3.0.0";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/42/d7/1ec15b46af6af88f19b8e5ffea08fa375d433c998b8a7639e76935c14f1f/markdown_it_py-3.0.0-py3-none-any.whl";
      sha256 = "1cfam2hw2bfjiwxf9038yj3cqrcpiw7c9n6q5hirdgb0bj21clim";
    };
    format = "wheel";
    doCheck = false;
    buildInputs = [];
    checkInputs = [];
    nativeBuildInputs = [];
    propagatedBuildInputs = [
      self."mdurl"
    ];
  };
  "mdurl" = super.buildPythonPackage rec {
    pname = "mdurl";
    version = "0.1.2";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/b3/38/89ba8ad64ae25be8de66a6d463314cf1eb366222074cfda9ee839c56a4b4/mdurl-0.1.2-py3-none-any.whl";
      sha256 = "1y5qjqhmq2nm7xj6w5rrp503r7jhj7zr2qcnr6gs858nwm0ql044";
    };
    format = "wheel";
    doCheck = false;
    buildInputs = [];
    checkInputs = [];
    nativeBuildInputs = [];
    propagatedBuildInputs = [];
  };
  "packaging" = super.buildPythonPackage rec {
    pname = "packaging";
    version = "24.2";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/88/ef/eb23f262cca3c0c4eb7ab1933c3b1f03d021f2c48f54763065b6f0e321be/packaging-24.2-py3-none-any.whl";
      sha256 = "0nd7a421brjgd4prm8fbs8a6bcv4n1yplgxalgs02p16rnyb3aq9";
    };
    format = "wheel";
    doCheck = false;
    buildInputs = [];
    checkInputs = [];
    nativeBuildInputs = [];
    propagatedBuildInputs = [];
  };
  "pathspec" = super.buildPythonPackage rec {
    pname = "pathspec";
    version = "0.12.1";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/cc/20/ff623b09d963f88bfde16306a54e12ee5ea43e9b597108672ff3a408aad6/pathspec-0.12.1-py3-none-any.whl";
      sha256 = "026cnk3hvsy7g65ll3nzi3rcc0bavazgg94hfjr27hd473hh7md0";
    };
    format = "wheel";
    doCheck = false;
    buildInputs = [];
    checkInputs = [];
    nativeBuildInputs = [];
    propagatedBuildInputs = [];
  };
  "pluggy" = super.buildPythonPackage rec {
    pname = "pluggy";
    version = "1.5.0";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/88/5f/e351af9a41f866ac3f1fac4ca0613908d9a41741cfcf2228f4ad853b697d/pluggy-1.5.0-py3-none-any.whl";
      sha256 = "0sd6bvbvjd93ad04fmadmdk35rhv1wz5y5ky6zk2s06ar29avqa4";
    };
    format = "wheel";
    doCheck = false;
    buildInputs = [];
    checkInputs = [];
    nativeBuildInputs = [];
    propagatedBuildInputs = [];
  };
  "pygments" = super.buildPythonPackage rec {
    pname = "pygments";
    version = "2.19.1";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/8a/0b/9fcc47d19c48b59121088dd6da2488a49d5f72dacf8262e2790a1d2c7d15/pygments-2.19.1-py3-none-any.whl";
      sha256 = "133dmda902c3wcg63c1lf1jwxfwkbb9nvarg4jwg9v2wsm5598cy";
    };
    format = "wheel";
    doCheck = false;
    buildInputs = [];
    checkInputs = [];
    nativeBuildInputs = [];
    propagatedBuildInputs = [];
  };
  "pysay" = super.buildPythonPackage rec {
    pname = "pysay";
    version = "0.4.1.dev11+g403b355";
    src = ./.;
    format = "setuptools";
    doCheck = false;
    buildInputs = [];
    checkInputs = [];
    nativeBuildInputs = [
      self."hatchling"
      self."hatch-vcs"
    ];
    propagatedBuildInputs = [
      self."rich"
    ];
  };
  "rich" = super.buildPythonPackage rec {
    pname = "rich";
    version = "13.9.4";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/19/71/39c7c0d87f8d4e6c020a393182060eaefeeae6c01dab6a84ec346f2567df/rich-13.9.4-py3-none-any.whl";
      sha256 = "141aiirrk2rpkrlrv4bmj6l2xb1vjs382ddkk9vz4jq5xkkdajb0";
    };
    format = "wheel";
    doCheck = false;
    buildInputs = [];
    checkInputs = [];
    nativeBuildInputs = [];
    propagatedBuildInputs = [
      self."markdown-it-py"
      self."pygments"
      self."typing-extensions"
    ];
  };
  "setuptools-scm" = super.buildPythonPackage rec {
    pname = "setuptools-scm";
    version = "8.1.0";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/a0/b9/1906bfeb30f2fc13bb39bf7ddb8749784c05faadbd18a21cf141ba37bff2/setuptools_scm-8.1.0-py3-none-any.whl";
      sha256 = "1wwsinbyp7rkw3y2ifxif0gs4q9jfd4mwx38y2r6wjpxlqk34yl9";
    };
    format = "wheel";
    doCheck = false;
    buildInputs = [];
    checkInputs = [];
    nativeBuildInputs = [];
    propagatedBuildInputs = [
      self."packaging"
      self."setuptools"
      self."tomli"
      self."typing-extensions"
    ];
  };
  "tomli" = super.buildPythonPackage rec {
    pname = "tomli";
    version = "2.2.1";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/6e/c2/61d3e0f47e2b74ef40a68b9e6ad5984f6241a942f7cd3bbfbdbd03861ea9/tomli-2.2.1-py3-none-any.whl";
      sha256 = "1k45vj5659ghprcb5rvxlx3z3jdrcbvzkvpk1jfpf224bwycfmfb";
    };
    format = "wheel";
    doCheck = false;
    buildInputs = [];
    checkInputs = [];
    nativeBuildInputs = [];
    propagatedBuildInputs = [];
  };
  "trove-classifiers" = super.buildPythonPackage rec {
    pname = "trove-classifiers";
    version = "2025.1.15.22";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/2b/c5/6422dbc59954389b20b2aba85b737ab4a552e357e7ea14b52f40312e7c84/trove_classifiers-2025.1.15.22-py3-none-any.whl";
      sha256 = "0z5hlbbc7ljd2vsyc26hhhkqqgpvd7wvnkf96qfm0zzisj4wf6az";
    };
    format = "wheel";
    doCheck = false;
    buildInputs = [];
    checkInputs = [];
    nativeBuildInputs = [];
    propagatedBuildInputs = [];
  };
  "typing-extensions" = super.buildPythonPackage rec {
    pname = "typing-extensions";
    version = "4.12.2";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/26/9f/ad63fc0248c5379346306f8668cda6e2e2e9c95e01216d2b8ffd9ff037d0/typing_extensions-4.12.2-py3-none-any.whl";
      sha256 = "03bhjivpvdhn4c3x0963z89hv7b5vxr415akd1fgiwz0a41wmr84";
    };
    format = "wheel";
    doCheck = false;
    buildInputs = [];
    checkInputs = [];
    nativeBuildInputs = [];
    propagatedBuildInputs = [];
  };
}
