import os
import logging
import pathlib
import sys

from typing import Dict, Any, List

import click
import jinja2

from . import variables


@click.command()
@click.option("--verbose/--silent", "-v")
@click.option("--export", "-e", "var_overrides", multiple=True)
@click.option(
    "--var-file",
    "-f",
    "var_files",
    multiple=True,
    type=click.Path(exists=True, readable=True, dir_okay=False),
)
@click.option("--output-file", "-o", type=click.Path(writable=True, dir_okay=False))
@click.argument("template_file")
def main(
    verbose: bool,
    var_overrides: List[str],
    var_files: List[pathlib.Path],
    template_file: str,
    output_file: str,
) -> None:
    # Logging
    logging.basicConfig(level=logging.DEBUG if verbose else logging.WARNING)

    # Load template
    jinja_env = jinja2.Environment(loader=jinja2.FileSystemLoader("."))

    try:
        template = jinja_env.get_template(template_file)
        logging.debug("Template loaded.")
    except jinja2.exceptions.TemplateNotFound:
        logging.critical("Template not found: %s", template_file)

    # Gather variables
    component_name: str = pathlib.Path(template_file).resolve().parent.name
    logging.debug("Component: %s", component_name)
    overrides: Dict[str, Any] = {}

    for var in var_overrides:
        kv = var.split("=")
        if len(kv) == 2:
            overrides[kv[0]] = kv[1]
            logging.info("Override %s", kv)
        else:
            logging.warning("Cannot parse variable: %s", var)

    env = variables.get_environment(
        component_name, [pathlib.Path(f) for f in var_files], overrides
    )

    # Render
    result = template.stream(vars=env, **variables.other)

    if output_file:
        with open(output_file, 'w') as fd:
            result.dump(fd)

    else:
        result.dump(sys.stdout)
