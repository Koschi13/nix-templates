{pkgsUnfree}:
with pkgsUnfree;
  mkShell {
    buildInputs = [
      (vscode-with-extensions.override {
        # https://users.rust-lang.org/t/setting-up-rust-with-vs-code/76907
        vscodeExtensions = with vscode-extensions; [
          # Themes
          catppuccin.catppuccin-vsc
          catppuccin.catppuccin-vsc-icons
          # Editor
          vscodevim.vim
          # Nix
          bbenoist.nix
          jnoortheen.nix-ide
          # Java
          redhat.java
          vscjava.vscode-gradle
          redhat.vscode-xml
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
