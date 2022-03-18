variable "project_id" {
  type    = string
  default = "cloudops-dev-eu-svc-1afa" #TS sandbox
}

variable "allow_public_egress" {
  type    = bool
  default = true
}

variable "kms_crypto_key" {
  type    = string
  default = "vault-init"
}

variable "kms_keyring" {
  type    = string
  default = "vault"
}

variable "load_balancing_scheme" {
  type    = string
  default = "EXTERNAL"
}

variable "region" {
  type    = string
  default = "europe-west1"
}
