output "ca_cert_pem" {
  value = module.vault.ca_cert_pem
}

output "ca_key_pem" {
  value = module.vault.ca_key_pem
}

output "service_account_email" {
  value = module.vault.service_account_email
}

output "vault_addr" {
  value = module.vault.vault_addr
}

output "vault_lb_addr" {
  value = module.vault.vault_lb_addr
}

output "vault_lb_port" {
  value = module.vault.vault_lb_port
}

output "vault_nat_ips" {
  value = module.vault.vault_nat_ips
}

output "vault_network" {
  value = module.vault.vault_network
}

output "vault_storage_bucket" {
  value = module.vault.vault_storage_bucket
}

output "vault_subnet" {
  value = module.vault.vault_subnet
}
