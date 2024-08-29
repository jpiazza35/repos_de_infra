data "template_file" "instance_user_data" {
  template = file("user_data.sh")
}

data "template_file" "instance_user_data2" {
  template = file("user_data2.sh")
} 