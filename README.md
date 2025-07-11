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

## Combining environment variables

When using devshells, each loaded flake has it's own environment. Therefore,
defining the same environment variable twice will only contain the value of the
last flake loaded.
To fix this you must export the variables via your `.envrc` like this (in the
example of `LD_LIBRARY_PATH`):

```shell
use flake 'github:Koschi13/nix-templates?ref=test/split-python-and-poetry&dir=languages/python311'
export PYTHON_LD_LIBRARY_PATH="$LD_LIBRARY_PATH"
use flake 'github:Koschi13/nix-templates?dir=tools/dev/postgresql_16'
export LD_LIBRARY_PATH="$PYTHON_LD_LIBRARY_PATH:$LD_LIBRARY_PATH"
```
