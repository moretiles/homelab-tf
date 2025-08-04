resource "random_password" "mysql_root_password" {
        length = 32
        special = false
}

resource "random_password" "mysql_user_password" {
        length = 32
        special = false
}

resource "random_password" "mysql_replicator_password" {
        length = 32
        special = false
}

resource "vault_kv_secret" "mysql_root_password" {
        path = "kv/k8s/mysql/root"
        data_json = jsonencode(
        {
                password_hash = "${random_password.mysql_root_password.bcrypt_hash}",
                password = "${random_password.mysql_root_password.result}",
        }
        )
}

resource "vault_kv_secret" "mysql_user_password" {
        path = "kv/k8s/mysql/user"
        data_json = jsonencode(
        {
                password_hash = "${random_password.mysql_user_password.bcrypt_hash}",
                password = "${random_password.mysql_user_password.result}",
        }
        )
}

resource "vault_kv_secret" "mysql_replicator_password" {
        path = "kv/k8s/mysql/replicator"
        data_json = jsonencode(
        {
                password_hash = "${random_password.mysql_replicator_password.bcrypt_hash}",
                password = "${random_password.mysql_replicator_password.result}",
        }
        )
}
