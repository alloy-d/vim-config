#!/bin/sh
set -euxo pipefail

git submodule sync
git submodule update --init
git clean -dff
