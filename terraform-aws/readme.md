# HA Vault Cluster on VM's (AWS)

Root Token: s.CedGUqTOuyqTsucidL9rm623

### Configure dynamic secrets and store them to postgres db

```
vault write database/config/postgresql \
     plugin_name=postgresql-database-plugin \
     connection_url="postgresql://{{username}}:{{password}}@localhost:5432/postgres?sslmode=disable" \ # for PoC only
     allowed_roles=readonly \
     username="postgres" \
     password="QazWsx12"
```

### Create demo-role

```
vault write database/roles/demo-role \
    db_name=postgres \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
        GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
    default_ttl="1h" \
    max_ttl="24h"
```

### Validate secret adding to database

```
sudo -u postgres psql
SELECT usename, valuntil FROM pg_user;
```
