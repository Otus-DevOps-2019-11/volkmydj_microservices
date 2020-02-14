output "apps_external_ip" {
  value = "${module.gitlab.app_external_ip}"
}

output "dynamic_inventory" {
  value = "${template_file.dynamic_inventory.rendered}"
}
