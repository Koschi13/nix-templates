{
  pkgs,
  version,
  bashColors,
}: let
  nativeBuildInputs = with pkgs; [
    stdenv.cc.cc.lib
    libGL
    glib
  ];
  python = pkgs."python${version}";
in
  pkgs.mkShell {
    nativeBuildInputs = nativeBuildInputs;

    buildInputs = [
      (python.withPackages (ps: with ps; [pip]))
    ];

    env = {
      LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath nativeBuildInputs}";
    };

    shellHook = ''
      # Tells pip to put packages into $PIP_PREFIX instead of the usual locations.
      # See https://pip.pypa.io/en/stable/user_guide/#environment-variables.
      export PIP_PREFIX="$(pwd)/_build/pip_packages";
      export PYTHONPATH="$PIP_PREFIX/${python.sitePackages}:$PYTHONPATH";
      export PATH="$PIP_PREFIX/bin:$PATH";
      unset SOURCE_DATE_EPOCH;

      export PYTHONWARNINGS=once

      printf "\n${bashColors.Green}Python ${python.version} environment loaded ${bashColors.Color_Off}\n";
    '';
  }
