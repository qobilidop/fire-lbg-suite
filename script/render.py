#!/usr/bin/env python
from argparse import ArgumentParser
import collections
from pathlib import Path
import pprint

from jinja2 import Environment
from jinja2 import FileSystemLoader
import yaml


def main():
    # Parse arguments
    parser = ArgumentParser()
    parser.add_argument('profile', type=Path)
    args = parser.parse_args()

    # Load profile
    profile = load_profile(args.profile)
    print('Applying the following profile:')
    pprint.pprint(profile)

    # Render template into target
    repo_dir = Path(__file__).resolve().parents[1]
    target_dir = repo_dir / 'run' / profile['name']
    template_dir = repo_dir / 'template'
    env = Environment(loader=FileSystemLoader(str(template_dir)))
    env.keep_trailing_newline = True
    for template_name in env.list_templates():
        template = env.get_template(template_name)
        rendered = template.render(profile)
        target = target_dir / template_name
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(rendered)
    print(f'Template is rendered into {target_dir}.')


def load_profile(path: Path):
    """Load profile dictionary."""
    with path.open() as f:
        profile = yaml.load(f)
    if 'import' in profile:
        path_import = path.parent / profile['import']
        del profile['import']
        print(f'Importing {path_import}')
        profile_to_import = load_profile(path_import)
        profile = update_profile(profile_to_import, profile)
    return profile


def update_profile(base, patch):
    """Update profile dictionary recursively."""
    for k, v in patch.items():
        if k in base and isinstance(v, collections.Mapping):
            update_profile(base[k], v)
        else:
            base[k] = v
    return base


if __name__ == '__main__':
    main()
