import boto3
import os
from tabulate import tabulate

def retrieve_elastic_ip_attributes(ec2):
    eips = []
    for eip in list(ec2.vpc_addresses.all()):
        interface_type = None
        instance_status = None
        public_ips = None

        if eip.network_interface_id:
            eni = ec2.NetworkInterface(eip.network_interface_id)
            interface_type = eni.interface_type

        if eip.instance_id:
            ec2_instance = ec2.Instance(eip.instance_id)
            instance_status = ec2_instance.state['Name']
            public_ips = [instance["Association"]["PublicIp"]
                          for instance in ec2_instance.network_interfaces_attribute]

        eips.append({
            'public_ip': eip.public_ip,
            'eni_id':  eip.network_interface_id,
            'eni_type': interface_type,
            'instance_id': eip.instance_id,
            'instance_status': instance_status,
            'instance_public_ips': public_ips
        })

    return eips

def identify_idle_elastic_ips(elastic_ips):
    for eip in elastic_ips:
        if not eip['eni_id'] or (eip['eni_type'] == 'interface' and (
               not eip['instance_id'] or
               eip['instance_status'] != 'running' or
               len(eip['instance_public_ips']) > 1)):
            eip['idle'] = True
        else:
            eip['idle'] = False

def list_public_ips():
    ec2_client = boto3.client('ec2')
    rds_client = boto3.client('rds')
    eks_client = boto3.client('eks')

    print("Public IP Addresses:")
    print("{:<15} {:<20} {:<15}".format('Public IP', 'Allocation ID', 'Associated Resource', 'Idle'))
    print("="*75)

    # List public IPs for EC2 instances
    ec2_addresses = ec2_client.describe_addresses()['Addresses']
    for address in ec2_addresses:
        public_ip = address['PublicIp']
        allocation_id = address['AllocationId']
        instance_id = address.get('InstanceId', 'N/A')
        instance_type = address.get('InstanceType', 'N/A')
        resource_info = f"Instance: {instance_id}, Type: {instance_type}"
        print("{:<15} {:<20} {:<15} {:<5}".format(public_ip, allocation_id, resource_info, 'N/A'))

    # List public IPs for RDS instances
    rds_addresses = rds_client.describe_db_instances()['DBInstances']
    for db_instance in rds_addresses:
        public_ip = db_instance.get('PubliclyAccessible', 'N/A')
        if public_ip:
            endpoint = db_instance['Endpoint']
            resource_info = f"RDS Instance: {db_instance['DBInstanceIdentifier']}, Endpoint: {endpoint['Address']}:{endpoint['Port']}"
            print("{:<15} {:<20} {:<15} {:<5}".format(public_ip, 'N/A', resource_info, 'N/A'))

    # List public IPs for EKS nodes
    eks_clusters = eks_client.list_clusters()['clusters']
    for cluster_name in eks_clusters:
        nodes = eks_client.list_nodes(clusterName=cluster_name)['nodes']
        for node in nodes:
            public_ip = node.get('publicIp', 'N/A')
            instance_type = node.get('instanceType', 'N/A')
            resource_info = f"EKS Cluster: {cluster_name}, Node Instance: {node['nodeInstanceRoleArn']}, Type: {instance_type}"
            print("{:<15} {:<20} {:<15} {:<5}".format(public_ip, 'N/A', resource_info, 'N/A'))

if __name__ == '__main__':
    region = os.environ.get('AWS_REGION', 'us-east-1')
    ec2 = boto3.resource('ec2', region_name=region)

    # Retrieve and identify Elastic IPs
    elastic_ips = retrieve_elastic_ip_attributes(ec2)
    identify_idle_elastic_ips(elastic_ips)

    # Print the combined information
    print("Public IPs and Idle Elastic IPs:")
    list_public_ips()
    print("\nIdle Elastic IPs:")
    report_on_idle_eips(elastic_ips)