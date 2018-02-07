#!/usr/bin/env bash

mkdir -p job
mkdir -p output

# Submit the music job if the initial condition file does not exist.
if ! [ -f "ic/ics.dat" ]; then
    music_job_id=$(sbatch --parsable ic/music.job)
    gizmo_opt="--dependency=afterok:$music_job_id $gizmo_opt"
fi

# Submit the gizmo job if not finished.
if ! [ -f "output/finished" ]; then
    sbatch $gizmo_opt gizmo.job
fi
