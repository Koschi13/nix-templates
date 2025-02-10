{
  description = "Environment providing tools needed for development";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    koschi13Nixpkgs.url = "github:Koschi13/nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    koschi13Nixpkgs,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        # Source definitions
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        pkgsKoschi13Nixpkgs = import koschi13Nixpkgs { inherit system; };

        # Define which tools to install
        buildInputs = [
          pkgs.pre-commit
          pkgs.terragrunt
          pkgs.terraform
          pkgs.go-task
          pkgs.nodejs_22  # For npx (formatting)

          # Custom packages
          pkgsKoschi13Nixpkgs.cloudfoundry-cli
        ];
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = buildInputs ++ [ pkgs.ansi ];

          shellHook = ''
            if [[ -f ".pre-commit-config.yaml" ]]; then
              printf "Install pre-commit hook...\n"
              pre-commit install
            else
              printf "No .pre-commit-config.yaml found, skipping installation of the hook!\n"
            fi

            printf "\nTools environment loaded \nThe following tools were installed:\n";
            for package in ${builtins.toString (builtins.map (pkg: pkg.name) buildInputs)}; do
              printf -- "- $package\n"
            done
          '';
        };
      }
    );
}
