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
  }
}

provider "vault" {
  # It is strongly recommended to configure this provider through the
  # environment variables:
  #    - VAULT_ADDR
  #    - VAULT_TOKEN
  #    - etc.  
}

provider "minio" {
  # Going to use env variables for user/password so different terraform repos are syncronized
}
