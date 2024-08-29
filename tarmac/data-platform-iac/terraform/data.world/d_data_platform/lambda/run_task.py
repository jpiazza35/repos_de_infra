import boto3
import os

# Define the run_task_with_event_data function
def run_task_with_event_data(event_data, container_name, dataworld_api_token, ecs_cluster, subnetIds, security_group, init_command):
    # Export variables from event_data
    for key, value in event_data.items():
        os.environ[key] = str(value)

    db_host = os.getenv('db_host')
    db_name = os.getenv('db_name')
    db_user = os.getenv('db_user')
    db_pass = os.getenv('db_pass')
    upload_location = os.getenv('upload_location')
    region = os.getenv('aws_region')

    # Check the presence of specific parameters in the event data
    print(event_data)
    print(db_host)
    print(db_name)
    print(db_user)
    print(db_pass)
    print(upload_location)
    print(init_command)
    print(region)

    if 'catalog-postgres' in event_data:
        init_command = event_data['catalog-postgres']
        overrides = {
            'containerOverrides': [
                {
                    'name': container_name,
                    'command': [
                        f"{init_command}",
                        "--agent=catalog-sources",
                        "--site=cliniciannexus",
                        "--no-log-upload=false",
                        "--upload=true",
                        f"--api-token={dataworld_api_token}",
                        "--output=/data",
                        f"--name={init_command}",
                        f"--upload-location={upload_location}",
                        f"--server={db_host}",
                        f"--database={db_name}",
                        "--all-schemas=true",
                        "--include-information-schema=false",
                        f"--user={db_user}",
                        f"--password={db_pass}",
                        "--disable-lineage-collection=false",
                        "--enable-column-statistics=false",
                        "--sample-string-values=false"
                    ],
                },
            ],
        }
    elif 'catalog-sqlserver' in event_data:
        init_command = event_data['catalog-sqlserver']
        overrides = {
            'containerOverrides': [
                {
                    'name': container_name,
                    'command': [
                        f"{init_command}",
                        "--agent=catalog-sources",
                        "--site=cliniciannexus",
                        "--no-log-upload=false",
                        "--upload=true",
                        f"--api-token={dataworld_api_token}",
                        "--output=/data",
                        f"--name={init_command}",
                        f"--upload-location={upload_location}",
                        f"--server={db_host}",
                        f"--database={db_name}",
                        "--all-schemas=true",
                        "--include-information-schema=false",
                        f"--user={db_user}",
                        f"--password={db_pass}",
                        "--disable-lineage-collection=false",
                        "--enable-column-statistics=false",
                        "--sample-string-values=false"
                    ],
                },
            ],
        }
    elif 'catalog-redshift' in event_data:
        init_command = event_data['catalog-redshift']
        overrides = {
            'containerOverrides': [
                {
                    'name': container_name,
                    'command': [
                        f"{init_command}",
                        "--agent=catalog-sources",
                        "--site=cliniciannexus",
                        "--no-log-upload=false",
                        "--upload=true",
                        f"--api-token={dataworld_api_token}",
                        "--output=/data",
                        f"--name={init_command}",
                        f"--upload-location={upload_location}",
                        f"--server={db_host}",
                        f"--database={db_name}",
                        "--all-schemas=true",
                        "--include-information-schema=false",
                        f"--user={db_user}",
                        f"--password={db_pass}",
                        "--disable-lineage-collection=false",
                        "--enable-column-statistics=false",
                        "--sample-string-values=false"
                    ],
                },
            ],
        }
    elif 'catalog-databricks' in event_data:
        init_command = event_data['catalog-databricks']
        overrides = {
            'containerOverrides': [
                {
                    'name': container_name,
                    'command': [
                        f"{init_command}",
                        "--agent=catalog-sources",
                        "--site=cliniciannexus",
                        "--no-log-upload=false",
                        "--upload=true",
                        f"--api-token={dataworld_api_token}",
                        "--output=/data",
                        f"--name={init_command}",
                        f"--upload-location={upload_location}",
                        f"--server={db_host}",
                        f"--database={db_name}",
                        "--all-schemas=true",
                        "--include-information-schema=false",
                        f"--http-path={db_user}",
                        f"--access-token={db_pass}",
                        "--disable-lineage-collection=false",
                        "--enable-column-statistics=false",
                        "--sample-string-values=false"
                    ],
                },
            ],
        }
    elif 'catalog-amazon-s3' in event_data:
        init_command = event_data['catalog-amazon-s3']
        overrides = {
            'containerOverrides': [
                {
                    'name': container_name,
                    'command': [
                        f"{init_command}",
                        "--agent=catalog-sources",
                        "--site=cliniciannexus",
                        "--no-log-upload=false",
                        "--upload=true",
                        f"--api-token={dataworld_api_token}",
                        "--output=/data",
                        f"--name={init_command}",
                        f"--upload-location={upload_location}",
                        f"--aws-region={region}",
                        f"--include-bucket={db_name}"
                    ],
                },
            ],
        }
    else:
        overrides = {
            'containerOverrides': [
                {
                    'name': container_name,
                    'command': [
                        f"{init_command}",
                        "--agent=catalog-sources",
                        "--site=cliniciannexus",
                        "--no-log-upload=false",
                        "--upload=true",
                        f"--api-token={dataworld_api_token}",
                        "--output=/data",
                        f"--name={init_command}",
                        f"--tableau-project={db_name}",
                        f"--upload-location={upload_location}",
                        f"--tableau-api-base-url={db_host}",
                        f"--tableau-pat-name={db_user}",
                        f"--tableau-pat-secret={db_pass}",
                    ],
                },
            ],
        }

    ecs_client = boto3.client("ecs", region_name='us-east-1')
    # Run the ECS task with the dynamic overrides
    executeTask = ecs_client.run_task(
        cluster=ecs_cluster,
        launchType='FARGATE',
        networkConfiguration={
            'awsvpcConfiguration': {
                'subnets': [
                    subnetIds
                ],
                'securityGroups': [
                    security_group,
                ],
                'assignPublicIp': 'DISABLED'
            }
        },
        overrides=overrides,
        taskDefinition=container_name
    )


