resource "minio_s3_bucket" "loki" {
	bucket = "loki"
}

resource "minio_s3_bucket" "zipsum" {
    bucket = "zipsum"
}
