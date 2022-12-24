resource "random_password" "aw_value" {
  length  = 24
  special = true
  upper   = true
  lower   = true
  numeric = true
}

output "aw_value" {
  value     = random_password.aw_value.result
  sensitive = true
}

resource "google_secret_manager_secret" "aw" {
  secret_id = "awesome-secret"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "aw_version" {
  secret      = google_secret_manager_secret.aw.id
  secret_data = random_password.aw_value.result
}