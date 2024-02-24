
data "aws_iam_policy_document" "github_trust_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test = "StringLike"
      values = [
        for repo in var.github_repositories :
        "repo:${var.github_organization}/%{if length(regexall(":+", repo)) > 0}${repo}%{else}${repo}:*%{endif}"
      ]
      variable = "token.actions.githubusercontent.com:sub"
    }

    condition {
      test = "ForAllValues:StringEquals"
      values = [
        var.github_url
      ]
      variable = "token.actions.githubusercontent.com:iss"
    }

    condition {
      test = "ForAllValues:StringEquals"
      values = [
        "sts.amazonaws.com"
      ]
      variable = "token.actions.githubusercontent.com:aud"
    }

    principals {
      identifiers = [data.aws_iam_openid_connect_provider.github.arn]
      type        = "Federated"
    }
  }

  version = "2012-10-17"
}

data "aws_iam_openid_connect_provider" "github" { # Dev environments share the same existing provider
  url = var.github_url
}

data "tls_certificate" "gha_certificate" {
  url = "https://token.actions.githubusercontent.com"
}

# resource "aws_iam_openid_connect_provider" "github" { # Create new provider for non-dev environments
#   # depends_on = [aws_iam_role_policy_attachment.openid_policy_attachment, aws_iam_policy.openid]
#   client_id_list = concat(
#     ["https://github.com/${var.github_organization}"],
#     ["sts.amazonaws.com"]
#   )

#   thumbprint_list = var.github_thumbprint != null ? concat(var.github_thumbprint, flatten(data.tls_certificate.gha_certificate.certificates[*].sha1_fingerprint)) : flatten(data.tls_certificate.gha_certificate.certificates[*].sha1_fingerprint)
#   url             = var.github_url
# }

resource "aws_iam_role" "github_action_role" {
  name               = var.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.github_trust_policy.json
}

resource "aws_iam_role_policy_attachment" "additional" {
  count      = length(var.policies)
  role       = aws_iam_role.github_action_role.id
  policy_arn = var.policies[count.index]
}


resource "aws_iam_policy" "openid" {
  name = "create-openid-policy"

  description = "Policy for create openid"

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "iam:CreateOpenIDConnectProvider",
          "iam:TagOpenIDConnectProvider"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF
}
