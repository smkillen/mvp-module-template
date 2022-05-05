variable "billing_account_id" {
  type        = string
  description = "Billing account to link project"
}

variable "labels" {
  type        = map(string)
  description = "Optional map of label key-value pairs"
}

variable "parent_folder" {
  type        = string
  description = "Folder ID that this project will be created in"
}

variable "project_name" {
  type        = string
  description = "Name to give to the project"
}

variable "project_apis" {
  type        = list(string)
  description = "Google APIs to enable on this project"
  default = [
    "compute.googleapis.com",
    "pubsub.googleapis.com",
    "storage.googleapis.com",
    "redis.googleapis.com",
    "secretmanager.googleapis.com"
  ]
}

variable "iam_group" {
  type        = string
  description = "Precreated group that can act on this project"
}

variable "iam_project_role" {
  type        = string
  description = "The role that applied to the SA/Project"
}

variable "sleep_time" {
  type        = string
  description = "Length of time for Terraform to sleep after API enablement in the format, 30s, 10m, 1h"
  default     = "30s"
}
