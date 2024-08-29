#!/usr/bin/env python3

import os
from jinja2 import Environment, FileSystemLoader

pwd = os.getenv('ODBC_PWD_TOKEN')

env = Environment(loader=FileSystemLoader("."))
template = env.get_template("./odbc.ini.j2")

str = template.render(
    pwd=pwd
)

with open("./odbc.ini", "w") as f:
    f.write(str)