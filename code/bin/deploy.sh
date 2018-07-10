#!/usr/bin/env bash

host="$1"

opt=(-amvz --update --delete-after --filter ":- .gitignore")
src="$PROJECT_DIR/"
dst="$host:~/project/$PROJECT/"

rsync --dry-run "${opt[@]}" "$src" "$dst"
echo "Run?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) rsync "${opt[@]}" "$src" "$dst"; break;;
        No ) exit;;
    esac
done
