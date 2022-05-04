output "project_id" {
  value       = google_project.proj.project_id
  description = "The ID of the created project"
}

output "project_number" {
  value       = google_project.proj.number
  description = "The number of the created project"
}

output "service_account" {
  value       = google_service_account.sa.name
  description = "the name of the service account for the project"
}