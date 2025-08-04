resource "minio_iam_group" "zipsum" {
    name = "zipsum"
}

resource "minio_iam_group_membership" "zipsum_test" {
    name = "zipsum_test"
    group = minio_iam_group.zipsum.name

    users = [
        minio_iam_user.zipsum_test.name
    ]
}
