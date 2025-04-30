resource "vault_pki_secret_backend_role" "singleton_logging_endpoints" {
   for_each = var.logging_to
   backend          = "pki"
   issuer_ref       = "default"
   name             = "${each.key}-dot-home-dot-arpa"
   max_ttl          = 3888000
   allow_ip_sans    = true
   key_type         = "rsa"
   key_bits         = 4096
   allowed_domains  = ["${each.key}.home.arpa"]
   allow_subdomains = true
   allow_bare_domains = true
   allow_glob_domains = true
}

#resource "vault_pki_secret_backend_role" "logging_oa" {
#   for_each = var.logging_from
#   backend          = "pki"
#   issuer_ref       = "default"
#   name             = "${each.key}-dot-oa-dot-home-dot-arpa"
#   max_ttl          = 3888000
#   allow_ip_sans    = true
#   key_type         = "rsa"
#   key_bits         = 4096
#   allowed_domains  = ["${each.key}.oa.home.arpa"]
#   allow_subdomains = true
#   allow_bare_domains = true
#   allow_glob_domains = true
#}
#
#resource "vault_pki_secret_backend_role" "logging_ob" {
#   for_each = var.logging_from
#   backend          = "pki"
#   issuer_ref       = "default"
#   name             = "${each.key}-dot-ob-dot-home-dot-arpa"
#   max_ttl          = 3888000
#   allow_ip_sans    = true
#   key_type         = "rsa"
#   key_bits         = 4096
#   allowed_domains  = ["${each.key}.ob.home.arpa"]
#   allow_subdomains = true
#   allow_bare_domains = true
#   allow_glob_domains = true
#}
#
#resource "vault_pki_secret_backend_role" "logging_hostpi" {
#   for_each = var.logging_from
#   backend          = "pki"
#   issuer_ref       = "default"
#   name             = "${each.key}-dot-hostpi-dot-home-dot-arpa"
#   max_ttl          = 3888000
#   allow_ip_sans    = true
#   key_type         = "rsa"
#   key_bits         = 4096
#   allowed_domains  = ["${each.key}.hostpi.home.arpa"]
#   allow_subdomains = true
#   allow_bare_domains = true
#   allow_glob_domains = true
#}

resource "vault_pki_secret_backend_role" "hosts" {
   for_each = var.hosts
   backend          = "pki"
   issuer_ref       = "default"
   name             = "${each.key}-dot-home-dot-arpa"
   max_ttl          = 3888000
   allow_ip_sans    = true
   key_type         = "rsa"
   key_bits         = 4096
   allowed_domains  = ["${each.key}.home.arpa"]
   allow_subdomains = true
   allow_bare_domains = true
   allow_glob_domains = true
}

resource "vault_pki_secret_backend_role" "ldap_server" {
   backend          = "pki"
   issuer_ref       = "default"
   name             = "ldap-dot-home-dot-arpa"
   max_ttl          = 3888000
   allow_ip_sans    = true
   key_type         = "rsa"
   key_bits         = 4096
   allowed_domains  = ["ldap.home.arpa"]
   allow_subdomains = true
   allow_bare_domains = true
   allow_glob_domains = true
}

resource "vault_pki_secret_backend_role" "postgres_general" {
   backend          = "pki"
   issuer_ref       = "default"
   name             = "postgres-dot-home-dot-arpa"
   max_ttl          = 3888000
   allow_ip_sans    = true
   key_type         = "rsa"
   key_bits         = 4096
   allowed_domains  = ["postgres.home.arpa"]
   allow_subdomains = true
   allow_bare_domains = true
   allow_glob_domains = true
}

resource "vault_pki_secret_backend_role" "minio_general" {
   backend          = "pki"
   issuer_ref       = "default"
   name             = "minio-dot-home-dot-arpa"
   max_ttl          = 3888000
   allow_ip_sans    = true
   key_type         = "rsa"
   key_bits         = 4096
   allowed_domains  = ["minio.home.arpa", "localhost"]
   allow_subdomains = true
   allow_bare_domains = true
   allow_glob_domains = true
}
