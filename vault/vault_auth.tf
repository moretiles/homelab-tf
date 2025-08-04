######################
#  userpass backend  #
######################

#resource "vault_auth_backend" "userpass" {
#  type = "userpass"
#}
#
#resource "random_password" "userpass_hosts" {
#  for_each = var.hosts
#  length = 32
#  special = false 
#}
#
#resource "vault_generic_endpoint" "hosts" {
#  for_each = var.hosts
#  path = "auth/${vault_auth_backend.userpass.path}/users/${each.key}"
#  data_json = jsonencode(
#    {
#      password = random_password.userpass_hosts["${each.key}"].result,
#      token_policies = ["default", "physical_host"]
#      token_ttl = "10d"
#    }
#  )
#}

######################
#    ldap backend    #
######################

resource "random_password" "ldap_admin" {
        length = 32
        special = false
}

resource "random_password" "ldap_config" {
        length = 32
        special = false
}

resource "vault_kv_secret" "ldap_server" {
        path = "kv/home/auth/ldap"
        data_json = jsonencode(
        {
                admin_password_hash = "${random_password.ldap_admin.bcrypt_hash}",
                admin_password = "${random_password.ldap_admin.result}",
                config_password_hash = "${random_password.ldap_config.bcrypt_hash}",
                config_password = "${random_password.ldap_config.result}",
        }
        )
}

resource "vault_ldap_auth_backend" "ldap" {
  url = "ldaps://ldap.home.arpa"
  groupdn = "OU=Groups,DC=home,DC=arpa"
  userdn = "OU=People,DC=home,DC=arpa"
  discoverdn = false
  starttls = true
  insecure_tls = false

  binddn="cn=admin,dc=home,dc=arpa"
  bindpass="${random_password.ldap_admin.result}"
  certificate = <<EOT
-----BEGIN CERTIFICATE-----
MIIDMTCCAhmgAwIBAgIUew7GkNRfPpr+lerbwEUwWsY73lswDQYJKoZIhvcNAQEL
BQAwFDESMBAGA1UEAxMJaG9tZS5hcnBhMCAXDTI1MDMyOTE0NTIxOFoYDzIxMjUw
MzA1MTM1MjQ3WjAUMRIwEAYDVQQDEwlob21lLmFycGEwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQDFB8TvCr01Om5YmpLvctwXZR4rMN1X6CaCCNl73J2Z
ulMqXj/yOCl5Fvng0s7+qOFCxpBPFoqfZXKANavRYla6ePn4fhGSm7xo+7meSo2f
j2TOv8DJuwG47rS33wauWidUhObE5SMQkraY7CTf/8qjI8MlDKz3Hkw9K+G4k8pE
cc7e6Pq5UXAr6n4m6vP6B828WSiMaqE4LISiUQcDz+vJ1KkdPKvYoJ4GDXtv3vwq
091yjRqBia2d74jOO6ONW8oq7W7as5NTMHgEDl4hz5QJqFQLWv5CMu3ycbaCmeif
gDbdEG9R61l8k0oFnzXGj393mHY2T/rb0LYYbu+/TCOLAgMBAAGjeTB3MA4GA1Ud
DwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBQjIMd67i2e8kgW
24qis6JeFZOKMTAfBgNVHSMEGDAWgBQjIMd67i2e8kgW24qis6JeFZOKMTAUBgNV
HREEDTALgglob21lLmFycGEwDQYJKoZIhvcNAQELBQADggEBABfLfrIcWhD/Ej9r
JL48A3kDJNJ2/BImehkzxcX7EVvbt9rerxS8dv287sO4BusJU3T8K6EkVGT/hPHD
bM5HAttIPR1fgKbooLdYbNgrBhLNd0Iqlqb7G/mOxElK9oTUsQavxvcnkwAkxbc5
WdD2c/6+SPeL/Fd/HnJKsMeQrbtIzlfRIXO73TXAA5cbQBoktF4dIzW7qRHyzqTx
1z6VjEWGis6Ec84BRmn30OIiJhe2fitXZwIStEhKqKo2sw8i2eItPJubo7VE5Rjd
NNJh/WcFn+lPMcwb2kccVJ/JnFNUVMkDnI4iwF8BrlyWKASPuad0ezDfp1Slnanb
diHBq5k=
-----END CERTIFICATE-----
EOT

  path = "ldap"
  token_type = "service"
  #userattr = "vault_username"
  #groupattr = "vault_group"
}

