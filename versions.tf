terraform {
  required_version = "~> 1.0.1"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.70.0, < 4.0.0"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 3.78.0, < 4.0.0"
    }

    time = {
      source  = "hashicorp/time"
      version = "0.7.2"
    }
  }
}
