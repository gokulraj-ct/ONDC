output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.thiss3.bucket
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.thiss3.arn
}

output "s3_bucket_versioning_status" {
  description = "The versioning status of the S3 bucket"
  value       = aws_s3_bucket_versioning.s3_data_bucket_versioning.versioning_configuration[0].status
}

output "s3_bucket_public_access_block_status" {
  description = "Public access block settings for the S3 bucket"
  value = {
    block_public_acls       = aws_s3_bucket_public_access_block.block_public_access_data.block_public_acls
    block_public_policy     = aws_s3_bucket_public_access_block.block_public_access_data.block_public_policy
    ignore_public_acls      = aws_s3_bucket_public_access_block.block_public_access_data.ignore_public_acls
    restrict_public_buckets = aws_s3_bucket_public_access_block.block_public_access_data.restrict_public_buckets
  }
}
