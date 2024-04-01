

resource "aws_iam_role" "ec2_resource_access_role" {
    name = "ec2-access-role"

    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
      Service = "ec2.amazonaws.com"
      }
      Sid = ""
      },
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_resource_profile" {
 name = "ec2-ecr-resource-profile"
 role = aws_iam_role.ec2_resource_access_role.name
}

resource "aws_ecr_repository_policy" "ec2_access" {
  repository = "app-repo" #!Update to match your repo

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowEC2RoleAccess",
        Effect = "Allow",
        Principal = {
          AWS = aws_iam_role.ec2_resource_access_role.arn 
        },
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetAuthorizationToken",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages"
        ]
      }
    ]
  })
}

resource "aws_instance" "ec2_resource" {
  ami           = "ami-0d7a109bf30624c99"
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2_resource_profile.name
  key_name = "example" #!TODO: Update to match your key name
  user_data = <<-EOF
  #!/bin/bash
  sudo yum update -y
  sudo yum install docker -y
  sudo systemctl start docker
  EOF

  vpc_security_group_ids = [aws_security_group.http_backend_security.id, aws_security_group.ssh_backend_security.id]


  tags = {
      Name = "backend resource server"
  }
}

output "connection_resource_instructions" {
  value = "ssh into resource iam with the following: ssh -i ~/.ssh/${aws_instance.ec2_resource.key_name}.pem ec2-user@${aws_instance.ec2_resource.public_dns}"
}
