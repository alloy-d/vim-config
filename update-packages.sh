#!/bin/bash
set -euxo pipefail

git submodule foreach git fetch origin
git submodule foreach git checkout origin/HEAD
git submodule foreach git submodule update --init --recursive
