terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "4.7.0"
    }
    minio = {
	source = "aminueza/minio"
	version = "3.4.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.27.0"
    }
  }
}

#provider "vault" {
#  # It is strongly recommended to configure this provider through the
#  # environment variables:
#  #    - VAULT_ADDR
#  #    - VAULT_TOKEN
#  #    - etc.  
#}
#
#provider "minio" {
#  # Going to use env variables for user/password so different terraform repos are syncronized
#}

provider "azurerm" {
    features {}

    subscription_id = "513b0f63-1641-41c1-9985-697e3673b785"
    tenant_id = "9e857255-df57-4c47-a0c0-0546460380cb"
}
