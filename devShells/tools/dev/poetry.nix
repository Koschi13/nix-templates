{
  pkgs,
  bashColors,
}: let
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
in
  pkgs.mkShell {
    buildInputs = [
      pkgs.poetry

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
      printf "\n${bashColors.Green}Poetry ${pkgs.poetry.version} enviriontment loaded ${bashColors.Color_Off}\n";
    '';
  }
