{
  description = "Utility tools and functions for development.";

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

        gitSemVerAlias = pkgs.writeShellScriptBin "git-semver" ''
          docker run --rm -v `pwd`:/git-semver ghcr.io/mdomke/git-semver:6@sha256:6477fd91cff73429a1ccf8238e0510b509b241e3dba00edfa282951b95177aad
        '';
        gitVerAlias = pkgs.writeShellScriptBin "git-ver" ''
          docker run --rm -v `pwd`:/git-semver ghcr.io/mdomke/git-semver:6@sha256:6477fd91cff73429a1ccf8238e0510b509b241e3dba00edfa282951b95177aad | sed 's/+/-/'
        '';
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            # Aliases and function
            gitSemVerAlias
            gitVerAlias
          ];
          shellHook = ''
            printf "\nUtils environment loaded \n";
          '';
        };
      }
    );
}
