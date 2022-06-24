resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.example_ssh.private_key_pem
  filename        = "example.pem"
  file_permission = "0600"
}


resource "google_compute_address" "ip" {
  name         = "my-internal-address"
  subnetwork   = "default"
  address_type = "INTERNAL"
  address      = "10.128.15.211"
  region       = "us-central1"
}

resource "google_compute_instance" "dev1" {
  name         = "gcp-rhel7-dev1-tf"
  machine_type = "f1-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

  network_interface {
    network = "default"
    network_ip = google_compute_address.ip.address
  }

   provisioner "remote-exec" {
connection {
  host = google_compute_address.ip.address
  type = "ssh"
  port = 22
  user = "gcptrial00"
  agent = "false"
  private_key = local_file.private_key.content
}
 inline = [
 "touch test",
  ]
}

   metadata = {
    ssh-keys = "root:${tls_private_key.example_ssh.public_key_openssh}"
  }
}