exit_after_auth = true
pid_file        = "./pidfile"

auto_auth {
  method "gcp" {
    mount_path = "auth/gcp"
    config = {
      type = "iam"
      role = "demo"
    }
  }

  sink "file" {
    config = {
      path = "/Users/ynaumenko/desktop/work/ts/vault/terraform-gcp/vault-token-via-agent"
      mode = 0644
    }
  }
}

vault {
  address = "https://34.76.211.38:8200"
}
