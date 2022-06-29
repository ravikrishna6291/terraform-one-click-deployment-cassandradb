resource "google_compute_firewall" "allow_ssh" {
  name          = "allow-ssh"
  network       = "default"
  target_tags   = ["allow-ssh"] // this targets our tagged VM
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

module "cluster-1" {
  source = "./vm_config"

  key_filename                = "./ssh/cassandra1"
  ip_name                     = "cassandra1"
  sub_network                 = "default"
  address_type                = "INTERNAL"
  ip_address                  = "10.128.15.211"
  region                      = "us-central1"
  vm_name                     = "cassandra1"
  machine_type                = "n2-standard-2"
  image                       = "debian-cloud/debian-9"
  network                     = "default"
  user                        = "terraform"
  source_file_yaml            = "./vm_config/cassandra.yml"
  destination_path_yaml       = "/home/terraform/cassandra.yml"
  source_file_properties      = "./vm_config/cassandra-rackdc.properties"
  destination_path_properties = "/home/terraform/cassandra-rackdc.properties"
  source_file_service         = "./vm_config/cassandra.service"
  destination_path_service    = "/home/terraform/cassandra.service"
  script_path                 = "./vm_config/script.sh"

  depends_on = [
    google_compute_firewall.allow_ssh
  ]
  
}


module "cluster-2" {
  source = "./vm_config"

  key_filename                = "./ssh/cassandra2"
  ip_name                     = "cassandra2"
  sub_network                 = "default"
  address_type                = "INTERNAL"
  ip_address                  = "10.128.15.212"
  region                      = "us-central1"
  vm_name                     = "cassandra2"
  machine_type                = "n2-standard-2"
  image                       = "debian-cloud/debian-9"
  network                     = "default"
  user                        = "terraform"
  source_file_yaml            = "./vm_config/cassandra.yml"
  destination_path_yaml       = "/home/terraform/cassandra.yml"
  source_file_properties      = "./vm_config/cassandra-rackdc.properties"
  destination_path_properties = "/home/terraform/cassandra-rackdc.properties"
  source_file_service         = "./vm_config/cassandra.service"
  destination_path_service    = "/home/terraform/cassandra.service"
  script_path                 = "./vm_config/script.sh"

  depends_on = [
    google_compute_firewall.allow_ssh
  ]
  
}

module "cluster-3" {
  source = "./vm_config"

  key_filename                = "./ssh/cassandra3"
  ip_name                     = "cassandra3"
  sub_network                 = "default"
  address_type                = "INTERNAL"
  ip_address                  = "10.128.15.213"
  region                      = "us-central1"
  vm_name                     = "cassandra3"
  machine_type                = "n2-standard-2"
  image                       = "debian-cloud/debian-9"
  network                     = "default"
  user                        = "terraform"
  source_file_yaml            = "./vm_config/cassandra.yml"
  destination_path_yaml       = "/home/terraform/cassandra.yml"
  source_file_properties      = "./vm_config/cassandra-rackdc.properties"
  destination_path_properties = "/home/terraform/cassandra-rackdc.properties"
  source_file_service         = "./vm_config/cassandra.service"
  destination_path_service    = "/home/terraform/cassandra.service"
  script_path                 = "./vm_config/script.sh"

  depends_on = [
    google_compute_firewall.allow_ssh
  ]
  
}

