data "vault_generic_secret" "user_loki_password" {
	path = "kv/home/minio/users/loki"
}

resource "minio_iam_user" "loki" {
	name = "loki"
	secret = data.vault_generic_secret.user_loki_password.data["password"]
}
