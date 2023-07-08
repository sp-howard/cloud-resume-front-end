terraform {
  cloud {
    organization = "sp-howard"

    workspaces {
      # name = "cloud-resume-front-end"
      name = "cloud-resume-front-end-gh"
    }
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}


provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias  = "acm_provider"
  region = "us-east-1"
}