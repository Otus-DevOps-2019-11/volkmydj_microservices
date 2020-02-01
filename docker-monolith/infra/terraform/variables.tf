variable project {
  description = "Project ID"
}

variable app_name {
  default = "Project app name"
}

variable region {
  default     = "europe-west1"
  description = "Region"
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
  default     = ["appuser"]
  description = "Users"
}

variable service_port {
  default     = 9292
  description = "Service Port"
}

variable service_port_name {
  default     = "tcp-9292"
  description = "Name for service port"
}

variable instance_count {
  type        = number
  default     = 1
  description = "Count"
}
