{
  description = "Development environment for Java services";

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
        java = pkgs.zulu11;
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            java

            # Tools
            pkgs.gradle
            pkgs.maven
          ];
          shellHook = ''
            printf "\nJava environment loaded \n";
          '';
        };
      }
    );
}
