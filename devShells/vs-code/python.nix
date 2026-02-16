{pkgsUnfree}:
with pkgsUnfree;
  mkShell {
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
          charliermarsh.ruff
          # kevinrose.vsc-python-indent  # TODO: create extension
          ms-python.debugpy
          ms-python.python
          ms-python.vscode-pylance
          njpwerner.autodocstring
          # GitHub
          github.copilot-chat
          github.vscode-pull-request-github
          # Utility
          formulahendry.code-runner
          ms-vsliveshare.vsliveshare
          streetsidesoftware.code-spell-checker
          eamodio.gitlens
        ];
      })
    ];
  }
