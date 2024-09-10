{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
        let
          overlays = [ (import rust-overlay) ];
          pkgs = import nixpkgs {
            inherit system overlays;
            config.allowUnfree = true;
          };

          rustToolchain = pkgs.pkgsBuildHost.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
        in
        with pkgs;
        {
          devShells.default = mkShell {
            nativeBuildInputs = [
              # Rust
              rustToolchain
              pkg-config

              # IDE deps
              gcc
            ];

            buildInputs = [
              # Ide
              (vscode-with-extensions.override {
                # https://users.rust-lang.org/t/setting-up-rust-with-vs-code/76907
                vscodeExtensions = with vscode-extensions; [
                  bbenoist.nix
                  rust-lang.rust-analyzer
                  vadimcn.vscode-lldb
                  catppuccin.catppuccin-vsc
                  catppuccin.catppuccin-vsc-icons
                  vscodevim.vim
                  tamasfe.even-better-toml
                  jnoortheen.nix-ide
                  ms-vsliveshare.vsliveshare
                  formulahendry.code-runner
                ];
              })

              # Build deps
              openssl
              clang
              lld
              postgresql
            ];

            LD_LIBRARY_PATH = lib.makeLibraryPath [ openssl ];

            shellHook = ''
              export PATH="$HOME/.cargo/bin:$PATH"
            '';
          };
        }
    );
}
