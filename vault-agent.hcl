vault {
  address = "https://34.76.211.38:8200"
  retry {
    num_retries = 3
  }
}
auto_auth {
  method "gcp" {
    mount_path = "auth/vault-poc-344807"
    config = {
      type = "gce"
      role = "gce-role"
    }
  }
  sink "file" {
    config = {
      path = "/tokens/vault-token-via-agent"
      mode = 0644
    }
  }
}
cache {
  use_auth_auth_token = true
}
listener "tcp" {
  address     = "127.0.0.1:8100"
  tls_disable = true
}
