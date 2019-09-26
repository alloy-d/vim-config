#!/bin/sh
set -euxo pipefail

git submodule update --init
git clean -dff
