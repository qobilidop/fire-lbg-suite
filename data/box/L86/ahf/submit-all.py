from pathlib import Path

from toolbox.env import repo_dir
from libdil.job import BridgesJob


ahf_dir = Path(__file__).resolve().parent
job_dir = ahf_dir / 'job'

# Do halo finding for snapshots at z=2 and z=1
for snap_num in [5, 6]:
    snap_dir = f'snapdir_{snap_num:03d}'
    snap_prefix = f'snapshot_{snap_num:03d}'
    snap_file = (repo_dir / 'data/box/L86/output' / snap_dir /
                 f'{snap_prefix}.0.hdf5')

    # Job AHF setup
    job_ahf_setup = BridgesJob(
        f'ahf-setup-{snap_num:03d}',
        f'ahf-setup.py -s {snap_file} -w {ahf_dir}',
        'RM-small', nodes=1, tasks=1, cpus=28, time='1:00:00',
        job_dir=job_dir
    )
    if not (ahf_dir / f'{snap_prefix}.input').exists():
        job_ahf_setup.create(force=True)
        id_ahf_setup = job_ahf_setup.submit()
    else:
        id_ahf_setup = None

    # Job AHF run
    job_ahf_run = BridgesJob(
        f'ahf-run-{snap_num:03d}',
        f'AHF-dmo-mpi {snap_prefix}.input',
        'RM', nodes=4, tasks=4, cpus=7, time='1:00:00', mpi=True,
        run_dir=ahf_dir, job_dir=job_dir
    )
    if not (ahf_dir / f'{snap_prefix}.parameter').exists():
        job_ahf_run.create(force=True)
        id_ahf_run = job_ahf_run.submit(depend=[id_ahf_setup])
    else:
        id_ahf_run = None
