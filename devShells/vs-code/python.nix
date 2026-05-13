{
  pkgsUnfree,
  bashColors,
}: let
  vscodeExtensions = with pkgsUnfree.vscode-extensions;
    [
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
      ms-python.debugpy
      ms-python.python
      ms-python.vscode-pylance
      njpwerner.autodocstring
      # GitHub
      github.vscode-pull-request-github
      # Utility
      formulahendry.code-runner
      ms-vsliveshare.vsliveshare
      streetsidesoftware.code-spell-checker
      eamodio.gitlens
      # AI
      github.copilot-chat
    ]
    ++ pkgsUnfree.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "vsc-python-indent";
        publisher = "kevinrose";
        version = "1.21.0";
        # TODO: can we move this to the flake inputs?
        sha256 = "sha256-SvJhVG8sofzV0PebZG4IIORX3AcfmErDQ00tRF9fk/4=";
      }
    ]
    ++ pkgsUnfree.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "geminicodeassist";
        publisher = "google";
        version = "2.81.0";
        # TODO: can we move this to the flake inputs?
        sha256 = "sha256-QX0YPHPQPYl2LRHGmXTL146Kxty/YMlvRo503eWEMpg=";
      }
    ];

  vscodeExtensionsString =
    pkgsUnfree.lib.strings.concatMapStrings (
      x: x.vscodeExtUniqueId + "\n"
    ) (
      pkgsUnfree.lib.lists.sort (
        a: b: a.vscodeExtUniqueId < b.vscodeExtUniqueId
      )
      vscodeExtensions
    );
in
  with pkgsUnfree;
    mkShell {
      buildInputs = [
        ruff

        (vscode-with-extensions.override {
          # https://users.rust-lang.org/t/setting-up-rust-with-vs-code/76907
          inherit vscodeExtensions;
        })
      ];

      shellHook = ''
        printf "\n${bashColors.Green}VS-Code Python environment loaded ${bashColors.Color_Off}\n";
        printf "The following extensions are available:\n${bashColors.Blue}${vscodeExtensionsString}${bashColors.Color_Off}\n";
      '';
    }
