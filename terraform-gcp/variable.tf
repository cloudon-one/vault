variable "project_id" {
  type    = string
  default = "vault-poc-344807" #TS sandbox
}

variable "allow_public_egress" {
  type    = bool
  default = true
}

variable "kms_crypto_key" {
  type    = string
  default = "vault-init"
}

variable "ssh_allowed_cidrs" {
  type    = string
  default = "0.0.0.0/0"
}
variable "domain" {
  type    = string
  default = "vault.cloudon.one"
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

variable "project_services" {
  type = list(string)
  default = [
    "cloudkms.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com"
  ]
}

variable "service_account_name" {
  type    = string
  default = "vault-sa"
}

variable "vault_version" {
  type    = string
  default = "1.9.4"
}

variable "tls_ca_subject" {
  type = object({
    common_name         = string,
    organization        = string,
    organizational_unit = string,
    street_address      = list(string),
    locality            = string,
    province            = string,
    country             = string,
    postal_code         = string,
  })
  default = {
    "common_name" : "CloudOn Inc. Root",
    "country" : "Israel",
    "locality" : "The Intranet",
    "organization" : "CloudOn, Inc",
    "organizational_unit" : "Department of Certificate Authority",
    "postal_code" : "95559-1227",
    "province" : "Israel",
    "street_address" : [
      "123 CloudOn Street"
    ]
  }
}

variable "tls_cn" {
  type    = string
  default = "vault-demo.cloudon.one"
}

variable "tls_dns_names" {
  type = list(string)
  default = [
    "vault-demo.cloudone.one",
    "vault-demo.terasky.com"
  ]
}
