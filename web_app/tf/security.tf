resource "aws_security_group" "http_backend_security" {
  name = "other backend security permissions"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ssh_backend_security" {
    name = "ssh security group permissions"

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

output "connection_instructions" {
  value = "ssh with into ec2 machine with the following: ssh -i ~/.ssh/${aws_instance.ec2_instance.key_name}.pem ec2-user@${aws_instance.ec2_instance.public_dns}"
}