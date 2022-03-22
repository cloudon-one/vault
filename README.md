# HashiCorp Vault HA Cluster on GCP

## Requirments

- gcloud sdk
- vault binary

### Exports

```sh
export GOOGLE_CLOUD_PROJECT=vault-poc-344807
export VAULT_ADDR=https://34.76.211.38:8200
export VAULT_CACERT=ca.crt
export VAULT_SA=vault-sa@vault-poc-344807.iam.gserviceaccount.com
export VAULT_DB=10.150.128.3
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
- Recovery Key 1: 2EWrT/YVlYE54EwvKaH3JzOGmq8AVJJkVFQDni8MYC+T
- Recovery Key 2: 6WCNGKN+dU43APJuGEVvIG6bAHA6tsth5ZR8/bJWi60/
- Recovery Key 3: XC1vSb/GfH35zTK4UkAR7okJWaRjnGrP75aQX0xByKfV
- Recovery Key 4: ZSvu2hWWmd4ECEIHj/FShxxCw7Wd2KbkLRsDm30f2tu3
- Recovery Key 5: T4VBvwRv0pkQLeTC/98JJ+Rj/Zn75bLfmAaFLDQihL9Y
 Initial Root Token: s.kn11NdBhLig2VJ0botgrwq
```

### Enable Postgres as secrets db (private sql instance)

```
vault write database/config/vault-poc \
plugin_name=postgresql-database-plugin \
allowed_roles="demo" \
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
key_ring=projects/$PROJECT_ID/locations/global/keyRings/vault \
rotation_period=72h
```

```
vault write gcpkms/keys/vault-poc \
key_ring=projects/$PROJECT_ID/locations/global/keyRings/vault-poc \
purpose=encrypt_decrypt \
algorithm=symmetric_encryption
```
  
### Enable GCP auth

```
vault secrets enable -path=gcp gcp

vault login -method=gcp \
role="demo" \
service_account="VAULT_SA" \
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
bound_service_accounts="[$VAULT_SA]"
{
"plugin_name": "postgresql-database-plugin",
"allowed_roles": "*",
"connection_url": "postgresql://{{username}}:{{password}}@$VAULT_DB:5432/postgres",
"max_open_connections": 5,
"max_connection_lifetime": "5s",
"username": "postgres",
"password": "postgres"
}
```

### Create GCP roleset

 ```
vault write gcp/roleset/demo-roleset \
project="$PROJECT_ID" \
secret_type="service_account_key" \
bindings=-<<EOF
resource "//cloudresourcemanager.googleapis.com/projects/$PROJECT_ID" {
roles = ["roles/viewer"]
}
EOF
```
  
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
