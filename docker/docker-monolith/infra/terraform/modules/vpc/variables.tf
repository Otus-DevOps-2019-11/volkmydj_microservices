variable service_port {
  default = 9292
}

variable service_port_name {
  default = "tcp-9292"
}

variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable "source_ranges" {
  description = "Allowed IP addresses"
  default     = ["0.0.0.0/0"]
}
