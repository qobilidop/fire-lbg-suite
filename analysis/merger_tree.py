#!/usr/bin/env python
from argparse import ArgumentParser
import configparser
import os
from pathlib import Path
from subprocess import run

from path import repo_dir


template = """
#!/usr/bin/env bash
#PBS -q condo
#PBS -N {name}
#PBS -l nodes=1:ppn=1
#PBS -l walltime=01:00:00
#PBS -o {id}.o
#PBS -e {id}.e
#PBS -V
#PBS -m n

{init}
{cmd}
"""


class Job(object):
    cache_dir = repo_dir / 'cache/job'
    init = 'source activate z2f2'

    @classmethod
    def parse(cls):
        parser = ArgumentParser()
        parser.add_argument('--sim', type=Path)
        parser.add_argument('--mode', type=str, default='execute')
        args = parser.parse_args()
        return cls(args.sim, args.mode)

    def __init__(self, sim: Path, mode: str = 'execute'):
        self.sim = sim
        self.mode = mode
    
    def main(self):
        self.validate()
        if not self.completed():
            if self.mode == 'submit':
                self.submit()
            elif self.mode == 'execute':
                self.execute()
            else:
                raise
    
    @property
    def cmd(self):
        cmd = f'python {Path(__file__).resolve()}'
        cmd += f' --sim {self.sim.resolve()}'
        return cmd

    @property
    def id(self):
        return f'mt-{self.sim.name}'
    
    @property
    def name(self):
        return f'mt-{self.sim.name}'

    @property
    def script(self):
        return self.cache_dir / (self.id + '.job')
    
    @property
    def work_dir(self):
        return self.sim / 'ahf'
    
    def validate(self):
        assert self.sim.exists()
        assert self.work_dir.exists()
    
    def completed(self):
        n_part = len(list(self.work_dir.glob('*.AHF_particles')))
        for pattern in ['*.AHF_mtree', '*.AHF_mtree_idx']:
            n_mt = len(list(self.work_dir.glob(pattern)))
            if n_mt != n_part:
                return False
        print(f'Job {self.id} is already completed.')
        return True

    def submit(self):
        self.script.parent.mkdir(parents=True, exist_ok=True)
        template_dict = dict(
            name=self.name,
            id=self.id,
            init=self.init,
            cmd=self.cmd
        )
        self.script.write_text(template.format(**template_dict))
        print(f'Submitting {self.script.name}')
        run(['qsub', self.script.name], cwd=self.script.parent)

    def execute(self):
        work_dir = self.work_dir

        particles_files = list(reversed(sorted(work_dir.glob('*.AHF_particles'))))

        input_args = [str(len(particles_files))] + \
                     [str(f.relative_to(work_dir)) for f in particles_files] + \
                     [f.name[:-len('_particles')] for f in particles_files[:-1]]
        input_file = work_dir / 'MergerTree.input'
        input_file.write_text('\n'.join(input_args))

        run(f'MergerTree < {input_file.name}', shell=True, cwd=work_dir)


if __name__ == '__main__':
    job = Job.parse()
    job.main()
