provider "aws" {
  region = "us-east-1"  # Specify your preferred region
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  filter {
    name   = "availability-zone"
    values = ["us-east-1a"]  # Specify a specific availability zone
  }
}

data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
  filter {
    name   = "group-name"
    values = ["default"]
  }
}

resource "aws_key_pair" "jenkins_keypair" {
  key_name   = "jenkins-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "jenkins_server" {
  ami                    = "ami-0e001c9271cf7f3b9"  # Ubuntu 22.04 LTS AMI
  instance_type          = "t3.medium"
  vpc_security_group_ids = [data.aws_security_group.default.id]
  subnet_id              = data.aws_subnet.default.id
  key_name               = aws_key_pair.jenkins_keypair.key_name

  tags = {
    Name = "Jenkins-Server"
  }

}
output "jenkins_server_public_ip" {
  description = "The public IP address of the Jenkins server"
  value       = aws_instance.jenkins_server.public_ip
}
