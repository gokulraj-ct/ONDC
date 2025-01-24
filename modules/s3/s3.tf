
# ---------CREATING S3 DATA BUCKET  --------------
resource "aws_s3_bucket" "thiss3" {
  bucket = "${var.env}-${var.bucketname}"
  tags = {
    "Name"          = "${var.env}-${var.bucketname}"
    Environment     = var.env
  }
}

# ------------------ RESTRICTING PUBLIC ACCESS FOR THE DATA BUCKET / versioning enabled--------------------
resource "aws_s3_bucket_public_access_block" "block_public_access_data" {
  bucket                  = aws_s3_bucket.thiss3.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_versioning" "s3_data_bucket_versioning" {
  bucket = aws_s3_bucket.thiss3.id
  versioning_configuration {
    status = "Enabled"
  }
}