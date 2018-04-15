#!/usr/bin/env python
"""Initialize a simulation directory ready to run.

The simulation directory is created according to a template directory
(data/template) and a config file (passed in as an argument).
"""
from argparse import ArgumentParser
import collections
import os
from pathlib import Path
import pprint

from jinja2 import Environment
from jinja2 import FileSystemLoader
import yaml


repo_dir = Path(__file__).resolve().parents[2]
template_dir = repo_dir / 'run/template'


def main():
    # Parse arguments
    parser = ArgumentParser()
    parser.add_argument('config_files', type=Path, nargs='+')
    args = parser.parse_args()

    for config_file in args.config_files:
        # Load config file
        config = load_config(config_file)
        print('Applying the following config:')
        pprint.pprint(config)
        # Render simulation directory
        render(config)
        print()


def render(config):
    """Render simulation directory."""
    target_dir = config['meta']['path'].with_suffix('')
    env = Environment(loader=FileSystemLoader(str(template_dir)))
    env.keep_trailing_newline = True
    for template_name in env.list_templates():
        # Render template
        template = env.get_template(template_name)
        rendered = template.render(**config, Path=Path)
        # Write target
        target = target_dir / template_name
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(rendered)
    print('Simulation directory is initialized at',
          target_dir.relative_to(os.getcwd()))


def load_config(path: Path):
    """Load config file."""
    path = path.resolve()

    # Load raw items
    with path.open() as f:
        config = yaml.load(f)
    
    # Import and update items
    if 'import' in config:
        import_path = (path.parent / config['import']).resolve()
        print('Importing', config['import'])
        del config['import']
        config_to_import = load_config(import_path)
        config = update_config(config_to_import, config)

    # Add meta items
    config['meta'] = {}
    config['meta']['name'] = path.stem
    config['meta']['path'] = path
    config['meta']['repo_root'] = repo_dir
    return config


def update_config(base, patch):
    """Update config recursively."""
    for k, v in patch.items():
        if k in base and isinstance(v, collections.Mapping):
            update_config(base[k], v)
        else:
            base[k] = v
    return base


if __name__ == '__main__':
    main()
