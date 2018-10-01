#!/usr/bin/env python
from toolbox.env import repo_dir
from toolbox.job import BridgesJob


job_box_ic = BridgesJob(
    'box-ic',
    f'MUSIC ic_L86_ref10.conf',
    run_dir=(repo_dir / 'data/box/L86/initial_condition'),
    nodes=1, ncpus=28, time='1:00:00'
)
job_box_ic.submit()
