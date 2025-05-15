{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
        with pkgs; {
          devShells.default = mkShell {
            buildInputs = [
              ruff

              (vscode-with-extensions.override {
                # https://users.rust-lang.org/t/setting-up-rust-with-vs-code/76907
                vscodeExtensions = with vscode-extensions; [
                  # Themes
                  catppuccin.catppuccin-vsc
                  catppuccin.catppuccin-vsc-icons
                  # Editor
                  vscodevim.vim
                  # Toml
                  tamasfe.even-better-toml
                  # Nix
                  bbenoist.nix
                  jnoortheen.nix-ide
                  # Python
                  ms-python.python
                  ms-python.debugpy
                  charliermarsh.ruff
                  # Utility
                  formulahendry.code-runner
                  ms-vsliveshare.vsliveshare
                ];
              })
            ];
          };
        }
    );
}
