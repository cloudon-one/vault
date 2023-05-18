vault {
  address = "https://:8200" #VAULT_ADDR
  retry {
    num_retries = 3
  }
}
auto_auth {
  method "gcp" {
    mount_path = "auth/$PROJECT_ID" 
    config = {
      type = "gce"
      role = "gce-role"
    }
  }
  sink "file" {
    config = {
      path = "../tokens"
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
