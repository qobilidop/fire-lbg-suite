.PHONY: all
all: sample.csv sample-selection.png sample-location.png

sample.csv sample-selection.png: candidate.csv
	./script/select-sample.py \
	--candidate candidate.csv \
	--sample sample.csv \
	--plot sample-selection.png

sample-location.png: candidate.csv sample.csv
	./script/plot-sample-location.py \
	--snapshot $(SNAPSHOT) \
	--sample sample.csv \
	--plot sample-location.png
