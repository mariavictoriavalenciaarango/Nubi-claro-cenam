terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.30.0"
    }
  }
}

provider "aws" {
  region = var.Region

  default_tags {
    tags = {
      Environment = var.Environment
      project     = var.Project
      Team        = var.Team
      owner       = var.owner
      createdBy   = var.createdBy
      deadline    = var.deadline
      "pod/coe"   = "7"
    }
  }
}