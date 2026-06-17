{
  pkgs,
  bashColors,
}: let
  # Aliases and functions (Aliases in the shellHook are not possible because of direnv, this fixes it)
  uvVimAlaias = pkgs.writeShellScriptBin "uim" ''
    uv run vim "$@"
  '';
  pytestWithIPythonAlias = pkgs.writeShellScriptBin "pytestpdb" ''
    uv run pytest --pdb --pdbcls=IPython.terminal.debugger:TerminalPdb "$@"
  '';
in
  pkgs.mkShell {
    buildInputs = [
      pkgs.uv
      pkgs.hatch

      # Aliases and function
      uvVimAlaias
      pytestWithIPythonAlias
    ];

    env = {
    };

    shellHook = ''
      printf "${bashColors.Purple}Setting up uv virtual environment:${bashColors.Color_Off}\n"
      uv sync

      printf "\n${bashColors.Green}uv ${pkgs.uv.version} enviriontment loaded ${bashColors.Color_Off}\n";
    '';
  }
