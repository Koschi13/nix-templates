{
  pkgs,
  version,
bashColors,
}: let
  java = pkgs."zulu${version}";
in
  pkgs.mkShell {
    buildInputs = [
      java

      # Tools
      pkgs.gradle
      pkgs.maven
    ];
    shellHook = ''
      printf "\n${bashColors.Green}Java ${java.version} environment loaded ${bashColors.Color_Off}\n";
    '';
  }
