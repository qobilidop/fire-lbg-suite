YT4_DIR ?= $(HOME)/.local/opt/yt-4.0

.PHONY: install
install:
	conda env update -f environment.yml -p env
	conda uninstall -y -p env yt
	env/bin/pip install -e $(YT4_DIR)
	env/bin/pip install -e .

.PHONY: install-lab
install-lab:
	conda env update -f environment-lab.yml -p env
