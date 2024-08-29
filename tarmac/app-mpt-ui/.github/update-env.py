#!/usr/bin/env python3

import os
from jinja2 import Environment, FileSystemLoader


vite_auth0_client_id = os.getenv('VITE_AUTH0_CLIENT_ID')
vite_launch_darkly = os.getenv('VITE_LAUNCH_DARKLY')
vite_am5_license_key = os.getenv('VITE_AM5_LICENSE_KEY')
vite_api_url = os.getenv('VITE_API_URL')
vite_api_url_prefix = os.getenv('VITE_API_URL_PREFIX')

environment = os.getenv('ENVIRONMENT')

env = Environment(loader=FileSystemLoader("."))
if environment == "prod":
    vite_ab2c_tenant_id = os.getenv('VITE_AB2C_TENANT_ID')
    vite_ab2c_client_id = os.getenv('VITE_AB2C_CLIENT_ID')
    vite_ab2c_redirect_uri = os.getenv('VITE_AB2C_REDIRECT_URI')
#    vite_build_number = os.getenv('VITE_BUILD_NUMBER')

    template = env.get_template("./.env.production.j2")

    str = template.render(
        vite_ab2c_tenant_id=vite_ab2c_tenant_id,
        vite_ab2c_client_id=vite_ab2c_client_id,
        vite_ab2c_redirect_uri=vite_ab2c_redirect_uri,
        vite_auth0_client_id=vite_auth0_client_id,
        vite_launch_darkly=vite_launch_darkly,
        vite_am5_license_key=vite_am5_license_key,
        vite_api_url=vite_api_url,
        vite_api_url_prefix=vite_api_url_prefix
#        vite_build_number=vite_build_number
    )

    with open("./.env.production", "w") as f:
        f.write(str)
        
elif environment == "preview":
    vite_ab2c_tenant_id = os.getenv('VITE_AB2C_TENANT_ID')
    vite_ab2c_client_id = os.getenv('VITE_AB2C_CLIENT_ID')
    vite_ab2c_redirect_uri = os.getenv('VITE_AB2C_REDIRECT_URI')
#    vite_build_number = os.getenv('VITE_BUILD_NUMBER')

    template = env.get_template("./.env.preview.j2")

    str = template.render(
        vite_ab2c_tenant_id=vite_ab2c_tenant_id,
        vite_ab2c_client_id=vite_ab2c_client_id,
        vite_ab2c_redirect_uri=vite_ab2c_redirect_uri,
        vite_auth0_client_id=vite_auth0_client_id,
        vite_launch_darkly=vite_launch_darkly,
        vite_am5_license_key=vite_am5_license_key,
        vite_api_url=vite_api_url,
        vite_api_url_prefix=vite_api_url_prefix
#        vite_build_number=vite_build_number
    )

    with open("./.env.{}".format(environment), "w") as f:
        f.write(str)

else:
#    vite_build_number = os.getenv('VITE_BUILD_NUMBER')
    template = env.get_template("./.env.j2")

    str = template.render(
        vite_auth0_client_id=vite_auth0_client_id,
        vite_launch_darkly=vite_launch_darkly,
        vite_am5_license_key=vite_am5_license_key,
        environment=environment,
        vite_api_url=vite_api_url,
        vite_api_url_prefix=vite_api_url_prefix
#        vite_build_number=vite_build_number
    )

    with open("./.env.{}".format(environment), "w") as f:
        f.write(str)
