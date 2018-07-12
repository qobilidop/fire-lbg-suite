#!/usr/bin/env bash
set -e

check-local-env tscc

ahf_setup=$(qsub tscc-job/ahf-setup.sh)
echo "$ahf_setup"
ahf_run=$(qsub -W depend=afterok:"$ahf_setup" tscc-job/ahf-run.sh)
echo "$ahf_run"
