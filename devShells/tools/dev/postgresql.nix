{
  pkgs,
  version,
  bashColors,
}: let
  postgresql = pkgs."postgresql_${version}";
in
  pkgs.mkShell {
    buildInputs = [
      # Python test deps
      postgresql
      postgresql.lib
      postgresql.pg_config
    ];
    # Extent the LD_LIBRARY_PATH with the binaries needed by python, so python can find them
    LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath [postgresql.lib]}";

    shellHook = ''
      printf "\n${bashColors.Green}PostgreSQL ${postgresql.version} envrionment loaded ${bashColors.Color_Off}\n";
    '';
  }
