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
        python = pkgs.python39;

        # Aliases and functions (Aliases in the shellHook are not possible because of direnv, this fixes it)
        poetryAlias = pkgs.writeShellScriptBin "po" ''
          poetry "$@"
        '';
        pytestWithIPythonAlias = pkgs.writeShellScriptBin "pytestpdb" ''
          poetry run pytest --pdb --pdbcls=IPython.terminal.debugger:TerminalPdb "$@"
        '';
        poetryVimAlias = pkgs.writeShellScriptBin "pim" ''
          poetry run vim "$@"
        '';
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            # Python + Poetry
            python
            pkgs.poetry

            # Python run deps
            pkgs.stdenv.cc.cc.lib
            pkgs.libGL
            pkgs.glib.out

            # Aliases and function
            poetryAlias
            pytestWithIPythonAlias
            poetryVimAlias
          ];
          # Extent the LD_LIBRARY_PATH with the binaries needed by python, so python can find them
          LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath [pkgs.stdenv.cc.cc.lib pkgs.libGL pkgs.glib.out]}:$LD_LIBRARY_PATH";

          shellHook = ''
            # Tells pip to put packages into $PIP_PREFIX instead of the usual locations.
            # See https://pip.pypa.io/en/stable/user_guide/#environment-variables.
            export PIP_PREFIX="$(pwd)/_build/pip_packages";
            export PYTHONPATH="$PIP_PREFIX/${python.sitePackages}:$PYTHONPATH";
            export PATH="$PIP_PREFIX/bin:$PATH";
            unset SOURCE_DATE_EPOCH;

            # Configure poetry to use .virtualenv and copy all packages to it instead of relying on the system path
            export POETRY_VIRTUALENVS_CREATE="true";
            export POETRY_VIRTUALENVS_IN_PROJECT="true";
            export POETRY_VIRTUALENVS_OPTIONS_ALWAYS_COPY="true";

            printf "\nPython environment loaded \n";
          '';
        };
      }
    );
}
