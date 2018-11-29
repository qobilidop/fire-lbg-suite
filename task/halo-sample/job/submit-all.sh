#!/usr/bin/env bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")"

job_candidate_selection="$(qsub candidate-selection.sh)"
echo "$job_candidate_selection"
job_sample_selection="$(qsub -W depend=afterok:"$job_candidate_selection" sample-selection.sh)"
echo "$job_sample_selection"
