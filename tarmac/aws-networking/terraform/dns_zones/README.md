### DNS Zones
This directory contains json files of all the public and private dns zones in the `SS_NETWORK` account.

To create a new dns zone (or import an existing zone for management by terraform), create a new file named <hosted_zone_name>.json. The hosted zone name can either be for a primary domain or subdomain.

The zoneDefinition helps terraform know whether you're creating a primary or subdomain. For a primary domain, the value for the `"Parent"` key should be null. However, for a subdomain, the value should be the name of the primary domain. For instance, to create a subdomain hosted zone called `qa.cliniciannexus.com`, the `"Parent ` would be `cliniciannexus.com`.

The dns zone file should be structured as follows and can support the creation of the dns records, if any:

```json
{
    "ZoneDefinition": {
        "Name": "<hosted_zone>.<domain_name>",
        "Parent": null | "<primary_domain_name>"
    },
    "ResourceRecordSets": [
      ## For alias records
        {
            "Name": "<alias_record_name>.",
            "Type": "A" | "AAAA" | "CAA" | "CNAME" | "DS" | "MX" | "NAPTR" | "PTR" | "SPF" | "SRV" | "TXT",
            "AliasTarget": {
                "HostedZoneId": "<hosted_zone_id of alias resource>",
                "DNSName": "<dns name of alias resource>.",
                "EvaluateTargetHealth": true | false
            }
        },
        ## For simple routing records
        {
            "Name": "<record_name>.",
            "Type": "A" | "AAAA" | "CAA" | "CNAME" | "DS" | "MX" | "NAPTR" | "NS" | "PTR" | "SOA" | "SPF" | "SRV" | "TXT",
            "TTL": <ttl>,
            "ResourceRecords": [
                {
                    "Value": "<record value/target>."
                }
            ]
        },
        ## For weighted routing records
        {
            "Name": "<record_name>.",
            "Type": "A" | "AAAA" | "CAA" | "CNAME" | "DS" | "MX" | "NAPTR" | "PTR" | "SPF" | "SRV" | "TXT",
            "TTL": <ttl>,
            "SetIdentifier": "<set_identifier>",
            "HealthCheckId": "<health_check_id>",
            "Weight": <weight>,
            "ResourceRecords": [
                {
                    "Value": "<record value/target>."
                }
            ]
        }
    ]
}
```
