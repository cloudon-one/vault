pid_file = "./pidfile"

auto_auth {
  method "aws" {
    mount_path = "auth/aws"
    config = {
      type = "iam"
      role = "app-role"
    }
  }

  sink "file" {
    config = {
      path = "/home/ubuntu/vault-token-via-agent"
    }
  }
}

vault {
  address = "http://:8200"
}

template {
  source      = "/home/ubuntu/customer.tmpl"
  destination = "/home/ubuntu/customer.txt"
}
