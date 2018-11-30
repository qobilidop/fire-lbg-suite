.PHONY: all
all: sample.csv sample-selection.png
all: zoom-region sample-location.png

sample.csv sample-selection.png: candidate.csv
	./script/select-sample.py \
	--candidate candidate.csv \
	--sample sample.csv \
	--plot sample-selection.png

zoom-region sample-location.png: sample.csv
	mkdir -p zoom-region
	./script/trace-zoom-region.py \
	--ic $(IC) \
	--snapshot $(SNAPSHOT) \
	--sample sample.csv \
	--radius 3 \
	--zoom_region_dir zoom-region \
	--plot sample-location.png
