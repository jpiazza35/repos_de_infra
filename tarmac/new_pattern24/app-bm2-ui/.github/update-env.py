#!/usr/bin/env python3

import os
from jinja2 import Environment, FileSystemLoader

vite_auth0_domain = os.getenv('VITE_AUTH0_DOMAIN')
vite_auth0_audience = os.getenv('VITE_AUTH0_AUDIENCE')
vite_auth0_clientid = os.getenv('VITE_AUTH0_CLIENTID')
vite_am5_license_key = os.getenv('VITE_AM5_LICENSE_KEY')
vite_build_number = os.getenv('VITE_BUILD_NUMBER')

environment = os.getenv('ENVIRONMENT')

env = Environment(loader=FileSystemLoader("."))
if environment == "prod":
    template = env.get_template("./.env.production.j2")

    str = template.render(
        vite_auth0_domain=vite_auth0_domain,
        vite_auth0_audience=vite_auth0_audience,
        vite_auth0_clientid=vite_auth0_clientid,
        vite_am5_license_key=vite_am5_license_key,
        vite_build_number=vite_build_number
    )

    with open("./.env.production", "w") as f:
        f.write(str)

elif environment == "preview":
    template = env.get_template("./.env.preview.j2")

    str = template.render(
        vite_auth0_domain=vite_auth0_domain,
        vite_auth0_audience=vite_auth0_audience,
        vite_auth0_clientid=vite_auth0_clientid,
        vite_am5_license_key=vite_am5_license_key,
        vite_build_number=vite_build_number
    )

    with open("./.env.preview", "w") as f:
        f.write(str)

else:
    template = env.get_template("./.env.j2")

    str = template.render(
        vite_auth0_domain=vite_auth0_domain,
        vite_auth0_audience=vite_auth0_audience,
        vite_auth0_clientid=vite_auth0_clientid,
        vite_am5_license_key=vite_am5_license_key,
        vite_build_number=vite_build_number
    )

    with open("./.env.{}".format(environment), "w") as f:
        f.write(str)
