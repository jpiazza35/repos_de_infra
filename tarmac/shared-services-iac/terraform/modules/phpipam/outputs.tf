/* output vpc {
  value = format("%s/%s", phpipam_first_free_subnet.new_subnet[0].subnet_address, phpipam_first_free_subnet.new_subnet[0].subnet_mask)
} */

/* output "azure" {
  value = data.phpipam_subnet.azure
} */
