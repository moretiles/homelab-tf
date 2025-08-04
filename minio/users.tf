data "vault_generic_secret" "user_loki_password" {
	path = "kv/home/minio/users/loki"
}

resource "minio_iam_user" "loki" {
	name = "loki"
	secret = data.vault_generic_secret.user_loki_password.data["password"]
}

data "vault_generic_secret" "zipsum_test" {
	path = "kv/home/minio/users/loki"
}

resource "minio_iam_user" "zipsum_test" {
	name = "zipsum_test"
    secret = data.vault_generic_secret.zipsum_test.data["password"]
}
