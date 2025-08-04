resource "random_password" "user_zipsum_test" {
    length = 32
    special = false
}

resource "vault_kv_secret" "user_zipsum_test" {
    path = "kv/zipsum/minio/users/test"
    data_json = jsonencode({
        password_hash = random_password.user_zipsum_test.bcrypt_hash,
        password = random_password.user_zipsum_test.result,
    })
}

resource "random_password" "user_zipsum_test_mainkey_access" {
    length = 16
    special = false
}

resource "vault_kv_secret" "user_zipsum_test_mainkey_access" {
    path = "kv/zipsum/minio/accesskeys/test_access"
    data_json = jsonencode({
        access_hash = random_password.user_zipsum_test_mainkey_access.bcrypt_hash,
        access = random_password.user_zipsum_test_mainkey_access.result,
    })
}

resource "random_password" "user_zipsum_test_mainkey_secret" {
    length = 32
    special = false
}

resource "vault_kv_secret" "user_zipsum_test_mainkey_secret" {
    path = "kv/zipsum/minio/accesskeys/test_secret"
    data_json = jsonencode({
        secret_hash = random_password.user_zipsum_test_mainkey_secret.bcrypt_hash,
        secret = random_password.user_zipsum_test_mainkey_secret.result,
    })
}
