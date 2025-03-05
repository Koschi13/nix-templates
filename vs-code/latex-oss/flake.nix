{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgsKoschi13.url = "github:Koschi13/nixpkgs/add-vscode-extensions.streetsidesoftware.code-spell-checker-german";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, nixpkgsKoschi13, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
          pkgsKoschi13 = import nixpkgsKoschi13 {
            inherit system;
          };

          codiumCodeAlias = pkgs.writeShellScriptBin "code" ''
            codium "$@"
          '';
        in
        with pkgs;
        {
          devShells.default = mkShell {
            buildInputs = [
              # Alias
              codiumCodeAlias

              # Ide
              (vscode-with-extensions.override {
                vscode = vscodium;
                # https://users.rust-lang.org/t/setting-up-rust-with-vs-code/76907
                vscodeExtensions = with vscode-extensions; [
                  catppuccin.catppuccin-vsc
                  catppuccin.catppuccin-vsc-icons
                  vscodevim.vim
                  jnoortheen.nix-ide
                  bbenoist.nix
                  james-yu.latex-workshop
                  continue.continue  # Ollama coding assistent
                  streetsidesoftware.code-spell-checker
                ] ++
                [
                  pkgsKoschi13.vscode-extensions.streetsidesoftware.code-spell-checker-german
                ];
              })
            ];
          };
        }
    );
}
