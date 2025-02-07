terraform {
  required_version = ">= 0.14.0"
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.9.0"
    }

	kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    kustomize = {
      source = "kbst/kustomize"
      version = "0.5.0"
    }
  }
}