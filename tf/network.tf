locals {
  vpc_name     = "dokku-network"
  vpc_sub_name = "dokku-subnetwork"
}

resource "google_compute_network" "this" {
  name                    = local.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "this" {
  name                     = local.vpc_sub_name
  ip_cidr_range            = "10.200.0.0/20"
  region                   = var.region
  network                  = google_compute_network.this.self_link
  private_ip_google_access = true
}

# Firewall rules
resource "google_compute_firewall" "web" {
  name    = "dokku-network-web-firewall"
  network = google_compute_network.this.name

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "443"]
  }


  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web"]
}

resource "google_compute_firewall" "ssh" {
  name    = "dokku-network-ssh-firewall"
  network = google_compute_network.this.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["ssh"]
}

# IP addresses
resource "google_compute_address" "engine_internal" {
  name         = "dokku-network-engine-internal-ip"
  region       = var.region
  address_type = "INTERNAL"
  subnetwork   = google_compute_subnetwork.this.self_link
  address      = "10.200.0.2"
}

resource "google_compute_address" "engine_external" {
  name         = "dokku-network-engine-external-ip"
  region       = var.region
  address_type = "EXTERNAL"
}