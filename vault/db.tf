resource "random_password" "postgres_central_role_admin" {
	length = 32
	special = false
}

resource "vault_kv_secret" "postgres_central_role_admin" {
	path = "kv/home/postgres/roles/admin"
	data_json = jsonencode(
	{
		password_hash = "${random_password.postgres_central_role_admin.bcrypt_hash}",
		password = "${random_password.postgres_central_role_admin.result}",
	}
	)
}
