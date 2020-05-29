#!/bin/bash
set -euxo pipefail

git submodule foreach git fetch origin
git submodule foreach git checkout origin/master
