"""Utilities for submitting jobs on Bridges."""
from pathlib import Path
import subprocess as sp

from .env import job_dir
from .env import repo_dir


header_template = f"""\
#!/usr/bin/env bash
#SBATCH -J {{name}}
#SBATCH -p {{partition}}
#SBATCH -N {{nodes}}
#SBATCH -c {{ncpus}}
#SBATCH -t {{time}}
#SBATCH -o {{name}}.log
#SBATCH --export=ALL
set -e

cd {repo_dir}
source env/activate
cd {{run_dir}}
"""


class BridgesJob(object):
    cores_per_node = 28

    def __init__(self, name, cmd,
                 partition='RM', nodes=1, ncpus=1, time='4:00:00',
                 mpi=False, run_dir='.', job_dir='data/job'):
        self.name = name
        self.cmd = cmd
        self.partition = partition
        self.nodes = nodes
        assert self.cores_per_node % ncpus == 0
        self.ncpus = ncpus
        self.time = time
        self.mpi = mpi
        self.run_dir = (repo_dir / run_dir).resolve()
        self.job_dir = (repo_dir / job_dir).resolve()

    @property
    def file(self):
        return self.job_dir / f'{self.name}.sh'

    @property
    def text(self):
        header = header_template.format(**self.__dict__)
        if self.ncpus > 1:
            header += f'\nexport OMP_NUM_THREADS={self.ncpus}'
        if self.mpi:
            header += f'\nexport I_MPI_JOB_RESPECT_PROCESS_PLACEMENT=0'

        cmd = self.cmd
        if self.mpi:
            ppn = self.cores_per_node // self.ncpus
            mpirun = f'mpirun -print-rank-map -ppn {ppn}'
            if self.ncpus > 1:
                mpirun += f' -genv OMP_NUM_THREADS={self.ncpus}'
                mpirun += ' -genv I_MPI_PIN_DOMAIN=omp'
            cmd = f'{mpirun} {cmd}'

        return '\n'.join([header, cmd])

    def submit(self, depend=None):
        # Write job script
        self.file.parent.mkdir(parents=True, exist_ok=True)
        self.file.write_text(self.text)

        # Assemble submit command
        cmd = ['sbatch']
        if depend is not None:
            cmd += ['--dependency=afterok:' + ':'.join(depend)]
        cmd += [self.file.name]

        # Submit
        print(' '.join(cmd))
        cp = sp.run(cmd, cwd=self.file.parent,
                    check=True, stdout=sp.PIPE, text=True)
        print(cp.stdout)
        job_id = cp.stdout.split()[-1]
        return job_id
