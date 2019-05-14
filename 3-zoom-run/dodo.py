from functools import partial
from itertools import product
import json
import os
from pathlib import Path
from shutil import copy, move
from subprocess import run

from jinja2 import Template


GIZMO_REPO = 'ssh://hg@bitbucket.org/phopkins/gizmo'
GIZMO_COMMIT = '76dbfab6c0fbef056b713410e5eb73f8c1b00205'
COOL_TAB_TGZ = 'http://www.tapir.caltech.edu/~phopkins/public/spcool_tables.tgz'
COOL_TAB = 'spcool_tables'

CURRENT_DIR = Path(__file__).parent.resolve()
CONFIG_DIR = CURRENT_DIR / 'config'
DATA_DIR = CURRENT_DIR / 'data'
RUN_DIR = CURRENT_DIR / 'run'
SIM_CONFIG_FILES = sorted(CURRENT_DIR.glob('*.json'))
LOCAL_MACH = 'test'
if (CURRENT_DIR / 'mach').exists():
    LOCAL_MACH = (CURRENT_DIR / 'mach').read_text()


def load_sim_config(sim_config_file):
    run_dir = RUN_DIR / sim_config_file.stem
    config = json.loads(sim_config_file.read_text())
    name = config['name']
    return name, config, run_dir


def render(src, dst, params=None):
    src = Path(src)
    dst = Path(dst)
    if params is None:
        params = {}

    dst.parent.mkdir(parents=True, exist_ok=True)
    template = Template(src.read_text())
    dst.write_text(template.render(**params))


def add_render(src, dst, params, task):
    task['actions'] += [(render, [src, dst, params])]
    task['file_dep'] += [src]
    task['targets'] += [dst]


def init_task(name=None):
    return {
        'name': name,
        'actions': [],
        'file_dep': [],
        'targets': [],
    }


def submit(job_script):
    submit_cmd = job_script.read_text().split('\n')[1].split()[1]
    run([submit_cmd, job_script.name], cwd=job_script.parent)


def task_init():

    for f in SIM_CONFIG_FILES:
        name, _, _ = load_sim_config(f)
        yield {
            'name': name,
            'actions': None,
            'task_dep': [
                f'init_ic:{name}',
                f'init_run:{name}',
                f'download:{name}',
                f'compile:{name}',
            ]
        }


def task_init_ic():

    for f in SIM_CONFIG_FILES:
        name, config, run_dir = load_sim_config(f)
        task = init_task(name)

        params = config['ic']
        params['job_name'] = f'ic-{name}'

        add_render_ = partial(add_render, task=task, params=params)
        add_render_(
            CONFIG_DIR / 'music.conf',
            run_dir / 'ic/music.conf',
        )
        zoom_region = params['zoom_region']
        add_render_(
            DATA_DIR / f'zoom-region/{zoom_region}.txt',
            run_dir / 'ic/region_point.txt',
        )
        mach = params['mach']
        add_render_(
            CONFIG_DIR / f'job/ic.{mach}.sh',
            run_dir / 'job/ic.sh',
        )
        yield task


def task_init_run():

    for f in SIM_CONFIG_FILES:
        name, config, run_dir = load_sim_config(f)
        task = init_task(name)

        params = config['run']
        params['job_name'] = f'run-{name}'
        params['cores'] = params['omp'] * params['mpi']

        add_render_ = partial(add_render, params=params, task=task)
        add_render_(
            CONFIG_DIR / 'gizmo_config.sh',
            run_dir / 'gizmo_config.sh',
        )
        add_render_(
            CONFIG_DIR / 'gizmo_params.txt',
            run_dir / 'gizmo_params.txt',
        )
        add_render_(
            DATA_DIR / 'output-times/scale-factors.txt',
            run_dir / 'output_scale_factors.txt',
        )
        mach = params['mach']
        add_render_(
            CONFIG_DIR / f'job/run.{mach}.sh',
            run_dir / 'job/run.sh',
        )
        yield task


def task_download():

    for f in SIM_CONFIG_FILES:
        name, config, run_dir = load_sim_config(f)
        task = init_task(name)

        gizmo_dir = run_dir / 'gizmo_hg'
        task['actions'] += [
            f'rm -rf {gizmo_dir}',
            f'hg clone {GIZMO_REPO} -r {GIZMO_COMMIT} {gizmo_dir}',
        ]
        task['targets'] += [gizmo_dir]

        task['actions'] += [
            f'rm -rf {run_dir / COOL_TAB}',
            f'cd {run_dir} && curl {COOL_TAB_TGZ} | tar xzv',
        ]
        task['targets'] += [run_dir / COOL_TAB]

        add_render(
            gizmo_dir / 'cooling/TREECOOL',
            run_dir / 'TREECOOL',
            params=None, task=task,
        )

        yield task


def task_compile():

    def compile_gizmo(repo_dir, make_sys, config_file, gizmo_bin):
        copy(make_sys, repo_dir / 'Makefile.systype')
        copy(config_file, repo_dir / 'Config.sh')
        run(['make'], cwd=repo_dir)
        move(repo_dir / 'GIZMO', gizmo_bin)

    for f in SIM_CONFIG_FILES:
        name, config, run_dir = load_sim_config(f)
        repo_dir = run_dir / 'gizmo_hg'
        gizenv_root = Path(os.environ['GIZENV_ROOT'])
        make_sys = gizenv_root / 'config/package/gizmo/Makefile.systype'
        config_file = run_dir / 'gizmo_config.sh'
        gizmo_bin = run_dir / 'GIZMO'
        yield {
            'name': name,
            'actions': [
                (compile_gizmo, [repo_dir, make_sys, config_file, gizmo_bin]),
            ],
            'file_dep': [
                repo_dir / 'Makefile',
                make_sys,
                config_file,
            ],
            'targets': [
                gizmo_bin,
            ],
        }


def task_submit_ic():

    for f in SIM_CONFIG_FILES:
        name, config, run_dir = load_sim_config(f)
        job_script = run_dir / 'job/ic.sh'
        if config['ic']['mach'] == LOCAL_MACH:
            yield {
                'name': name,
                'actions': [(submit, [job_script])],
                'file_dep': [job_script],
                'uptodate': [False],
            }


def task_submit_run():

    for f in SIM_CONFIG_FILES:
        name, config, run_dir = load_sim_config(f)
        job_script = run_dir / 'job/run.sh'
        if config['run']['mach'] == LOCAL_MACH:
            yield {
                'name': name,
                'actions': [(submit, [job_script])],
                'file_dep': [job_script],
                'uptodate': [False],
            }
