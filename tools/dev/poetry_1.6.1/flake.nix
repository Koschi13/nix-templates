{
  description = "Development environment for Python services";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgsPoetry.url = "github:nixos/nixpkgs/9957cd48326fe8dbd52fdc50dd2502307f188b0d";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    nixpkgsPoetry,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        # Source definitions
        pkgs = import nixpkgs {
          inherit system;
        };

        pkgsPoetry = import nixpkgsPoetry {
          inherit system;
        };

        # Aliases and functions (Aliases in the shellHook are not possible because of direnv, this fixes it)
        poetryAlias = pkgs.writeShellScriptBin "po" ''
          poetry "$@"
        '';
        poetryVimAlias = pkgs.writeShellScriptBin "pim" ''
          poetry run vim "$@"
        '';
        pytestWithIPythonAlias = pkgs.writeShellScriptBin "pytestpdb" ''
          poetry run pytest --pdb --pdbcls=IPython.terminal.debugger:TerminalPdb "$@"
        '';
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            # Python + Poetry
            pkgsPoetry.poetry

            # Aliases and function
            poetryAlias
            poetryVimAlias
            pytestWithIPythonAlias
          ];

          env = {
            # Configure poetry to use .virtualenv and copy all packages to it instead of relying on the system path
            POETRY_VIRTUALENVS_CREATE = "true";
            POETRY_VIRTUALENVS_IN_PROJECT = "true";
            POETRY_VIRTUALENVS_OPTIONS_ALWAYS_COPY = "true";
          };

          shellHook = ''
            printf "\nPoetry 1.6.1 enviriontment loaded \n";
          '';
        };
      }
    );
}