resource "random_password" "ldap_hosts" {
  for_each = var.hosts
  length = 32
  special = false 
}

resource "vault_kv_secret" "ldap_hosts" {
  for_each = var.hosts
  path = "kv/home/ldap/${each.key}"
  data_json = jsonencode(
  {
    password_hash = "${random_password.ldap_hosts["${each.key}"].bcrypt_hash}",
    password = "${random_password.ldap_hosts["${each.key}"].result}",
  }
  )
}

# I think that this not needed if we are using vault_group as the attribute but idk
resource "vault_ldap_auth_backend_group" "hosts" {
  backend = vault_ldap_auth_backend.ldap.path
  groupname = "group_hosts"
  policies = ["host"]
}

resource "vault_ldap_auth_backend_user" "hostpi" {
  backend = vault_ldap_auth_backend.ldap.path
  username = "user_hostpi"
  policies = [
    "host", 
    "dhcp", "wireguard",
    "vault", "ldap", "docker_registry", "process_logs", "postgres_central",
    ]
}

resource "vault_ldap_auth_backend_user" "oa" {
  backend = vault_ldap_auth_backend.ldap.path
  username = "user_oa"
  policies = [
    "host", 
    "minio_central",
    "zipsum",
    ]
}


resource "vault_identity_entity" "hosts" {
  for_each = var.hosts
  name = "${each.key}"
  policies = ["host"]
}

# link a ldap user to an internal entity in vault
resource "vault_identity_entity_alias" "hosts" {
  for_each = var.hosts
  # ldap
  mount_accessor = "${vault_ldap_auth_backend.ldap.accessor}"
  name = "user_${each.key}"
  # identity entity
  canonical_id = "${vault_identity_entity.hosts["${each.key}"].id}"
}

#output "host_tokens" {
#  value = {
#    for host in var.hosts : host => random_password.userpass_hosts[host].result
#  }
#  sensitive = true
#}

######################
# kubernetes backend #
######################

resource "vault_auth_backend" "kubernetes_oba" {
	type = "kubernetes"
}

resource "vault_kubernetes_auth_backend_config" "kubernetes_oba" {
	backend = vault_auth_backend.kubernetes_oba.path
	kubernetes_host = "https://oba.home.arpa:6443"
	token_reviewer_jwt = var.kubernetes_vault_injector_service_token
	kubernetes_ca_cert = "-----BEGIN CERTIFICATE-----\nMIIBdzCCAR2gAwIBAgIBADAKBggqhkjOPQQDAjAjMSEwHwYDVQQDDBhrM3Mtc2Vy\ndmVyLWNhQDE3NDc1Nzc4MjgwHhcNMjUwNTE4MTQxNzA4WhcNMzUwNTE2MTQxNzA4\nWjAjMSEwHwYDVQQDDBhrM3Mtc2VydmVyLWNhQDE3NDc1Nzc4MjgwWTATBgcqhkjO\nPQIBBggqhkjOPQMBBwNCAATIVMr90Anm2u0Axgs849AG2ZVknUgDNIRekyHneKW6\n36FDmoa7O7KLRrj8c3GBSBcUV5S/L5fy4UBeNEGcs9N8o0IwQDAOBgNVHQ8BAf8E\nBAMCAqQwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQUDhAflsllTYzi/cByd42U\n4vEJvXwwCgYIKoZIzj0EAwIDSAAwRQIhAMX6nkmIFqCTx1AEHcgQPPsowUev6Yct\nRl0co4P82NDcAiAFMCuuaOccy2BVFiytMzwy9nLzuJnO2Rra6a+V+t/fEQ==\n-----END CERTIFICATE-----"
	disable_iss_validation = "true"
	issuer = "https://kubernetes.default.svc.cluster.local"
}

resource "vault_kubernetes_auth_backend_role" "minio-oba" {
	backend = vault_auth_backend.kubernetes_oba.path
	role_name = "minio-service-account"
	bound_service_account_names = ["minio-service-account"]
	bound_service_account_namespaces = ["default"]
	token_ttl = 3456000
	token_policies = ["minio_central"]
}

resource "vault_kubernetes_auth_backend_role" "mysql_in_kubernetes" {
	backend = vault_auth_backend.kubernetes_oba.path
	role_name = "mysql"
	bound_service_account_names = ["mysql"]
	bound_service_account_namespaces = ["default"]
	token_ttl = 3456000
	token_policies = ["mysql_in_kubernetes"]
}
