output "app_external_ip" {
  value = join(
    " ",
    google_compute_instance.app-docker.*.network_interface.0.access_config.0.nat_ip,
  )
}