def lambda_handler(event, context):
    # Env variables
    session = boto3.session.Session()
    region = session.region_name
    dataworld_api_token = os.getenv('DW_API_TOKEN')
    ecs_client = boto3.client("ecs", region_name=region)
    ec2_client = boto3.client('ec2')

    # Extract necessary values from the event
    database_host = event['db_host']
    database_user = event['db_user']
    database_pass = event['db_pass']
    database_name = event['db_name']
    init_command = event['init_command']
    ecs_cluster_event = event['ecs_cluster']
    upload_location = event['upload_location']
    security_group_event = event['security_group']
    container_name_event = event['container_name']

    # Your existing code for fetching VPC and subnetIds

    for cluster_val in ecs_cluster_event.values():
        ecs_cluster = cluster_val
        print(ecs_cluster)

    for sg_val in security_group_event.values():
        security_group = sg_val
        print(security_group)

    for container_val in container_name_event.values():
        for name in container_val.values():
            container_name = name
            print(container_name)

    getVpc = ec2_client.describe_vpcs(
        Filters=[
            {
                'Name': 'tag:Name',
                'Values': [
                    'primary-vpc',
                ]
            },
        ]
    )
    for vpc in getVpc['Vpcs']:
        vpcId = vpc['VpcId']

    sn_all = ec2_client.describe_subnets(
        Filters=[
            {
                'Name': 'vpcId',
                'Values': [
                    vpcId
                ]
            },
            {
                'Name': 'tag:Name',
                'Values': [
                    '*private*',
                ]
            },

        ],
    )
    for sn in sn_all['Subnets']:
        subnetIds = sn['SubnetId']
        print(sn['SubnetId'])
    # Dynamically create the event_data_list based on init_command
    event_data_list = []

    if init_command == 'catalog-postgres':
        event_data = {
            "catalog-postgres": init_command,
            "db_host": database_host,
            "db_user": database_user,
            "db_pass": database_pass,
            "db_name": database_name,
            "init_command": init_command,
            "ecs_cluster": ecs_cluster_event,
            "upload_location": upload_location,
            "security_group": security_group_event,
            "container_name": container_name_event
        }
        event_data_list.append(event_data)
    elif init_command == 'catalog-sqlserver':
        event_data = {
            "catalog-sqlserver": init_command,
            "db_host": database_host,
            "db_user": database_user,
            "db_pass": database_pass,
            "db_name": database_name,
            "init_command": init_command,
            "ecs_cluster": ecs_cluster_event,
            "upload_location": upload_location,
            "security_group": security_group_event,
            "container_name": container_name_event
        }
        event_data_list.append(event_data)
    elif init_command == 'catalog-redshift':
        event_data = {
            "catalog-redshift": init_command,
            "db_host": database_host,
            "db_user": database_user,
            "db_pass": database_pass,
            "db_name": database_name,
            "init_command": init_command,
            "ecs_cluster": ecs_cluster_event,
            "upload_location": upload_location,
            "security_group": security_group_event,
            "container_name": container_name_event
        }
        event_data_list.append(event_data)
    elif init_command == 'catalog-databricks':
        event_data = {
            "catalog-databricks": init_command,
            "db_host": database_host,
            "db_user": database_user,
            "db_pass": database_pass,
            "db_name": database_name,
            "init_command": init_command,
            "ecs_cluster": ecs_cluster_event,
            "upload_location": upload_location,
            "security_group": security_group_event,
            "container_name": container_name_event
        }
        event_data_list.append(event_data)
    elif init_command == 'catalog-amazon-s3':
        event_data = {
            "catalog-amazon-s3": init_command,
            "db_name": database_name,
            "init_command": init_command,
            "ecs_cluster": ecs_cluster_event,
            "upload_location": upload_location,
            "security_group": security_group_event,
            "container_name": container_name_event,
            "aws_region": region
        }
        event_data_list.append(event_data)
    else:
        event_data = {
            "catalog-tableau": init_command,
            "db_host": database_host,
            "db_user": database_user,
            "db_pass": database_pass,
            "db_name": database_name,
            "init_command": init_command,
            "ecs_cluster": ecs_cluster_event,
            "upload_location": upload_location,
            "security_group": security_group_event,
            "container_name": container_name_event,
        }
        event_data_list.append(event_data)

    # Call the run_task_with_event_data function with the necessary parameters
    for event_data in event_data_list:
        run_task_with_event_data(event_data, container_name, dataworld_api_token, ecs_cluster, subnetIds, security_group, init_command)
