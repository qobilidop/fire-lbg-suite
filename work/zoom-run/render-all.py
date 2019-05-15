#!/usr/bin/env python
"""Render all run configs into run directories."""
from pathlib import Path
import shutil

from jinja2 import Environment
import toml

from lib.path import ROOT


THIS_DIR = Path(__file__).parent.resolve()
TMPL_DIR = THIS_DIR / 'template'
RUN_DIR = ROOT / 'run'


def render_file(src, dst, params):
    env = Environment(keep_trailing_newline=True)
    template = env.from_string(src.read_text())
    dst.parent.mkdir(parents=True, exist_ok=True)
    dst.write_text(template.render(**params))


def render_run(config_file, run_dir):
    params = toml.load(config_file)

    # Render all but job
    for rel_path in [
        'ic/music.conf',
        '.gitignore',
        'gizmo_config.sh',
        'gizmo_params.txt',
        'Makefile',
        'output_times.txt'
    ]:
        render_file(TMPL_DIR / rel_path, run_dir / rel_path, params)

    # Render job
    render_file(
        TMPL_DIR / 'job' / 'ic.{}.sh'.format(params['job']['ic']['site']),
        run_dir / 'job/ic.sh', params
    )
    render_file(
        TMPL_DIR / 'job' / 'run.{}.sh'.format(params['job']['run']['site']),
        run_dir / 'job/run.sh', params
    )

    # Copy zoom region file
    shutil.copyfile(
        ROOT / 'data/zoom-region' / (params['zoom_region'] + '.txt'),
        run_dir / 'ic/zoom_region.txt'
    )


if __name__ == '__main__':
    for config_file in THIS_DIR.glob('*.toml'):
        render_run(config_file, RUN_DIR / config_file.stem)
