# My personal nix flakes & templates for development environments

## DevShells

### Usage

If you're using `direnv` is as easy as this:

```shell
use flake 'github:Koschi13/nix-templates#<name-of-devshell>'
```

You can even chain then to pull in multiple things (e.g.: `tools/dev-ops/cloudfoundry` +
`languages/python311` + `tools/dev/postgresql-16`):

```shell
use flake 'github:Koschi13/nix-templates#tools_dev-ops_cloudfoundry'
use flake 'github:Koschi13/nix-templates#languages_python311'
use flake 'github:Koschi13/nix-templates#tools_dev_postgresql-16'
```

### Combining environment variables

When using devShells, each loaded flake has it's own environment. Therefore,
defining the same environment variable twice will only contain the value of the
last flake loaded.
To fix this you must export the variables via your `.envrc` like this (in the
example of `LD_LIBRARY_PATH`):

```shell
use flake 'github:Koschi13/nix-templates#languages_python311'
export PYTHON_LD_LIBRARY_PATH="$LD_LIBRARY_PATH"
use flake 'github:Koschi13/nix-templates#tools_dev_postgresql-16'
export LD_LIBRARY_PATH="$PYTHON_LD_LIBRARY_PATH:$LD_LIBRARY_PATH"
```

### Development

For local testing run:

```shell
nix develop .#<name-of-devshell>
```

`<name-of-devshell>` can be obtained by looking at the `flake.nix` or running
`nix flake show`
