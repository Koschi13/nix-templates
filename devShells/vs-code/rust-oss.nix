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
            continue.continue # Ollama coding assistant
            eamodio.gitlens
          ];
        })
      ];
    }
