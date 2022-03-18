module "vault" {
  source                = "terraform-google-modules/vault/google"
  version               = "6.1.1"
  project_id            = var.project_id
  allow_public_egress   = var.allow_public_egress
  kms_crypto_key        = var.kms_crypto_key
  kms_keyring           = var.kms_keyring
  load_balancing_scheme = var.load_balancing_scheme
  region                = var.region
}
