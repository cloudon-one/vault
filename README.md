# HashiCorp Vault HA Cluster on GCP/AWS

## Requirments

- gcloud sdk
- vault binaries installed

### Exports GCP

```sh
export GOOGLE_CLOUD_PROJECT="playtika-vault-poc"
export VAULT_ADDR=https://34.140.99.22:8200
export VAULT_CACERT="ca.crt"
export VAULT_SA="vault-sa@playtika-vault-poc.iam.gserviceaccount.com"
export VAULT_DB="10.150.128.3"
```

### Vault init

```
vault status
```

```
vault operator init \
    -recovery-shares 5 \
    -recovery-threshold 3
```

### Recovery keys

```
Recovery Key 1: Xk44rZO3oVkDIBfAFBI2WLjKLzS0CfUyaZco5TjT7lLq
Recovery Key 2: T+vqCJRejgfJd+gck4QKBIn8gl6x+YEz0QRo1+WFm2Qb
Recovery Key 3: B0G/sjfDnhr17yusM1T+qb7OP6km5TlU/m48oDcE9Ywl
Recovery Key 4: 6UJzSgAAgKaHD9hxWTYOZnQDQHeDo+9c49LMKYSPui7M
Recovery Key 5: VJ9O1VLwGRkVnVYpY1Zma9gBPs7YRdVQET2u7aG7gLlE

Initial Root Token: s.B3MeNW4KTG3M4mUkMa5iUjWC
```

### Enable Postgres as secrets db (private sql instance)

```
vault write database/config/vault-poc \
plugin_name=postgresql-database-plugin \
allowed_roles="*" \
connection_url="postgresql://{{username}}:{{password}}@$VAULT_DB:5432/" \
username="vaultuser" \
password="vaultpass"
```

### Vault config hcl

```
vault server -config=/etc/vault/config.hcl
```

### Vault with GCP Cloud KMS

```
vault write gcpkms/config \
credentials=@vault.json

vault write gcpkms/keys/vault \
key_ring=projects/playtika-vault-poc/locations/global/keyRings/vault \
rotation_period=72h
```

```
vault write gcpkms/keys/vault\
key_ring=projects/playtika-vault-poc/locations/global/keyRings/vault \
purpose=encrypt_decrypt \
algorithm=symmetric_encryption
```
  
### Enable GCP auth

```
vault secrets enable -path=gcp gcp
vault write gcp/config credentials=@vault.json
```

### Generate login tooken

vault login -method=gcp \
role="demo-role" \
service_account="vault-sa@playtika-vault-poc.iam.gserviceaccount.com" \
jwt_exp="15m" \
credentials=@vault.json

```

 ```

vault write auth/gcp/config \
credentials=@vault.json

```

### Create vault GCP role with IAM

```

vault write auth/gcp/role/vault \
type="iam" \
policies="dev,prod" \
bound_service_accounts="[vault-sa@playtika-vault-poc.iam.gserviceaccount.com]"
{
"plugin_name": "postgresql-database-plugin",
"allowed_roles": "*",
"connection_url": "postgresql://{{username}}:{{password}}@$10.150.128.3:5432/vault",
"max_open_connections": 5,
"max_connection_lifetime": "5s",
"username": "postgres",
"password": "QazWsx12"
}

```

### Create GCP roleset

 ```

vault write gcp/roleset/demo-roleset \
project="playtika-vault-poc" \
secret_type="service_account_key" \
bindings=-<<EOF
resource "//cloudresourcemanager.googleapis.com/projects/playtika-vault-poc" {
roles = ["roles/editor"]
}
EOF

```

vault read gcp/roleset/demo-roleset/token


### Static accounts

vault write gcp/static-account/vault-sa \
    service_account_email="vault-sa@playtika-vault-poc.iam.gserviceaccount.com" \
    secret_type="access_token"  \
    token_scopes="https://www.googleapis.com/auth/cloud-platform" \
    bindings=-<<EOF
resource "//cloudresourcemanager.googleapis.com/projects/playtika-vault-poc" {
roles = ["roles/editor"]
}
EOF

vault write gcp/static-account/vault-sa \
    service_account_email="vault-sa@playtika-vault-poc.iam.gserviceaccount.com" \
    secret_type="service_account_key"  \
    bindings=-<<EOF
resource "//cloudresourcemanager.googleapis.com/projects/playtika-vault-poc" {
roles = ["roles/editor"]
}
EOF


### Create dynamic keys and store to template

```

vault write database/roles/demo \
db_name=vault \
creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
default_ttl="1h" \
max_ttl="24h"

```
  
### Validate keys creation

```

vault read database/creds/demo

```


# Vault cluster and client on AWS

### Connection settings

Vault Server IP (public):  52.30.46.236, 34.255.1.246
Vault Server IP (private): 10.0.101.13, 10.0.101.196

For example:
   ssh -i vault-poc.pem ubuntu@52.30.46.236

Vault Client IP (public):  34.245.189.6
Vault Client IP (private): 10.0.101.15

For example:
   ssh -i vault-poc.pem ubuntu@34.245.189.6

### Vault keys 
```

vault operator init
Recovery Key 1: LXhVjj6QYK6jRCRvAekN1ux1bho/4Ono40jSMPqViJEg
Recovery Key 2: CIcQngjDlcjitxKrElZxOX3uFk5vGyWm+571ZKeqQe8c
Recovery Key 3: Vi9lm+KdCnxv3EtglERC6yvz0zdV7k1v8WtU5Q+ohJeT
Recovery Key 4: fn8IfdugCyvNT1Ed/icTnFlY9WnNlNSX8g1JsLRsJ4xj
Recovery Key 5: HwyaNmfQzM16NEsqUkSC6eoFBzp1mqz7y6B6V1tiEcrM

Initial Root Token: s.CedGUqTOuyqTsucidL9rm623

```

# Configure dynamic secrets and store them to postgres db 

vault write database/config/postgresql \
     plugin_name=postgresql-database-plugin \
     connection_url="postgresql://{{username}}:{{password}}@localhost:5432/postgres?sslmode=disable" \
     allowed_roles=readonly \
     username="postgres" \
     password="QazWsx12"


vault write database/roles/demo-role \
    db_name=postgres \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
        GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
    default_ttl="1h" \
    max_ttl="24h"



vault write aws/config/root \
    access_key=ASIA53FYVOWBJD7HESNM \
    secret_key=sB4NF6ifWlr9dZ2f2HrYjS2407o84H4mDV3SAZFl \
    region=eu-west-1



vault write aws/roles/demo-role \
    credential_type=iam_user \
    policy_document=-<<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:*",
      "Resource": "*"
    }
  ]
}
EOF

vault read aws/creds/demo-role
