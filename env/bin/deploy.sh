#!/usr/bin/env bash
set -e

src="$PROJECT_ROOT/"
dst="$1/"
opt=(-aKmvz --update --delete-after --filter ":- .gitignore" --exclude ".git")

cmd=(rsync "${opt[@]}" "$src" "$dst")

echo "${cmd[*]}"
"${cmd[@]}" --dry-run
echo "Run?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) "${cmd[@]}"; break;;
        No ) exit;;
    esac
done
