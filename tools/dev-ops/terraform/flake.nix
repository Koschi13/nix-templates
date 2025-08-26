{
  description = "Terraform & Terragrunt";

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
          config.allowUnfree = true;
        };

        # Define which tools to install
        buildInputs = [
          pkgs.pre-commit
          pkgs.terragrunt

          pkgs.terraform
        ];
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = buildInputs ++ [pkgs.ansi];

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
