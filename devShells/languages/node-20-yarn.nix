{
  pkgs,
  bashColors,
}: let
in
  pkgs.mkShell {
    buildInputs = with pkgs; [
      yarn
      nodejs_20
    ];

    shellHook = ''
      printf "\n${bashColors.Green}JS ${pkgs.nodejs_20.version} environment loaded ${bashColors.Color_Off}\n";
    '';
  }
