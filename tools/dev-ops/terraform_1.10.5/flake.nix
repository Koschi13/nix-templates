{
  description = "Terraform & Terragrunt";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    terraformNixpkgs.url = "github:nixos/nixpkgs/0bd7f95e4588643f2c2d403b38d8a2fe44b0fc73"; # 1.10.5
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    terraformNixpkgs,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        # Source definitions
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        pkgsTerraformNixpkgs = import terraformNixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        # Define which tools to install
        buildInputs = [
          pkgs.pre-commit
          pkgs.terragrunt

          pkgsTerraformNixpkgs.terraform
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
