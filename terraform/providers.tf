locals {
  cross_account_role_arn = "arn:aws:iam::412999873787:role/terraform_asume" # for security reason I delete it
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.4.3"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.2.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.16.1"
    }
  }
  required_version = "~> 1.3"
}

# Configure the AWS Provider

provider "aws" {
  region = var.provider_region
  assume_role {
    role_arn = "arn:aws:iam::412999873787:role/terraform_asume"
  }
}
