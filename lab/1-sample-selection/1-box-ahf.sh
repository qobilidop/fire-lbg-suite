#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")"
env="tscc"
cmd="qsub job/tscc-box-ahf.sh"
env-run.sh "$env" "$cmd"
