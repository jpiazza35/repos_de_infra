#!/usr/bin/env python3

import os
from jinja2 import Environment, FileSystemLoader


build_number = os.getenv('GIT_TAG')

env = Environment(loader=FileSystemLoader("."))


template = env.get_template("./appsettings.json.j2")

str = template.render(
    build_number=build_number,
)

with open("./appsettings.json", "w") as f:
    f.write(str)
