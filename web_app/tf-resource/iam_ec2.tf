
resource "aws_iam_role" "ec2_ecr_iam_role" {
    name = "ec2-ecr-role"

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

# attach role to policy
resource "aws_iam_role_policy_attachment" "ecr_read_only" {
 role = aws_iam_role.ec2_ecr_iam_role.name
 policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "ec2_iam_profile" {
 name = "ec2-ecr-iam-profile"
 role = aws_iam_role.ec2_ecr_iam_role.name
}

resource "aws_instance" "ec2_iam" {
  instance_type = "t2.micro"
  ami           = "ami-0d7a109bf30624c99" # maybe update
  iam_instance_profile = aws_iam_instance_profile.ec2_iam_profile.name
  key_name = "example" # update
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

output "connection_instructions" {
  value = "ssh with into ec2_iam with the following: ssh -i ~/.ssh/${aws_instance.ec2_iam.key_name}.pem ec2-user@${aws_instance.ec2_iam.public_dns}"
}


resource "aws_security_group" "http_backend_security" {
  name = "other backend security 2"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ssh_backend_security" {
    name = "ssh security group 2"

    ingress {
        cidr_blocks = [
          "0.0.0.0/0"
        ]
    from_port = 22
        to_port = 22
        protocol = "tcp"
      }

      egress {
       from_port = 0
       to_port = 0
       protocol = "-1"
       cidr_blocks = ["0.0.0.0/0"]
     }
}


