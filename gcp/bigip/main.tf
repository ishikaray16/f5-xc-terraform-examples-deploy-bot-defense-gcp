provider "google" {
  project = local.project_id
  region  = local.region
}

provider "github" {
  token = var.github_token
}
