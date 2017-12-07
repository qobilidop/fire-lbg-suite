#!/usr/bin/env bash

mkdir -p job
mkdir -p output

music_opt="--job-name=$RUN-music"
gizmo_opt="--job-name=$RUN-gizmo"

# Submit the music job if the initial condition file does not exist.
if ! [ -f "ics.dat" ]; then
    music_job_id=$(sbatch --parsable $music_opt music.job)
    gizmo_opt="--dependency=afterok:$music_job_id $gizmo_opt"
fi

# Submit the gizmo job if the last snapshot does not exist.
if ! [ -f "output/snapshot_190.hdf5" ]; then
    sbatch $gizmo_opt gizmo.job
fi
