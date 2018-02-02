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
        parser.add_argument('--snap', type=Path)
        parser.add_argument('--mode', type=str, default='execute')
        args = parser.parse_args()
        return cls(args.sim, args.snap, args.mode)

    def __init__(self, sim: Path, snap: Path, mode: str = 'execute'):
        self.sim = sim
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
        cmd += f' --snap {self.snap.resolve()}'
        return cmd

    @property
    def id(self):
        return f'ahf-{self.sim.name}-{self.snap.stem}'
    
    @property
    def name(self):
        return f'ahf-{self.snap.stem.split("_")[1]}'

    @property
    def script(self):
        return self.cache_dir / (self.id + '.job')
    
    @property
    def work_dir(self):
        return self.sim / 'ahf'
    
    def validate(self):
        assert self.sim.exists()
        assert self.snap.exists()
    
    def completed(self):
        prefix = self.snap.stem
        suffixes = [
            '.input', '.log', '.parameter',
            '.AHF_halos', '.AHF_particles',
            '.AHF_profiles', '.AHF_substructure'
        ]
        for suffix in suffixes:
            found = list(self.work_dir.glob('*'.join([prefix, suffix])))
            if len(found) != 1:
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
        run(['qsub', self.script.name], cwd=self.script.parent)

    def execute(self):
        work_dir = self.work_dir
        snap_path = self.snap
        # Generate input file
        work_dir.mkdir(parents=True, exist_ok=True)
        config = configparser.ConfigParser()
        config.optionxform = lambda option: option
        if snap_path.is_file():
            # Single snapshot case
            ic_filename = os.path.relpath(snap_path, work_dir)
            ic_filetype = 60
        else:
            # Multiple snapshot case
            ic_filename = os.path.commonprefix(
                [str(os.path.relpath(p, work_dir))
                 for p in snap_path.glob('*')]
            )
            ic_filetype = 61
        output_prefix = snap_path.stem
        config['AHF'] = {
            'ic_filename': ic_filename,
            'ic_filetype': ic_filetype,
            'outfile_prefix': output_prefix,
            'LgridDomain': 512,
            'LgridMax': 134217728,
            'NperDomCell': 10,
            'NperRefCell': 50,
            'VescTune': 1.5,
            'NminPerHalo': 100,
            'RhoVir': 0,
            'Dvir': -1,
            'MaxGatherRad': 0.5,
            'LevelDomainDecomp': 6,
            'NcpuReading': 1
        }
        config['GADGET'] = {
            'GADGET_LUNIT': 1e-3,
            'GADGET_MUNIT': 1e10
        }
        input_file = work_dir / f'{output_prefix}.input'
        with input_file.open('w') as f:
            config.write(f)

        # Run
        run(['AHF', input_file.relative_to(work_dir)], cwd=work_dir)


if __name__ == '__main__':
    job = Job.parse()
    job.main()
