{
  description = "My personal Nix flake templates";

  outputs = self: rec {
    templates = rec {
      default = empty;

      empty = {
        path = ./empty;
        description = "An empty flake to start with.";
      };

      rust-vs-code = {
        path = ./rust-vs-code;
        description = "Rust development environment with Rust version defined by a rust-toolchain.toml file and VS-Code configured.";
      };
    };
  };
}
