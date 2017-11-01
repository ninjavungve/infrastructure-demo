resource "aws_s3_bucket" "website" {
	bucket = "${var.fqdn}"
	acl = "public-read"
	website {
		index_document = "index.html"
		error_document = "error.html"
	}
}
