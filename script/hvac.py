import time

import googleapiclient.discovery  # pip install google-api-python-client
from google.oauth2 import service_account  # pip install google-auth
import hvac  # pip install hvac

# First load some previously generated GCP service account key
path_to_sa_json = "some-service-account-path.json"
credentials = service_account.Credentials.from_service_account_file(path_to_sa_json)
with open(path_to_sa_json, "r") as f:
    creds = json.load(f)
    project = creds["project_id"]
    service_account = creds["client_email"]

# Generate a payload for subsequent "signJwt()" call
# Reference: https://google-auth.readthedocs.io/en/latest/reference/google.auth.jwt.html#google.auth.jwt.Credentials
now = int(time.time())
expires = now + 900  # 15 mins in seconds, can't be longer.
payload = {"iat": now, "exp": expires, "sub": service_account, "aud": "vault/my-role"}
body = {"payload": json.dumps(payload)}
name = f"projects/{project}/serviceAccounts/{service_account}"

# Perform the GCP API call
iam = googleapiclient.discovery.build("iam", "v1", credentials=credentials)
request = iam.projects().serviceAccounts().signJwt(name=name, body=body)
resp = request.execute()
jwt = resp["signedJwt"]

# Perform hvac call to configured GCP auth method
client.auth.gcp.login(
    role="my-role",
    jwt=jwt,
)
