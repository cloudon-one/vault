#-------------------
# Required
#-------------------

# SSH key name to access EC2 instances. This should already exist in the AWS Region
key_name = "vault-poc"


#-----------------------------------------------
# Optional: To overwrite the default settings
#-----------------------------------------------

# All resources will be tagged with this (default is 'vault-agent-demo')
environment_name = "vault-agent-demo"

# AWS region & AZs (degault is 'us-east-1' and 'us-east-1a')
aws_region         = "eu-west-1"
availability_zones = "eu-west-1a"

# Instance size (default is t2.micro)
instance_type = "t2.medium"

# Number of Vault servers to provision (default is 1)
vault_server_count = 2
