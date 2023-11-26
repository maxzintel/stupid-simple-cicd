provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

data "aws_iam_role" "terraform_state_manager" {
  name = "TerraformStateManager"
}

provider "aws" {
  alias  = "remote_state"
  region = "us-east-1"
  assume_role {
    role_arn = data.aws_iam_role.terraform_state_manager.arn
  }
}

terraform {
  backend "s3" {
    bucket         = "your-terraform-backend-bucket"
    key            = "apps/example-app/production/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
