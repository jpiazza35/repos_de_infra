resource "nexus_security_ldap" "cliniciannexus_ldap_config" {
  auth_password                  = jsondecode(data.aws_secretsmanager_secret_version.sonatype_secret_version.secret_string)["ldap_password"]
  auth_username                  = "sonatype_sa@sca.local"
  auth_schema                    = "SIMPLE"
  connection_retry_delay_seconds = 5
  connection_timeout_seconds     = 5
  group_type                     = "dynamic"
  host                           = "10.202.4.68"
  ldap_groups_as_roles           = true
  max_incident_count             = 1
  name                           = "cn-ldap"
  port                           = 389
  protocol                       = "LDAP"
  search_base                    = "DC=sca,DC=local"
  user_base_dn                   = "OU=Managed Users"
  user_email_address_attribute   = "mail"
  user_id_attribute              = "sAMAccountName"
  user_ldap_filter               = "(&(|(memberOf=CN=NexusAdmins,OU=SonatypeNexus,OU=ByRole,OU=Managed Groups,DC=sca,DC=local) (memberOf=CN=NexusDataPlatform,OU=SonatypeNexus,OU=ByRole,OU=Managed Groups,DC=sca,DC=local)(memberOf=CN=NexusDevs,OU=SonatypeNexus,OU=ByRole,OU=Managed Groups,DC=sca,DC=local)))"
  user_object_class              = "user"
  user_real_name_attribute       = "cn"
  user_subtree                   = true
  user_member_of_attribute       = "memberOf"
}
