variable "github_repositories" {
  default     = [""]
  description = "List of repository names authorized to assume the role."
  type        = list(string)
}

variable "github_organization" {
  default     = "ntadevosyan5"
  description = "List of GitHub organization authorized to assume the role."
  type        = string
}

# https://github.blog/changelog/2022-01-13-github-actions-update-on-oidc-based-deployments-to-aws/
variable "github_thumbprint" {
  default     = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
  description = "GitHub OpenID TLS certificate thumbprint."
  type        = list(string)
}

variable "github_url" {
  default     = "https://token.actions.githubusercontent.com"
  description = "GitHub url"
  type        = string
}

variable "iam_role_name" {
  default     = "github-actions"
  description = "Name of the IAM role to be created. This will be assumable by GitHub."
  type        = string
}

variable "policies" {
  type        = list(any)
  description = "Policies to be attached to the role"
  default     = []
}
