# HashiCorp Vault HA Cluster on GCP/AWS

## Requirments

- gcloud sdk
- vault binaries installed

### Exports GCP

```sh
export GOOGLE_CLOUD_PROJECT=""
export VAULT_ADDR=https://:8200
export VAULT_CACERT="ca.crt"
export VAULT_SA="vault-sa@pGOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com"
export VAULT_DB=""
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

### Enable Postgres as secrets db (private sql instance)

```
vault write database/config/vault-poc \
plugin_name=postgresql-database-plugin \
allowed_roles="*" \
connection_url="postgresql://{{username}}:{{password}}@$VAULT_DB:5432/" \
username="" \
password=""
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
key_ring=projects/$GOOGLE_CLOUD_PROJECT/locations/global/keyRings/vault \
rotation_period=72h
```

```
vault write gcpkms/keys/vault\
key_ring=projects/$GOOGLE_CLOUD_PROJECT/locations/global/keyRings/vault \
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
service_account="vault-sa@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com" \
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
bound_service_accounts="[vault-sa@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com]"
{
"plugin_name": "postgresql-database-plugin",
"allowed_roles": "*",
"connection_url": "postgresql://{{username}}:{{password}}@$:5432/vault",
"max_open_connections": 5,
"max_connection_lifetime": "5s",
"username": "",
"password": ""
}

```

### Create GCP roleset

 ```

vault write gcp/roleset/demo-roleset \
project="$GOOGLE_CLOUD_PROJECT" \
secret_type="service_account_key" \
bindings=-<<EOF
resource "//cloudresourcemanager.googleapis.com/projects/$GOOGLE_CLOUD_PROJECT" {
roles = ["roles/editor"]
}
EOF

```

vault read gcp/roleset/demo-roleset/token


### Static accounts

vault write gcp/static-account/vault-sa \
    service_account_email="vault-sa@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com" \
    secret_type="access_token"  \
    token_scopes="https://www.googleapis.com/auth/cloud-platform" \
    bindings=-<<EOF
resource "//cloudresourcemanager.googleapis.com/projects/$GOOGLE_CLOUD_PROJECT" {
roles = ["roles/editor"]
}
EOF

vault write gcp/static-account/vault-sa \
    service_account_email="vault-sa@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com" \
    secret_type="service_account_key"  \
    bindings=-<<EOF
resource "//cloudresourcemanager.googleapis.com/projects/$GOOGLE_CLOUD_PROJECT" {
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

Vault Server IP (public):  
Vault Server IP (private): 

For example:
   ssh -i vault.pem ubuntu@

Vault Client IP (public):  
Vault Client IP (private): 

For example:
   ssh -i vault.pem ubuntu@


# Configure dynamic secrets and store them to postgres db 

vault write database/config/postgresql \
     plugin_name=postgresql-database-plugin \
     connection_url="postgresql://{{username}}:{{password}}@localhost:5432/postgres?sslmode=disable" \
     allowed_roles=readonly \
     username="" \
     password=""


vault write database/roles/demo-role \
    db_name=postgres \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
        GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
    default_ttl="1h" \
    max_ttl="24h"



vault write aws/config/root \
    access_key= \
    secret_key= \
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
