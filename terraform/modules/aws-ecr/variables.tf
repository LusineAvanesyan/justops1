variable "create" {
  description = "Determines whether resources will be created (affects all resources)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "repository_type" {
  description = "The type of repository to create. Either `public` or `private`"
  type        = string
  default     = "private"
}

variable "repository_name" {
  description = "The name of the repository"
  type        = string
  default     = ""
}

variable "repository_image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of: `MUTABLE` or `IMMUTABLE`. Defaults to `IMMUTABLE`"
  type        = string
  default     = "IMMUTABLE"
}

variable "repository_encryption_type" {
  description = "The encryption type for the repository. Must be one of: `KMS` or `AES256`. Defaults to `AES256`"
  type        = string
  default     = null
}

variable "repository_kms_key" {
  description = "The ARN of the KMS key to use when encryption_type is `KMS`. If not specified, uses the default AWS managed key for ECR"
  type        = string
  default     = null
}

variable "repository_image_scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository (`true`) or not scanned (`false`)"
  type        = bool
  default     = true
}

variable "repository_policy" {
  description = "The JSON policy to apply to the repository. If not specified, uses the default policy"
  type        = string
  default     = null
}

variable "repository_force_delete" {
  description = "If `true`, will delete the repository even if it contains images. Defaults to `false`"
  type        = bool
  default     = true
}

variable "repository_read_write_access_arns" {
  description = "The ARNs of the IAM users/roles that have read/write access to the repository"
  type        = list(string)
  default     = []
}

variable "repository_lifecycle_policy" {
  description = "The policy document. This is a JSON formatted string. See more details about [Policy Parameters](http://docs.aws.amazon.com/AmazonECR/latest/userguide/LifecyclePolicies.html#lifecycle_policy_parameters) in the official AWS docs"
  type        = string
  default     = ""
}

variable "registry_policy" {
  description = "The policy document. This is a JSON formatted string"
  type        = string
  default     = null
}

variable "registry_pull_through_cache_rules" {
  description = "List of pull through cache rules to create"
  type        = map(map(string))
  default     = {}
}


variable "manage_registry_scanning_configuration" {
  description = "Determines whether the registry scanning configuration will be managed"
  type        = bool
  default     = false
}

variable "registry_scan_type" {
  description = "the scanning type to set for the registry. Can be either `ENHANCED` or `BASIC`"
  type        = string
  default     = "ENHANCED"
}

variable "registry_scan_rules" {
  description = "One or multiple blocks specifying scanning rules to determine which repository filters are used and at what frequency scanning will occur"
  type        = any
  default     = []
}

variable "github_repositories" {
  default     = [""]
  description = "List of repository names authorized to assume the role."
  type        = list(string)
}
