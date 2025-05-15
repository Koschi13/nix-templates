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
        };

        codiumCodeAlias = pkgs.writeShellScriptBin "code" ''
          codium "$@"
        '';
      in
        with pkgs; {
          devShells.default = mkShell {
            buildInputs = [
              # Alias
              codiumCodeAlias

              # Ide
              (vscode-with-extensions.override {
                vscode = vscodium;
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
                  # Rust
                  rust-lang.rust-analyzer
                  vadimcn.vscode-lldb
                  # Utility
                  formulahendry.code-runner
                  visualstudioexptteam.vscodeintellicode
                  continue.continue # Ollama coding assistent
                ];
              })
            ];
          };
        }
    );
}
