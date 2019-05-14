#!/usr/bin/env bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")"

job_candidate_selection="$(qsub candidate-selection.sh)"
echo "$job_candidate_selection"
./../script/select-sample.py
job_sample_plot="$(qsub -W depend=afterok:"$job_candidate_selection" sample-plot.sh)"
echo "$job_sample_selection"
job_zoom_region="$(qsub -W depend=afterok:"$job_candidate_selection" zoom-region.sh)"
echo "$job_zoom_region"
