# My personal nix flakes & templates for development environments

## Usage

If you're using `direnv` is as easy as this:

```shell
use flake 'github:Koschi13/nix-templates?dir=<the-flake-you-want-to-use>'
```

You can even chain then to pull in multiple things (e.g.: `dev-ops` +
`python311_poetry_postgresql`):
```shell
use flake 'github:Koschi13/nix-templates?dir=tools/dev-ops'
use flake 'github:Koschi13/nix-templates?dir=languages/python311_poetry_postgresql'
```


