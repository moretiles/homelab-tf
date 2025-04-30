#resource "vault_token" "hosts" {
#  for_each = var.hosts
#  display_name = "${each.key}-host-token"
#  policies = ["default", "physical_host"]
#  ttl = "240h"
#  renewable = true
#  metadata = {
#    host_name = "${each.key}"
#  }
#}

#resource "vault_token" "oa" {
#  display_name = "oa_host_token"
#  policies = ["default", "physical_host"]
#  ttl = "240h"
#  renewable = true
#  metadata = {
#    host_name = "oa"
#  }
#}

#output "host_tokens" {
#  value = { 
#    for host in var.hosts : host => vault_token.hosts[host].client_token 
#  }
#  sensitive = true
#}

#output "oa_token" {
#  value = vault_token.oa.client_token
#  sensitive = true
#}
