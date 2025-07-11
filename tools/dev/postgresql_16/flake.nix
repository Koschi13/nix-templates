{
  description = "Development environment for PostgreSQL 16";

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
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            # Python test deps
            pkgs.postgresql_16
            pkgs.postgresql_16.lib
          ];
          # Extent the LD_LIBRARY_PATH with the binaries needed by python, so python can find them
          LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath [pkgs.postgresql_16.lib]}";

          shellHook = ''
            printf "\nPostgreSQL 16 envrionment loaded \n";
          '';
        };
      }
    );
}
