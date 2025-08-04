resource "minio_iam_policy" "loki" {
	name = "loki"
	policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": "s3:*",
			"Resource": "arn:aws:s3:::loki/*"
		}
	]
}
EOF
}

resource "minio_iam_user_policy_attachment" "give_loki_bucket" {
	depends_on = [
		minio_iam_user.loki,
		minio_iam_policy.loki
	]
	user_name   = minio_iam_user.loki.id
	policy_name = minio_iam_policy.loki.id
}

resource "minio_iam_policy" "zipsum" {
	name = "zipsum_test"
	policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": "s3:*",
			"Resource": "arn:aws:s3:::zipsum/*"
		}
	]
}
EOF
}

resource "minio_iam_group_policy_attachment" "zipsum" {
	depends_on = [
		minio_iam_group.zipsum,
		minio_iam_policy.zipsum,
	]
	group_name   = minio_iam_group.zipsum.id
	policy_name = minio_iam_policy.zipsum.id
}
