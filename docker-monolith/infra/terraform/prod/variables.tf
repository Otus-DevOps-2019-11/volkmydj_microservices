variable project {
  description = "Project ID"
}

variable app_name {
  default = "Project app name"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}

variable public_key_path {

  description = "Path to the public key used for ssh access"
}

variable disk_image {
  description = "Disk Image"
}

variable private_key {
  description = "Path to the private key used for ssh access"
}

variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable users {
  default = ["appuser", "appuser1", "appuser2", "appuser3"]
}

variable service_port {
  default = 9292
}

variable service_port_name {
  default = "tcp-9292"
}
variable instances_count {
  type    = number
  default = 1
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-docker-host"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}

variable my_ip {
  description = "My IP"
}

variable source_ranges {
  default = "0.0.0.0/0"
}
