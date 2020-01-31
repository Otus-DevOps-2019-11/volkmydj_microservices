provider "google" {
  version = "~> 2.15.0"
  project = var.project
  region  = var.region
}

provider "null" {
  version = "~> 2.1"
}

module "app" {
  project         = var.project
  app_name        = "${var.app_name}"
  source          = "../modules/app"
  public_key_path = "${var.public_key_path}"
  zone            = "${var.zone}"
  app_disk_image  = "${var.app_disk_image}"
  private_key     = var.private_key
}


# module "vpc" {
#   source        = "../modules/vpc"
#   zone          = "${var.zone}"
#   source_ranges = "${var.my_ip}"
# }

resource "template_file" "dynamic_inventory" {
  template = file("dynamic_inventory.json")
  vars = {
    app_ext_ip = "${module.app.app_external_ip}"
  }
}
