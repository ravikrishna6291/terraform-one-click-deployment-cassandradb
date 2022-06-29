resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "ssh_private_key_pem" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = var.key_filename
  file_permission = "0600"
  depends_on = [
    tls_private_key.ssh
  ]
}

resource "google_compute_address" "static_ip" {
  name         = var.ip_name
  subnetwork   = var.sub_network
  address_type = var.address_type
  address      = var.ip_address
  region       = var.region
}

data "google_client_openid_userinfo" "me" {}

resource "google_compute_instance" "debian_vm" {
  name         = var.vm_name
  machine_type = var.machine_type
  tags         = ["allow-ssh"] // this receives the firewall rule

  metadata = {
    ssh-keys = "${split("@", data.google_client_openid_userinfo.me.email)[0]}:${tls_private_key.ssh.public_key_openssh}"
  }

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = var.network
    network_ip = google_compute_address.static_ip.address
  }
  depends_on = [
    google_compute_address.static_ip, local_file.ssh_private_key_pem
  ]

  provisioner "file" {
    connection {
      host        = google_compute_address.static_ip.address
      type        = "ssh"
      user        = var.user
      timeout     = "60s"
      private_key = file(local_file.ssh_private_key_pem.filename)
    }
      source      = var.source_file_yaml
      destination = var.destination_path_yaml
  }

  provisioner "file" {
    connection {
      host        = google_compute_address.static_ip.address
      type        = "ssh"
      user        = var.user
      timeout     = "60s"
      private_key = file(local_file.ssh_private_key_pem.filename)
    }
      source      = var.source_file_properties
      destination = var.destination_path_properties
  }

  provisioner "file" {
    connection {
      host        = google_compute_address.static_ip.address
      type        = "ssh"
      user        = var.user
      timeout     = "60s"
      private_key = file(local_file.ssh_private_key_pem.filename)
    }
      source      = var.source_file_service
      destination = var.destination_path_service
  }

  provisioner "remote-exec" {
    connection {
      host        = google_compute_address.static_ip.address
      type        = "ssh"
      user        = var.user
      timeout     = "500s"
      private_key = file(local_file.ssh_private_key_pem.filename)
    }
    script = var.script_path
  }

}

