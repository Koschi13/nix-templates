{pkgs}: let
  codiumCodeAlias = pkgs.writeShellScriptBin "code" ''
    codium "$@"
  '';
in
  with pkgs;
    mkShell {
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
            continue.continue # Ollama coding assistent
            streetsidesoftware.code-spell-checker
          ];
        })
      ];
    }
