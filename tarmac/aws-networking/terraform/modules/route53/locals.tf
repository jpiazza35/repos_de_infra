locals {

  # Create flattened list of all private zone to records association
  dns_records_private = flatten([
    for zone in var.dns_zones_private : [
      for record in zone.ResourceRecordSets : {
        zone_name = zone.ZoneDefinition.Name
        record    = record
      }
    ]
  ])

  # Create flattened list of all private zone to records association
  dns_records_public = flatten([
    for zone in var.dns_zones_public : [
      for record in zone.ResourceRecordSets : {
        zone_name = zone.ZoneDefinition.Name
        record    = record
      }
    ]
  ])

}
