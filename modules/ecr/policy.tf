resource "aws_ecr_repository_policy" "default_ecr_repository_policy" {
  for_each = toset([for repo in var.names : repo if repo != "jenkins-agent"])

  repository = aws_ecr_repository.ecr_repository[each.value].name

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowPull"
        Effect    = "Allow"
        Principal = {
          AWS = "arn:aws:iam::940482430944:role/pramaan-nodes-eks-node-group-20241218162607726900000001"
        }
        Action    = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:DescribeRepositories",
          "ecr:GetDownloadUrlForLayer",
          "ecr:ListImages"
        ]
      }
    ]
  })
}

# Custom ECR Repository Policy for 'jenkins-agent'
resource "aws_ecr_repository_policy" "jenkins_ecr_repository_policy" {
  for_each = toset(["jenkins-agent"])

  repository = aws_ecr_repository.ecr_repository[each.value].name

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowPull"
        Effect    = "Allow"
        Principal = {
          AWS = [
            "arn:aws:iam::577638354424:role/ec2_ssm_role",
            "arn:aws:iam::577638354424:role/ecr_assume_role"
          ]
        }
        Action    = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:DescribeRepositories",
          "ecr:GetAuthorizationToken",
          "ecr:GetDownloadUrlForLayer",
          "ecr:ListImages"
        ]
      }
    ]
  })
}
