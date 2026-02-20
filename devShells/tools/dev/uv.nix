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

      # Aliases and function
      uvVimAlaias
      pytestWithIPythonAlias
    ];

    env = {
    };

    shellHook = ''
      if [ "$SHELL" ~= "zsh" ]; then
        printf "${bashColors.Purple}Installing ZSH shell completion...${bashColors.Color_Off}\n"
        if [ ! -f /tmp/.zshrc-uv ]; then
          echo 'eval "$(uv generate-shell-completion zsh)"' > /tmp/.zshrc-uv
        fi
          
        if [ ! -f /tmp/.zshrc-uvx ]; then
          echo 'eval "$(uvx generate-shell-completion zsh)"' > /tmp/.zshrc-uvx
        fi
        
        . /tmp/.zshrc-uv
        . /tmp/.zshrc-uvx
      else
        printf "${bashColors.Red}Skipping ZSH shell completion!${bashColors.Color_Off}\n"
      fi

      printf "${bashColors.Purple}Setting up uv virtual environment:${bashColors.Color_Off}\n"
      uv sync

      printf "\n${bashColors.Green}UV ${pkgs.uv.version} enviriontment loaded ${bashColors.Color_Off}\n";
    '';
  }
