.PHONY: deploy

deploy:
	rsync -avz --delete-after --filter=':- .gitignore' . bridges:~/scratch/z2f2-run
