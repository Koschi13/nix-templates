{
  description = "My personal Nix flake templates";

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
        formatter = pkgs.alejandra;
      }
    )
    // {
      templates = rec {
        default = empty;

        empty = {
          path = ./templates/empty;
          description = "An empty flake to start with.";
        };
      };
    };
}
