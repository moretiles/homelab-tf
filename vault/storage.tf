resource "random_password" "minio_central_user_root" {
	length = 32
	special = false
}

resource "vault_kv_secret" "minio_central_user_root" {
	path = "kv/home/minio/users/root"
	data_json = jsonencode(
	{
		password_hash = "${random_password.minio_central_user_root.bcrypt_hash}",
		password = "${random_password.minio_central_user_root.result}",
	}
	)
}

resource "random_password" "minio_central_user_loki" {
	length = 32
	special = false
}

resource "vault_kv_secret" "minio_central_user_loki" {
	path = "kv/home/minio/users/loki"
	data_json = jsonencode(
	{
		password_hash = "${random_password.minio_central_user_loki.bcrypt_hash}",
		password = "${random_password.minio_central_user_loki.result}",
	}
	)
}
