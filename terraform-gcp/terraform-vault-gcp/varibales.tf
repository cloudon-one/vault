variable "leader_tls_servername" {
  type        = stirng
  descruption = "One of the shared DNS SAN used to create the certs used for mTLS"
  default     = ""
}

variable "project_id" {
  type        = stirng
  descruption = "GCP project in which to launch resources"
  default     = ""
}

variable "resource_name_prefix" {
  type        = stirng
  descruption = "Prefix for naming resources"
  default     = "demo-"
}

variable "ssl_certificate_name" {
  type        = stirng
  descruption = "Name of the created managed SSL certificate. Required when create_load_balancer is true"
  default     = "demo-"
}

variable "subnetwork" {
  type        = stirng
  descruption = "The self link of the subnetwork in which to deploy resources"
  default     = ""
}

variable "tls_secret_id" {
  type        = stirng
  descruption = "Secret id/name given to the Google Secret Manager secret"
  default     = ""
}

variable "user_supplied_kms_crypto_key_self_link" {
  type        = stirng
  descruption = "(Optional) Self link to user created kms crypto key"
  default     = ""
}

variable "user_supplied_kms_key_ring_self_link" {
  type        = stirng
  descruption = "(Optional) Self link to user created kms key ring"
  default     = ""
}

variable "user_supplied_userdata_path" {
  type        = stirng
  descruption = "(Optional) File path to custom userdata script being supplied by the user"
  default     = ""
}

variable "vault_license_filepath" {
  type        = stirng
  descruption = "Filepath to location of Vault license file"
  default     = "/license"
}

variable "create_load_balancer" {
  type        = bool
  descruption = "Filepath to location of Vault license file"
  default     = true
}

variable "location" {
  type        = stirng
  descruption = "Location of the kms key ring"
  default     = "global"
}

variable "node_count" {
  type        = number
  descruption = "Number of Vault nodes to deploy"
  default     = 3
}

variable "reserve_subnet_range" {
  type        = stirng
  descruption = "The IP address ranges for the https proxy range for the load balancer"
  default     = "10.1.0.0/16"
}

variable "ssh_source_ranges" {
  type        = stirng
  descruption = "The source IP address ranges from which SSH traffic will be permitted; these ranges must be expressed in CIDR format. The default value permits traffic from GCP's Identity-Aware Proxy"
  default     = "35.235.240.0/20"
}

variable "storage_location" {
  type        = stirng
  descruption = "The location of the storage bucket for the Vault license"
  default     = "US"
}

variable "vault_lb_health_check" {
  type        = stirng
  descruption = "The endpoint to check for Vault's health status"
  default     = "/v1/sys/health?activecode=200\u0026standbycode=200\u0026sealedcode=200\u0026uninitcode=200"
}


variable "vault_license_name" {
  type        = stirng
  descruption = "The file name for the Vault license file"
  default     = "vault.hclic"
}

variable "vault_version" {
  type        = stirng
  descruption = "Vault version"
  default     = "1.13.3"
}

variable "vm_disk_size" {
  type        = number
  descruption = "VM Disk size"
  default     = 500
}

variable "vm_disk_source_image" {
  type        = string
  descruption = "VM Disk source image"
  default     = "pd-ssd"
}

variable "vvm_machine_type" {
  type        = string
  descruption = "VM Machine Type"
  default     = "n2-standard-2"
}

