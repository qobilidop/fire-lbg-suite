#!/usr/bin/env bash

host="$1"

opt=(-amvz --update --delete-after --filter ":- .gitignore" --exclude ".git")
src="$PROJECT_DIR/"
dst="$host:~/project/$PROJECT/"
cmd=(rsync "${opt[@]}" "$src" "$dst")

"${cmd[@]}" --dry-run
echo "Run?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) "${cmd[@]}"; break;;
        No ) exit;;
    esac
done
