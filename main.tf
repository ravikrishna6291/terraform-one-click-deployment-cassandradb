resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "ssh_private_key_pem" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = ".ssh/google_compute_engine"
  file_permission = "0600"
  depends_on = [
    tls_private_key.ssh
  ]
}

resource "google_compute_address" "static_ip" {
  name         = "my-internal-address"
  subnetwork   = "default"
  address_type = "INTERNAL"
  address      = "10.128.15.211"
  region       = "us-central1"
}

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

data "google_client_openid_userinfo" "me" {}

resource "google_compute_instance" "debian_vm" {
  name         = "debian"
  machine_type = "f1-micro"
  tags         = ["allow-ssh"] // this receives the firewall rule

  metadata = {
    ssh-keys = "${split("@", data.google_client_openid_userinfo.me.email)[0]}:${tls_private_key.ssh.public_key_openssh}"
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"
    network_ip = google_compute_address.static_ip.address
  }
  depends_on = [
    google_compute_address.static_ip , google_compute_firewall.allow_ssh , local_file.ssh_private_key_pem
  ]

  provisioner "file" {
    connection {
      host        = google_compute_address.static_ip.address
      type        = "ssh"
      user        = "terraform"
      timeout     = "60s"
      private_key = file(local_file.ssh_private_key_pem.filename)
    }
      source      = "./cassandra.yml"
      destination = "/home/terraform/cassandra.yml"
      
  }
  provisioner "file" {
    connection {
      host        = google_compute_address.static_ip.address
      type        = "ssh"
      user        = "terraform"
      timeout     = "60s"
      private_key = file(local_file.ssh_private_key_pem.filename)
    }
      source      = "./cassandra-rackdc.properties"
      destination = "/home/terraform/cassandra-rackdc.properties"
      
  }
  provisioner "file" {
    connection {
      host        = google_compute_address.static_ip.address
      type        = "ssh"
      user        = "terraform"
      timeout     = "60s"
      private_key = file(local_file.ssh_private_key_pem.filename)
    }
      source      = "./cassandra.service"
      destination = "/home/terraform/cassandra.service"
      
  }
  

  provisioner "remote-exec" {
    connection {
      host        = google_compute_address.static_ip.address
      type        = "ssh"
      user        = "terraform"
      timeout     = "500s"
      private_key = file(local_file.ssh_private_key_pem.filename)
    }
    script = "./script.sh"
  }

}

