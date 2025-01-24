################################################################################
# Key
################################################################################

output "key_arn" {
  description = "The Amazon Resource Name (ARN) of the key"
  value       = { for key, kms_key in aws_kms_key.this : key => kms_key.arn }
}

output "key_id" {
  description = "The globally unique identifier for the key"
  value       = { for key, kms_key in aws_kms_key.this : key => kms_key.key_id }
}

output "target_key_ids" {
  description = "Mapping of service names to their KMS Key IDs (target_key_id)"
  value = {
    for name, alias in aws_kms_alias.this :
    name => alias.target_key_id
  }
}


# output "key_policy" {
#   description = "The IAM resource policy set on the key"
#   value       = try(aws_kms_key.this[0].policy, aws_kms_replica_key.this[0].policy, null)
# }

################################################################################
# Alias
################################################################################

output "kms_key_aliases" {
  value = { for key, alias in aws_kms_alias.this : key => alias.name }
}