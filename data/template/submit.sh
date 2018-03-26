#!/usr/bin/env bash

mkdir -p output

# Submit the music job if the initial condition file does not exist.
if ! [ -f "ic/ics.dat" ]; then
    music_job_id=$(sbatch --parsable job/music.sh)
    gizmo_opt="--dependency=afterok:$music_job_id $gizmo_opt"
fi

# Submit the gizmo job if not finished yet.
if ! [ -f "output/finished" ]; then
    sbatch $gizmo_opt job/gizmo.sh
fi
