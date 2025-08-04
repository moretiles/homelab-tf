resource "minio_accesskey" "zipsum_test" {
    user = minio_iam_user.zipsum_test.name
    access_key = vault_kv_secret.user_zipsum_test_mainkey_access.data["access"]
    secret_key = vault_kv_secret.user_zipsum_test_mainkey_secret.data["secret"]
    status = "enabled"
}
