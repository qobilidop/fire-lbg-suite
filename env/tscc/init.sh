#!/usr/bin/env bash
-e

# Link data dir
cd "$PROJECT_DIR"
mkdir -p ~/data/"$PROJECT_NAME"
ln -fns ~/data/"$PROJECT_NAME" data
