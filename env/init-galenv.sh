#!/usr/bin/env bash
set -e

if [ -z "$PROJECT_ROOT"]; then
    echo "PROJECT_ROOT is not set. Activate first:"
    echo ">>> source env/activate"
    exit
fi
cd "$PROJECT_ROOT"
source env/activate

echo "Initializing galenv"
"$GALENV_REPO/init.sh"
