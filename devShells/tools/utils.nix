{
  pkgs,
  bashColors,
}: let
  gitSemVerAlias = pkgs.writeShellScriptBin "git-semver" ''
    docker run --rm -v `pwd`:/git-semver ghcr.io/mdomke/git-semver:6@sha256:6477fd91cff73429a1ccf8238e0510b509b241e3dba00edfa282951b95177aad
  '';
  gitVerAlias = pkgs.writeShellScriptBin "git-ver" ''
    docker run --rm -v `pwd`:/git-semver ghcr.io/mdomke/git-semver:6@sha256:6477fd91cff73429a1ccf8238e0510b509b241e3dba00edfa282951b95177aad | sed 's/+/-/'
  '';
in
  pkgs.mkShell {
    buildInputs = [
      # Aliases and function
      gitSemVerAlias
      gitVerAlias
      pkgs.pre-commit
    ];
    shellHook = ''
      if [[ -f ".pre-commit-config.yaml" ]]; then
        printf "${bashColors.Blue}Install pre-commit hook...${bashColors.Color_Off}\n"
        pre-commit install
      else
        printf "${bashColors.Red}No .pre-commit-config.yaml found, skipping installation of the hook!${bashColors.Color_Off}\n"
      fi

      printf "\n${bashColors.Green}Utils environment loaded ${bashColors.Color_Off}\n";
    '';
  }
