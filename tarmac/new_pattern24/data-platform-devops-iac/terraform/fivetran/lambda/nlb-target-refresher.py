import json
import logging
import os
import sys

import lambda_utils as utils

VERSION = "1.0.6"

"""
Environment Variables:

1. ELB_ARN (mandatory): The ARN of the Elastic Load Balancer's target group
2. MAX_LOOKUP_PER_INVOCATION (optional): The max times of DNS lookup per fqdn
3. REMOVE_UNTRACKED_TG_IP (optional): Remove IPs which are not resolved with the given fqdns
"""
if 'DNS_SERVERS' in os.environ:
    DNS_SERVERS = os.environ['DNS_SERVERS']
else:
    DNS_SERVERS = []

if 'ELB_ARN' in os.environ:
    ELB_ARN = os.environ.get('ELB_ARN')
    print("INFO: ELB_ARN: {}".format(ELB_ARN))
else:
    print("ERROR: Missing Load Balancer ARN")
    sys.exit(1)

if 'MAX_LOOKUP_PER_INVOCATION' in os.environ:
    MAX_LOOKUP_PER_INVOCATION = int(os.environ['MAX_LOOKUP_PER_INVOCATION'])
    if MAX_LOOKUP_PER_INVOCATION < 1:
        print("ERROR: Invalid MAX_LOOKUP_PER_INVOCATION value.")
        sys.exit(1)
else:
    MAX_LOOKUP_PER_INVOCATION = 10

if 'REMOVE_UNTRACKED_TG_IP' in os.environ:
    REMOVE_UNTRACKED_TG_IP = os.environ['REMOVE_UNTRACKED_TG_IP'].capitalize()
    if isinstance(REMOVE_UNTRACKED_TG_IP, str) and \
            REMOVE_UNTRACKED_TG_IP == 'True':
        REMOVE_UNTRACKED_TG_IP = True
    elif isinstance(REMOVE_UNTRACKED_TG_IP, str) and \
            REMOVE_UNTRACKED_TG_IP == 'False':
        REMOVE_UNTRACKED_TG_IP = False
    elif isinstance(REMOVE_UNTRACKED_TG_IP, bool):
        REMOVE_UNTRACKED_TG_IP = REMOVE_UNTRACKED_TG_IP
    else:
        print("ERROR: Invalid REMOVE_UNTRACKED_TG_IP value. Expects "
              "boolean: True|False")
        sys.exit(1)
else:
    REMOVE_UNTRACKED_TG_IP = True

# MAIN Function - This function will be invoked when Lambda is called
def lambda_handler(event, context):
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)
    logger.info("INFO: Starting NLB target refresher.")
    logger.info("INFO: Received event: {}".format(json.dumps(event)))
    logger.info("INFO: REMOVE_UNTRACKED_TG_IP: {}".format(REMOVE_UNTRACKED_TG_IP))

    all_tg_arns = utils.get_all_target_group_arns(ELB_ARN)
    logger.info("INFO: all_tg_arns: {}".format(all_tg_arns))
    
    # Query DNS for hostname IPs
    try:
        for tg_arn in all_tg_arns:
            
            # Get Currently Resgistered IPs list
            registered_ip_list = utils.describe_target_ip_list(tg_arn)
            fqdn = utils.get_target_group_fqdn(tg_arn)
            if fqdn != "":
                logger.info("INFO: registered_ip_list: {}".format(registered_ip_list))
                hostname_ip_list = []
                logger.info("INFO: DNS lookup for: {}".format(fqdn))
                
                i= 1
                while i <= MAX_LOOKUP_PER_INVOCATION:
                    dns_lookup_result = utils.dns_lookup(DNS_SERVERS, fqdn, "A")
                    hostname_ip_list = dns_lookup_result + hostname_ip_list
                    if len(dns_lookup_result) < 8:
                        break
                    i += 1
                logger.info("INFO: DNS lookup result: {}".format(dns_lookup_result))

                # IPs that have not been registered, and missing from the old active IP list
                new_ips_to_register_list = list(set(hostname_ip_list) - set(registered_ip_list))
                old_ips_to_deregister_list = list(set(registered_ip_list)- set(hostname_ip_list))

                logger.info("INFO: new_ips_to_register_list:   {}".format(new_ips_to_register_list))
                logger.info("INFO: old_ips_to_deregister_list: {}".format(old_ips_to_deregister_list))

                # Register new targets
                if new_ips_to_register_list:
                    utils.register_target(tg_arn, new_ips_to_register_list)
                    logger.info(f"INFO: Registering {format(new_ips_to_register_list)}")
                else:
                    logger.info("INFO: No new IPs to register.")

                # Deregister old targets
                if old_ips_to_deregister_list:
                    if REMOVE_UNTRACKED_TG_IP:
                        logger.info("INFO: deregistering targets: {}".format(old_ips_to_deregister_list))
                        utils.deregister_target(tg_arn, old_ips_to_deregister_list)
                    else:
                        logger.info("INFO: would have deregistered these targets: {}".format(old_ips_to_deregister_list))
                else:
                    logger.info("INFO: No IPs to deregister.")

                # Report successful invocation
                logger.info("INFO: Update completed successfuly.")
            else:
                logger.info("INFO: No FQDN found for target group: {}".format(tg_arn))

    # Exception handler
    except Exception as e:
        logger.error(f"ERROR: Invocation failed., {e}")
        raise
        return(1)
    return (0)
