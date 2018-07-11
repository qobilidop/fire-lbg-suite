#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")"
for code in */; do
    echo "Install $code"
    ./"$code"/install.sh
done
