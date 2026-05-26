{
  pkgs,
  bashColors,
  version,
}: let
  node = pkgs."nodejs_${version}";
in
  pkgs.mkShell {
    buildInputs = with pkgs;
      [
        yarn
      ]
      ++ [node];

    shellHook = ''
      printf "\n${bashColors.Green}JS ${node.version} environment loaded ${bashColors.Color_Off}\n";
    '';
  }
