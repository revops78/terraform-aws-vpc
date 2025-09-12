terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider

terraform {
  backend "s3" {
    bucket = "chinni-remote-state-dev"
    key    = "roboshop-dev-component80"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true
  }
}
