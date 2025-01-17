/**
 * Usage:
 *
 * ```hcl
 *
 * module "module_name" {
 *   source = "location-of-module"
 *   version = "0.1.0"
 * 
 *   project_name = var.project_name(string)
 *   billing_account_id = var.input(string)
 *   parent_folder = var.input(string)
 *   enabled_apis = var.input(list(string))
 *   iam_group = var.input(string)
 *   iam_project_role = var.input(string)
 *   labels = var.input(map(string))
 *   
 * }
 * ```
**/

locals {
  project_id     = "lbg-${var.project_name}"
  default_labels = {}
}

resource "google_project" "proj" {
  name                = var.project_name
  project_id          = local.project_id
  auto_create_network = false
  billing_account     = var.billing_account_id
  folder_id           = var.parent_folder
  skip_delete         = false
  labels              = length(var.labels) > 0 ? var.labels : local.default_labels
}

resource "google_project_service" "enabled_apis" {
  for_each                   = toset(var.project_apis)
  service                    = each.value
  project                    = google_project.proj.project_id
  disable_dependent_services = true

  depends_on = [
    google_project.proj
  ]
}

resource "time_sleep" "api_sleep_timer" {
  create_duration = var.sleep_time

  triggers = {
    api_list     = join(", ", var.project_apis)
    project_id   = local.project_id
    project_name = var.project_name
  }

  depends_on = [
    google_project_service.enabled_apis
  ]
}


resource "google_project_default_service_accounts" "my_project" {
  project = google_project.proj.id
  action  = "DELETE"
}

resource "google_service_account" "sa" {
  account_id   = "${var.project_name}-sa"
  display_name = "Service Account for ${var.project_name}"
}

data "google_iam_policy" "sa_user" {
  binding {
    role = "roles/iam.serviceAccountUser"

    members = [
      "group:${var.iam_group}",
    ]
  }
}

resource "google_service_account_iam_policy" "admin-account-iam" {
  service_account_id = google_service_account.sa.name
  policy_data        = data.google_iam_policy.sa_user.policy_data
}


resource "google_project_iam_policy" "project" {
  project     = google_project.proj.id
  policy_data = data.google_iam_policy.admin.policy_data
}

data "google_iam_policy" "admin" {
  binding {
    role = var.iam_project_role

    members = [
      "serviceaccount:${google_service_account.sa.email}",
      "group:${var.iam_group}"
    ]
  }
}
