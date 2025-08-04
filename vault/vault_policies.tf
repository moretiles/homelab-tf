resource "vault_policy" "host" {
  name = "host"
  policy = <<EOT
  path "pki/issue/*-dot-{{identity.entity.name}}-dot-home-dot-arpa" {
    capabilities = ["create", "read", "update", "patch", "list"]
  }

  path "pki/issue/{{identity.entity.name}}-dot-home-dot-arpa" {
    capabilities = ["create", "read", "update", "patch", "list"]
  }

  # needed to get accessor from token
  path "auth/token/lookup" {
    capabilities = ["update"]
  }

  # Required if using terraform provider according to docs
  path "auth/token/create" {
   capabilities = ["create", "update", "sudo"]
  }

  # Required if using terraform provider according to docs
  path "auth/token/lookup-accessor" {
    capabilities = ["update"]
  }

  # Required if using terraform provider according to docs
  path "auth/token/revoke-accessor" {
    capabilities = ["update"]
  }
  EOT
}

resource "vault_policy" "vault" {
  name = "vault"
  policy = <<EOT
  path "pki/issue/vault-dot-home-dot-arpa" {
    capabilities = ["create", "read", "update", "patch", "list"]
  } 
  EOT
}

resource "vault_policy" "ldap" {
  name = "ldap"
  policy = <<EOT
  path "pki/issue/ldap-dot-home-dot-arpa" {
    capabilities = ["create", "read", "update", "patch", "list"]
  } 

  path "pki/issue/ldaps-dot-home-dot-arpa" {
    capabilities = ["create", "read", "update", "patch", "list"]
  } 
  EOT
}

resource "vault_policy" "docker_registry" {
  name = "docker_registry"
  policy = <<EOT
  path "pki/issue/dockerauth-dot-home-dot-arpa" {
    capabilities = ["create", "read", "update", "patch", "list"]
  } 

  path "pki/issue/registry-dot-home-dot-arpa" {
    capabilities = ["create", "read", "update", "patch", "list"]
  } 
  EOT
}

resource "vault_policy" "wireguard" {
  name = "wireguard"
  policy = <<EOT
  path "kv/wg/network" {
    capabilities = ["read"]
  } 

  path "kv/wg/server" {
    capabilities = ["read"]
  } 
  EOT
}

resource "vault_policy" "dhcp" {
  name = "dhcp"
  policy = <<EOT
  path "kv/home/ips/*" {
    capabilities = ["read"]
  } 

  path "kv/home/macs/*" {
    capabilities = ["read"]
  } 
  EOT
}

resource "vault_policy" "process_logs" {
  name = "process_logs"
  policy = <<EOT
  path "pki/issue/prometheus-dot-home-dot-arpa" {
    capabilities = ["create", "read", "update", "patch", "list"]
  } 

  path "pki/issue/loki-dot-home-dot-arpa" {
    capabilities = ["create", "read", "update", "patch", "list"]
  } 

  path "pki/issue/grafana-dot-home-dot-arpa" {
    capabilities = ["create", "read", "update", "patch", "list"]
  } 
  EOT
}

resource "vault_policy" "postgres_central" {
  name = "postgres_central"
  policy = <<EOT
  path "kv/home/postgres/*" {
    capabilities = ["read"]
  } 

  path "pki/issue/postgres-dot-home-dot-arpa" {
    capabilities = ["create", "read", "update", "patch", "list"]
  } 

  EOT
}

resource "vault_policy" "minio_central" {
  name = "minio_central"
  policy = <<EOT
  path "kv/home/minio/*" {
    capabilities = ["read"]
  } 

  path "pki/issue/minio-dot-home-dot-arpa" {
    capabilities = ["create", "read", "update", "patch", "list"]
  } 

  EOT
}

resource "vault_policy" "mysql_in_kubernetes" {
  name = "mysql"
  policy = <<EOT
  path "kv/k8s/mysql/*" {
    capabilities = ["read"]
  } 
  EOT
}

resource "vault_policy" "zipsum_host" {
    name = "zipsum_host"
    policy = <<EOT
    path "kv/zipsum/minio/users/test" {
        capabilities = ["read"]
    }
    EOT
}
