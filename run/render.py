#!/usr/bin/env python
from argparse import ArgumentParser
from pathlib import Path

from jinja2 import Environment
from jinja2 import FileSystemLoader
import yaml


def main():
    # Parse arguments
    parser = ArgumentParser()
    parser.add_argument('config_file', type=Path)
    args = parser.parse_args()
    config_file = args.config_file

    # Load config file
    with config_file.open() as f:
        config = yaml.load(f)
    config['template_dict']['name'] = config_file.stem

    # Prepare to render
    work_dir = config_file.parent.resolve()
    target_dir = work_dir / config_file.stem
    template_dir = work_dir / config['template_dir']
    env = Environment(loader=FileSystemLoader(str(template_dir)))

    # Render template directory into target directory
    for template_name in env.list_templates():
        template = env.get_template(template_name)
        rendered = template.render(config['template_dict'])
        target_file = target_dir / template_name
        target_file.parent.mkdir(parents=True, exist_ok=True)
        target_file.write_text(rendered)


if __name__ == '__main__':
    main()
