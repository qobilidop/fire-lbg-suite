#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")"
env="bridges"
cmd="sbatch job/bridges-box-ahf.sh"
env-run.sh "$env" "$cmd"
