provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
}

data "aws_availability_zones" "available" {}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

data "aws_iam_policy_document" "registry" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions = [
      "ecr:ReplicateImage",
    ]

    resources = [
      module.aws-ecr.repository_arn,
    ]
  }
}

module "aws-ecr" {
  source                            = "./modules/aws-ecr"
  repository_read_write_access_arns = [data.aws_caller_identity.current.arn]
  repository_type                   = var.repository_type
  repository_name                   = "${local.name}-ecr"
  repository_image_tag_mutability   = var.repository_image_tag_mutability
  repository_encryption_type        = var.repository_encryption_type
  repository_kms_key                = var.repository_kms_key
  repository_image_scan_on_push     = var.repository_image_scan_on_push
  repository_force_delete           = var.repository_force_delete
  repository_policy                 = var.repository_policy
  github_repositories               = var.github_repositories
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 5 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 5
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
  registry_policy                        = data.aws_iam_policy_document.registry.json
  registry_pull_through_cache_rules      = var.registry_pull_through_cache_rules
  manage_registry_scanning_configuration = var.manage_registry_scanning_configuration
  registry_scan_type                     = var.registry_scan_type
  registry_scan_rules                    = var.registry_scan_rules
}
