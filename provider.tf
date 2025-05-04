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

    subscription_id = var.azure_subscription_id
    tenant_id = var.azure_tenant_id
}
