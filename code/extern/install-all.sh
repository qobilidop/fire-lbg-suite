#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

# LOCAL_CODES is a space-separated string. Here we don't use "" intentionally.
for code in $LOCAL_CODES; do
    echo "Install $code"
    ./"$code"/install.sh
done
