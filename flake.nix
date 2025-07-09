{
  description = "My personal Nix flake templates";

  outputs = self: {
    templates = rec {
      default = empty;

      empty = {
        path = ./templates/empty;
        description = "An empty flake to start with.";
      };
    };
  };
}
