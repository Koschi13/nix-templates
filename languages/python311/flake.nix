{
  description = "Development environment for Python services";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        # Source definitions
        pkgs = import nixpkgs {
          inherit system;
        };

        # Nix aliases
        python = pkgs.python311;

        nativeBuildInputs = with pkgs; [
          stdenv.cc.cc.lib
          libGL
          glib
        ];
      in {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = nativeBuildInputs;

          buildInputs = [
            (python.withPackages (ps: with ps; [pip]))

            # dev tools
            pkgs.pre-commit
          ];

          env = {
            # Tells pip to put packages into $PIP_PREFIX instead of the usual locations.
            # See https://pip.pypa.io/en/stable/user_guide/#environment-variables.
            PIP_PREFIX = "$(pwd)/_build/pip_packages";
            PYTHONPATH = "$PIP_PREFIX/${python.sitePackages}:$PYTHONPATH";

            LD_LIBRARY_PATH = "${pkgs.lib.strings.makeLibraryPath nativeBuildInputs}";
          };

          shellHook = ''
            unset SOURCE_DATE_EPOCH;

            if [[ -f ".pre-commit-config.yaml" ]]; then
              printf "Install pre-commit hook...\n"
              pre-commit install
            else
              printf "No .pre-commit-config.yaml found, skipping installation of the hook!\n"
            fi

            printf "\nPython 3.11 environment loaded \n";
          '';
        };
      }
    );
}
