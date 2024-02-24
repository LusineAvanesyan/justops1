data "aws_iam_policy_document" "repository" {

  dynamic "statement" {
    for_each = length(var.repository_read_write_access_arns) > 0 ? [var.repository_read_write_access_arns] : []

    content {
      sid = "ReadWrite"

      principals {
        type        = "AWS"
        identifiers = ["*"]
      }

      actions = [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:CompleteLayerUpload",
        "ecr:GetDownloadUrlForLayer",
        "ecr:InitiateLayerUpload",
        "ecr:PutImage",
        "ecr:UploadLayerPart"
      ]
    }
  }
}

resource "aws_ecr_repository" "this" {

  name                 = var.repository_name
  image_tag_mutability = var.repository_image_tag_mutability

  encryption_configuration {
    encryption_type = var.repository_encryption_type
    kms_key         = var.repository_kms_key
  }

  force_delete = var.repository_force_delete

  image_scanning_configuration {
    scan_on_push = var.repository_image_scan_on_push
  }
}

resource "aws_ecr_repository_policy" "this" {

  repository = aws_ecr_repository.this.name
  policy     = data.aws_iam_policy_document.repository.json
}

resource "aws_ecr_lifecycle_policy" "this" {

  repository = aws_ecr_repository.this.name
  policy     = var.repository_lifecycle_policy
}

resource "aws_ecr_registry_policy" "this" {

  policy = var.registry_policy
}

resource "aws_ecr_pull_through_cache_rule" "this" {
  for_each = { for k, v in var.registry_pull_through_cache_rules : k => v if var.create }

  ecr_repository_prefix = each.value.ecr_repository_prefix
  upstream_registry_url = each.value.upstream_registry_url
}

resource "aws_ecr_registry_scanning_configuration" "this" {
  count = var.create && var.manage_registry_scanning_configuration ? 1 : 0

  scan_type = var.registry_scan_type

  dynamic "rule" {
    for_each = var.registry_scan_rules

    content {
      scan_frequency = rule.value.scan_frequency

      repository_filter {
        filter      = rule.value.filter
        filter_type = try(rule.value.filter_type, "WILDCARD")
      }
    }
  }
}

module "github_service_role" {
  source              = "./modules/service_role"
  github_repositories = var.github_repositories
  policies            = [aws_iam_policy.ecr_policy.arn]
}

resource "aws_iam_policy" "ecr_policy" {
  name = "push-image-policy"

  description = "Policy for pushing docker images to ecr"

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
      "Action": [
          "ecr:GetRegistryPolicy",
          "ecr:DescribeImageScanFindings",
          "ecr:GetLifecyclePolicyPreview",
          "ecr:GetDownloadUrlForLayer",
          "ecr:DescribeRegistry",
          "ecr:DescribePullThroughCacheRules",
          "ecr:DescribeImageReplicationStatus",
          "ecr:GetAuthorizationToken",
          "ecr:ListTagsForResource",
          "ecr:ListImages",
          "ecr:BatchGetRepositoryScanningConfiguration",
          "ecr:GetRegistryScanningConfiguration",
          "ecr:BatchGetImage",
          "ecr:DescribeImages",
          "ecr:DescribeRepositories",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetRepositoryPolicy",
          "ecr:GetLifecyclePolicy"
      ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF
}
