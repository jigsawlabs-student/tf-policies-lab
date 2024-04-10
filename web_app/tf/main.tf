provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-0d7a109bf30624c99" # you may need to update this
  instance_type = "t2.micro"
  
  key_name = "example" # update this
  user_data = <<-EOF
  #!/bin/bash
  sudo yum update -y
  sudo yum install docker -y
  sudo systemctl start docker
  EOF

  vpc_security_group_ids = [aws_security_group.http_backend_security.id, aws_security_group.ssh_backend_security.id]


  tags = {
      Name = "backend iam server"
  }
}


# 1. Set up the AWS IAM role
resource "aws_iam_role" "ec2_ecr_role" {
    name = "ec2-ecr-allow"

    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = []
  })
}


# 2. Create instance profile, as a container for the iam role


# 3. Attach the role to read ECR policy by specifying the role name and the policy
