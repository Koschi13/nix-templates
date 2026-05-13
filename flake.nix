{
  description = "My personal Nix flake templates";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-at-poetry-1_6_1.url = "github:nixos/nixpkgs/9957cd48326fe8dbd52fdc50dd2502307f188b0d";
    nixpkgs-at-poetry-2_2_1.url = "github:nixos/nixpkgs/231bb98e6b4411bad31de73a463bd557aa83b37e";
    nixpkgs-at-terraform-1_10_5.url = "github:nixos/nixpkgs/0bd7f95e4588643f2c2d403b38d8a2fe44b0fc73";
    nixpkgs-at-terraform-1_5_7.url = "github:nixos/nixpkgs/4ab8a3de296914f3b631121e9ce3884f1d34e1e5";
    nixpkgs-at-python-3_11_15.url = "github:nixos/nixpkgs/b96b24b501d17a0637bb04206094794da956932d";
    nixpkgs-koschi13.url = "github:Koschi13/nixpkgs";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
    nixpkgs-at-poetry-1_6_1,
    nixpkgs-at-poetry-2_2_1,
    nixpkgs-at-python-3_11_15,
    nixpkgs-at-terraform-1_10_5,
    nixpkgs-at-terraform-1_5_7,
    nixpkgs-koschi13,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
        pkgsUnfree = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        pkgsUnfreeKoschi13 = import nixpkgs-koschi13 {
          inherit system;
          config.allowUnfree = true;
        };

        #######################################################################
        # Python
        #######################################################################
        # Python 3.11 requires a locked hash, since recent versions of sphinx
        # do not support 3.11 anymore
        pkgs-at-python-3_11_15 = import nixpkgs-at-python-3_11_15 {
          inherit system;
        };

        #######################################################################
        # Poetry
        #######################################################################
        pkgs-at-poetry-1_6_1 = import nixpkgs-at-poetry-1_6_1 {
          inherit system;
        };
        pkgs-at-poetry-2_2_1 = import nixpkgs-at-poetry-2_2_1 {
          inherit system;
        };

        #######################################################################
        # Terraform
        #######################################################################
        pkgsUnfree-at-terraform-1_10_5 = import nixpkgs-at-terraform-1_10_5 {
          inherit system;
          config.allowUnfree = true;
        };
        pkgsUnfree-at-terraform-1_5_7 = import nixpkgs-at-terraform-1_5_7 {
          inherit system;
          config.allowUnfree = true;
        };

        #######################################################################
        # Utils
        #######################################################################
        bashColors = import ./utils/bash_colors.nix;
      in {
        formatter = pkgs.alejandra;
        devShells = {
          #####################################################################
          # Languages
          #####################################################################
          languages_node-20-yarn = import ./devShells/languages/node-20-yarn.nix {inherit pkgs bashColors;};

          languages_java11 = import ./devShells/languages/java.nix {
            inherit pkgs bashColors;
            version = "11";
          };
          languages_java21 = import ./devShells/languages/java.nix {
            inherit pkgs bashColors;
            version = "21";
          };
          languages_java24 = import ./devShells/languages/java.nix {
            inherit pkgs bashColors;
            version = "24";
          };

          languages_python311 = import ./devShells/languages/python.nix {
            inherit bashColors;
            pkgs = pkgs-at-python-3_11_15;
            version = "311";
          };
          languages_python312 = import ./devShells/languages/python.nix {
            inherit pkgs bashColors;
            version = "312";
          };
          languages_python313 = import ./devShells/languages/python.nix {
            inherit pkgs bashColors;
            version = "313";
          };
          languages_python314 = import ./devShells/languages/python.nix {
            inherit pkgs bashColors;
            version = "314";
          };

          #####################################################################
          # Tools - Dev
          #####################################################################
          tools_utils = import ./devShells/tools/utils.nix {inherit pkgs bashColors;};

          #####################################################################
          # Tools - Dev
          #####################################################################
          tools_dev_postgresql-16 = import ./devShells/tools/dev/postgresql.nix {
            inherit pkgs bashColors;
            version = "16";
          };
          tools_dev_poetry = import ./devShells/tools/dev/poetry.nix {inherit pkgs bashColors;};
          tools_dev_poetry-1_6_1 = import ./devShells/tools/dev/poetry.nix {
            inherit bashColors;
            pkgs = pkgs-at-poetry-1_6_1;
          };
          tools_dev_poetry-2_2_1 = import ./devShells/tools/dev/poetry.nix {
            inherit bashColors;
            pkgs = pkgs-at-poetry-2_2_1;
          };
          tools_dev_uv = import ./devShells/tools/dev/uv.nix {
            inherit bashColors;
            pkgs = pkgs;
          };

          #####################################################################
          # Tools - Dev-Ops
          #####################################################################
          tools_dev-ops_cloudfoundry = import ./devShells/tools/dev-ops/cloudfoundry.nix {inherit pkgsUnfree pkgsUnfreeKoschi13 bashColors;};
          tools_dev-ops_terraform = import ./devShells/tools/dev-ops/terraform.nix {
            inherit pkgsUnfree bashColors;
            pkgsUnfreeTerraform = pkgsUnfree;
          };
          tools_dev-ops_terraform-1_10_5 = import ./devShells/tools/dev-ops/terraform.nix {
            inherit pkgsUnfree bashColors;
            pkgsUnfreeTerraform = pkgsUnfree-at-terraform-1_10_5;
          };
          tools_dev-ops_terraform-1_5_7 = import ./devShells/tools/dev-ops/terraform.nix {
            inherit pkgsUnfree bashColors;
            pkgsUnfreeTerraform = pkgsUnfree-at-terraform-1_5_7;
          };

          #####################################################################
          # VS-Code
          #####################################################################
          vs-code_java = import ./devShells/vs-code/java.nix {inherit pkgsUnfree;};
          vs-code_latex-oss = import ./devShells/vs-code/latex-oss.nix {inherit pkgs;};
          vs-code_python = import ./devShells/vs-code/python.nix {inherit pkgsUnfree bashColors;};
          vs-code_rust = import ./devShells/vs-code/rust.nix {inherit pkgsUnfree;};
          vs-code_rust-oss = import ./devShells/vs-code/rust-oss.nix {inherit pkgs;};
        };
      }
    )
    // {
      templates = rec {
        default = empty;

        empty = {
          path = ./templates/empty;
          description = "An empty flake to start with.";
        };

        rust-openssl = {
          path = ./templates/rust-openssl;
          description = "A flake for Rust development with OpenSSL.";
        };
      };
    };
}
