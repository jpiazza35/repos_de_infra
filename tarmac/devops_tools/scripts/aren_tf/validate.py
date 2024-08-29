from functions import *
from datetime import datetime

def check_for_aws_regions(filepath, timestamp):
    rule = "Hardcoded AWS region strings. Consider parameterizing."
    terms = ["us-east-2", "us-east-1", "us-west-1", "us-west-2", "af-south-1", "ap-east-1", "ap-northeast-1", "ap-northeast-2", "ap-northeast-3", "ap-south-1", "ap-southeast-1", "ap-southeast-2", "ca-central-1", "cn-north-1", "cn-northwest-1", "eu-central-1", "eu-north-1", "eu-south-1", "eu-west-1", "eu-west-2", "eu-west-3", "eu-west-4", "me-south-1", "sa-east-1", "us-gov-east-1", "us-gov-west-1"]
    search_terms(filepath, terms, rule, timestamp)

def check_for_accountids(filepath, timestamp):
    rule = "Hardcoded AWS account ID strings. Consider parameterizing."
    search_accountid(filepath, rule, timestamp)

def check_for_passwords(filepath, timestamp):
    rule = "Potentially hardcoded password"
    search_passwords(filepath, rule, timestamp)
    
def check_for_open_iegress(filepath, timestamp):
    rule = "Open ingress/egress rules. Consider specific ranges e.g. `192.168.0.1/32`"
    search_open_iegress(filepath, rule, timestamp)

if __name__ == "__main__":
    now = datetime.now()
    timestamp = now.strftime("%Y%m%d-%H%M%S")
    rootpath = input("Enter the root filepath to your terraform code: ")
    filepath = rootpath + '/modules'
    
    #terms = input("Enter a list of search terms separated by commas: ").split(",")
    check_for_aws_regions(filepath, timestamp)

    check_for_accountids(filepath, timestamp)

    check_for_passwords(rootpath, timestamp)
    
    check_for_open_iegress(rootpath, timestamp)
    