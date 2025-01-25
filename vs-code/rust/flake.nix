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
            config.allowUnfree = true;
          };
        in
        with pkgs;
        {
          devShells.default = mkShell {
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
                  formulahendry.code-runner
                  ms-vsliveshare.vsliveshare
                ];
              })
            ];
          };
        }
    );
}
