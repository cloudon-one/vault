module "vault" {
  source                                       = "terraform-google-modules/vault/google"
  version                                      = "6.1.1"
  project_id                                   = var.project_id
  allow_public_egress                          = var.allow_public_egress
  allow_ssh                                    = var.allow_ssh
  domain                                       = var.domain
  http_proxy                                   = var.http_proxy
  kms_crypto_key                               = var.kms_crypto_key
  kms_keyring                                  = var.kms_keyring
  kms_protection_level                         = var.kms_protection_level
  load_balancing_scheme                        = var.load_balancing_scheme
  manage_tls                                   = var.manage_tls
  network                                      = var.network
  network_subnet_cidr_range                    = var.network_subnet_cidr_range
  project_services                             = var.project_services
  region                                       = var.region
  service_account_name                         = var.service_account_name
  service_account_project_additional_iam_roles = var.service_account_project_additional_iam_roles
  service_account_project_iam_roles            = var.service_account_project_iam_roles
  service_account_storage_bucket_iam_roles     = var.service_account_storage_bucket_iam_roles
  service_label                                = var.service_label
  ssh_allowed_cidrs                            = var.ssh_allowed_cidrs
  storage_bucket_class                         = var.storage_bucket_class
  storage_bucket_enable_versioning             = var.storage_bucket_enable_versioning
  storage_bucket_force_destroy                 = var.storage_bucket_force_destroy
  storage_bucket_lifecycle_rules               = var.storage_bucket_lifecycle_rules
  storage_bucket_location                      = var.storage_bucket_location
  storage_bucket_name                          = var.storage_bucket_name
  subnet                                       = var.subnet
  tls_ca_subject                               = var.tls_ca_subject
  tls_cn                                       = var.tls_cn
  tls_dns_names                                = var.tls_dns_names
  tls_ips                                      = var.tls_ips
  tls_ou                                       = var.tls_ou
  tls_save_ca_to_disk                          = var.tls_save_ca_to_disk
  user_startup_script                          = var.user_startup_script
  vault_allowed_cidrs                          = var.vault_allowed_cidrs
  vault_args                                   = var.vault_args
  vault_ca_cert_filename                       = var.vault_ca_cert_filename
  vault_instance_base_image                    = var.vault_instance_base_image
  vault_instance_labels                        = var.vault_instance_labels
  vault_instance_metadata                      = var.vault_instance_metadata
  vault_instance_tags                          = var.vault_instance_tags
  vault_log_level                              = var.vault_log_level
  vault_machine_type                           = var.vault_machine_type
  vault_max_num_servers                        = var.vault_max_num_servers
  vault_min_num_servers                        = var.vault_min_num_servers
  vault_port                                   = var.vault_port
  vault_proxy_port                             = var.vault_proxy_port
  vault_tls_bucket                             = var.vault_tls_bucket
  vault_tls_cert_filename                      = var.vault_tls_cert_filename
  vault_tls_disable_client_certs               = var.vault_tls_disable_client_certs
  vault_tls_key_filename                       = var.vault_tls_key_filename
  vault_tls_kms_key                            = var.vault_tls_kms_key
  vault_tls_kms_key_project                    = var.vault_tls_kms_key_project
  vault_tls_require_and_verify_client_cert     = var.vault_tls_require_and_verify_client_cert
  vault_ui_enabled                             = var.vault_ui_enabled
  vault_update_policy_type                     = var.vault_update_policy_type
  vault_version                                = var.vault_version
}
