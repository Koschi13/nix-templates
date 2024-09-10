{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        with pkgs;
        {
          devShells.default = mkShell {
            nativeBuildInputs = [];

            buildInputs = [];

            LD_LIBRARY_PATH = lib.makeLibraryPath [  ];

            shellHook = ''
            echo "Hello, I am empty."
            '';
          };
        }
    );
}
