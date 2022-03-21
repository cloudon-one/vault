terraform {
  backend "gcs" {
    bucket = "vault-poc-terraform"
    prefix = "tfstate"
  }
}