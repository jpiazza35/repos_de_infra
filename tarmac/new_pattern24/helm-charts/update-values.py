#!/usr/bin/env python3

import os
from jinja2 import Environment, FileSystemLoader

environment = os.getenv('ENVIRONMENT')
product = os.getenv('PRODUCT')
docker_image_tag = os.getenv('DOCKER_IMAGE_TAG')
project_name = os.getenv('PROJECT_NAME')
ss_tools_ecr_url = os.getenv('SS_TOOLS_ECR_URL')

env = Environment(loader=FileSystemLoader("."))
template = env.get_template("{}/{}/{}/values.yaml.j2".format(environment, product, project_name))

yaml_str = template.render(
    docker_image_tag=docker_image_tag,
    project_name=project_name,
    ss_tools_ecr_url=ss_tools_ecr_url,
    environment=environment,
    product=product
)

with open("{}/{}/{}/values.yaml".format(environment, product, project_name), "w") as f:
    f.write(yaml_str)
