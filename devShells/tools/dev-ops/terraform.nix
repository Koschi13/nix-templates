{
  pkgsUnfree,
  pkgsUnfreeTerraform,
  bashColors,
}: let
  buildInputs = [
    pkgsUnfree.terragrunt
    pkgsUnfreeTerraform.terraform
  ];
in
  pkgsUnfree.mkShell {
    buildInputs = buildInputs ++ [pkgsUnfree.ansi];

    shellHook = ''
      printf "\n${bashColors.Green}Terraform environment loaded \n${bashColors.Purple}The following tools were installed:${bashColors.Blue}\n";
      for package in ${toString (map (pkg: pkg.name) buildInputs)}; do
        printf -- "- $package\n"
      done
      printf "${bashColors.Color_Off}";
    '';
  }
