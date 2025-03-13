#!/usr/bin/env bash
shopt -s globstar

GIT_ROOT=$(git rev-parse --show-toplevel)

pushd $GIT_ROOT

for i in **/flake.nix; do
  d=$(dirname $i)

  pushd $d
  nix flake update
  popd
done

popd
