terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "4.7.0"
    }
  }
}

provider "vault" {
  # It is strongly recommended to configure this provider through the
  # environment variables:
  #    - VAULT_ADDR
  #    - VAULT_TOKEN
  #    - etc.  
}
