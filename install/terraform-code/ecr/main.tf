provider "aws" {
  region = "us-east-1"  # Specify your preferred region
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "default" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = "us-east-1a"  # Specify the availability zone if needed
}

data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
  filter {
    name   = "group-name"
    values = ["default"]
  }
}

resource "aws_ecr_repository" "my_ecr_repo" {
  name = "myhtml-app"  # Replace with your desired repository name
  force_delete = true
}

output "ecr_repo_url" {
  description = "URL of the created ECR repository"
  value       = aws_ecr_repository.my_ecr_repo.repository_url
}
