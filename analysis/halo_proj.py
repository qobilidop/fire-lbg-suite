#!/usr/bin/env python
from argparse import ArgumentParser
import configparser
import os
from pathlib import Path
from subprocess import run

import pandas as pd
import yt

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
        parser.add_argument('--halo', type=Path)
        parser.add_argument('--snap', type=Path)
        parser.add_argument('--mode', type=str, default='execute')
        args = parser.parse_args()
        return cls(args.sim, args.halo, args.snap, args.mode)

    def __init__(self, sim: Path, halo:Path, snap: Path, mode: str = 'execute'):
        self.sim = sim
        self.halo = halo
        self.snap = snap
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
        cmd += f' --halo {self.halo.resolve()}'
        cmd += f' --snap {self.snap.resolve()}'
        return cmd
    
    @property
    def halo_id(self):
        return int(self.halo.stem.split('_')[1])

    @property
    def id(self):
        return f'hp-{self.sim.name}-{self.halo_id}-{self.snap_id}'
    
    @property
    def name(self):
        return f'hp-{self.halo_id}-{self.snap_id}'
    
    @property
    def snap_id(self):
        return int(self.snap.stem.split('.')[0].split('_')[1])

    @property
    def script(self):
        return self.cache_dir / (self.id + '.job')
    
    @property
    def work_dir(self):
        return (self.sim / f'halo_proj/{self.halo_id}').resolve()
    
    def validate(self):
        assert self.sim.exists()
        assert self.halo.exists()
        assert self.snap.exists()
    
    def completed(self):
        return False

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
        self.work_dir.mkdir(parents=True, exist_ok=True)

        ds = self.load_snapshot()
        hh = self.load_halo_history()
        hi = hh.iloc[190 - self.snap_id]
        center = ds.arr([hi.Xc, hi.Yc, hi.Zc], 'kpccm/h')
        radius = ds.quan(hi.Rvir, 'kpccm/h')
        width = ds.quan(250, 'kpc')
        box = ds.box(center - width / 1.9, center + width / 1.9)

        p = yt.ProjectionPlot(
            ds, 'z', ('gas', 'density'),
            center=center, width=width, data_source=box
        )
        p.annotate_scale()
        p.annotate_timestamp(redshift=True)
        p.annotate_sphere(center.to('code_length'), radius.to('code_length'))
        p.save(str(self.work_dir))

        p = yt.ProjectionPlot(
            ds, 'z', ('gas', 'temperature'), weight_field=('gas', 'density'),
            center=center, width=width, data_source=box
        )
        p.annotate_scale()
        p.annotate_timestamp(redshift=True)
        p.annotate_sphere(center.to('code_length'), radius.to('code_length'))
        p.save(str(self.work_dir))

        p = yt.ProjectionPlot(
            ds, 'z', ('gas', 'metallicity'), weight_field=('gas', 'density'),
            center=center, width=width, data_source=box
        )
        p.annotate_scale()
        p.annotate_timestamp(redshift=True)
        p.annotate_sphere(center.to('code_length'), radius.to('code_length'))
        p.save(str(self.work_dir))
    
    def load_snapshot(self):
        return yt.load(str(self.snap.resolve()), index_ptype='PartType0')
    
    def load_halo_history(self):
        path = self.halo
        names = path.read_text().split('\n')[1].strip().split('\t')
        # Remove leading '#' in column names
        names = [name[1:] if name.startswith('#') else name for name in names]
        # Remove trailing '()' in column names
        names = [name[:name.find('(')] if '(' in name else name for name in
                    names]
        # Add redshift column
        names = ['redshift'] + names
        # Read
        hh = pd.read_csv(path, skiprows=2, delim_whitespace=True,
                         header=None, names=names)
        return hh


if __name__ == '__main__':
    job = Job.parse()
    job.main()
