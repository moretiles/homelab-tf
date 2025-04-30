resource "random_password" "logging_oa" {
	for_each = var.logging_from
	length = 32
	special = false
}

resource "random_password" "logging_ob" {
	for_each = var.logging_from
	length = 32
	special = false
}

resource "random_password" "logging_hostpi" {
	for_each = var.logging_from
	length = 32
	special = false
}

resource "random_password" "logging_singleton" {
	for_each = var.logging_to
	length = 32
	special = false
}

resource "random_password" "grafana_admin_password" {
	length = 32
	special = false
}

resource "random_password" "grafana_secret_key" {
	length = 32
	special = false
}

resource "vault_kv_secret" "logging_grafana" {
	path = "kv/home/logging/grafana"
	data_json = jsonencode(
	{
		password_hash = "${random_password.logging_singleton["grafana"].bcrypt_hash}",
		password = "${random_password.logging_singleton["grafana"].result}",
		admin_password_hash = "${random_password.grafana_admin_password.bcrypt_hash}",
		admin_password = "${random_password.grafana_admin_password.result}",
		secret_key_hash = "${random_password.grafana_secret_key.bcrypt_hash}",
		secret_key = "${random_password.grafana_secret_key.result}",
	}
	)
}

resource "vault_kv_secret" "logging_loki" {
	path = "kv/home/logging/loki"
	data_json = jsonencode(
	{
		password_hash = "${random_password.logging_singleton["loki"].bcrypt_hash}",
		password = "${random_password.logging_singleton["loki"].result}",
	}
	)
}

resource "vault_kv_secret" "logging_prometheus" {
	path = "kv/home/logging/prometheus"
	data_json = jsonencode(
	{
		password_hash = "${random_password.logging_singleton["prometheus"].bcrypt_hash}",
		password = "${random_password.logging_singleton["prometheus"].result}",
	}
	)
}

resource "vault_kv_secret" "logging_from_oa" {
	path = "kv/home/logging/oa"
	data_json = jsonencode(
	{
		node_exporter_password_hash = "${random_password.logging_oa["node_exporter"].bcrypt_hash}",
		node_exporter_password = "${random_password.logging_oa["node_exporter"].result}",
		fluid_bit_password_hash = "${random_password.logging_oa["fluid_bit"].bcrypt_hash}",
		fluid_bit_password = "${random_password.logging_oa["fluid_bit"].result}",
	}
	)
}

resource "vault_kv_secret" "logging_from_ob" {
	path = "kv/home/logging/ob"
	data_json = jsonencode(
	{
		node_exporter_password_hash = "${random_password.logging_ob["node_exporter"].bcrypt_hash}",
		node_exporter_password = "${random_password.logging_ob["node_exporter"].result}",
		fluid_bit_password_hash = "${random_password.logging_ob["fluid_bit"].bcrypt_hash}",
		fluid_bit_password = "${random_password.logging_ob["fluid_bit"].result}",
	}
	)
}

resource "vault_kv_secret" "logging_from_hostpi" {
	path = "kv/home/logging/hostpi"
	data_json = jsonencode(
	{
		node_exporter_password_hash = "${random_password.logging_hostpi["node_exporter"].bcrypt_hash}",
		node_exporter_password = "${random_password.logging_hostpi["node_exporter"].result}",
		fluid_bit_password_hash = "${random_password.logging_hostpi["fluid_bit"].bcrypt_hash}",
		fluid_bit_password = "${random_password.logging_hostpi["fluid_bit"].result}",
	}
	)
}
