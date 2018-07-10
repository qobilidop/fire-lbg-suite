#!/usr/bin/env bash

remote="$1"

cd "$PROJECT_DIR"
rsync -amvz --update --delete-after --filter=':- .gitignore' . "$remote:~/project/$PROJECT"
