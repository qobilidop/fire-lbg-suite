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
        parser.add_argument('--n_halo', type=int, default=10)
        parser.add_argument('--mode', type=str, default='execute')
        args = parser.parse_args()
        return cls(args.sim, args.n_halo, args.mode)

    def __init__(self, sim: Path, n_halo: int, mode: str = 'execute'):
        self.sim = sim
        self.n_halo = n_halo
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
        return f'ahh-{self.sim.name}'
    
    @property
    def name(self):
        return f'ahh-{self.sim.name}'

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
        n_halo = len(list(self.work_dir.glob('halo_*.dat')))
        if n_halo != self.n_halo:
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

        halos_files = reversed(sorted(work_dir.glob('*.AHF_halos')))

        haloid_list = [str(halo_id) for halo_id in range(self.n_halo)]
        (work_dir / 'haloid_list').write_text('\n'.join(haloid_list) + '\n')

        prefix_list = [f.name[:-len('_halos')] for f in halos_files]
        (work_dir / 'prefix_list').write_text('\n'.join(prefix_list) + '\n')

        zred_list = [self._extract_zred(p) for p in prefix_list]
        (work_dir / 'zred_list').write_text('\n'.join(zred_list) + '\n')

        run(['ahfHaloHistory', 'haloid_list', 'prefix_list', 'zred_list'],
            cwd=work_dir)
    
    def _extract_zred(self, prefix):
        start = prefix.find('.z') + 2
        end = start + 5
        return prefix[start:end]


if __name__ == '__main__':
    job = Job.parse()
    job.main()
