{
  description = "Terraform & Terragrunt";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    terraformNixpkgs.url = "github:nixos/nixpkgs/4ab8a3de296914f3b631121e9ce3884f1d34e1e5";  # 1.5.7
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
        pkgsTerraformNixpkgs = import terraformNixpkgs {inherit system;};

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
