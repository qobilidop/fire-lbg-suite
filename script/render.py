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
    parser.add_argument('--output_dir', type=Path, default='run')
    args = parser.parse_args()
    config_file = args.config_file
    output_dir = args.output_dir

    # Load config file
    with config_file.open() as f:
        config = yaml.load(f)

    # Render template into target
    target_dir = output_dir / config['name']
    template_dir = config_file.parent / config['template']
    env = Environment(loader=FileSystemLoader(str(template_dir)))
    for template_name in env.list_templates():
        template = env.get_template(template_name)
        rendered = template.render(config)
        target = target_dir / template_name
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(rendered)


if __name__ == '__main__':
    main()
