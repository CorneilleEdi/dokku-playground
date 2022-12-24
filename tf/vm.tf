# Create an ubuntu vm with boot disk and data disk
data "google_compute_image" "debian_image" {
  family  = "debian-11"
  project = "debian-cloud"
}

resource "google_compute_disk" "data" {
  name = "ubuntu-data-disk"
  type = "pd-ssd"
  zone = var.zone
  size = "20"
}

resource "google_compute_attached_disk" "default" {
  disk     = google_compute_disk.data.id
  instance = google_compute_instance.this.id
}

resource "google_compute_instance" "this" {
  name         = "dokku-engine"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian_image.self_link
    }
  }

  network_interface {
    network    = google_compute_network.this.name
    subnetwork = google_compute_subnetwork.this.name

    access_config {
      nat_ip = google_compute_address.engine_external.address
    }
    network_ip = google_compute_address.engine_internal.address
  }

  tags = ["ssh", "web"]

}