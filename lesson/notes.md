https://docs.google.com/document/d/1B2czijwkFsdtc2KFvaMGNu3d5r2d_0DemqtsefNimJQ/edit

,
      {
        Sid    = "DenyECRAccess",
        Effect = "Deny",
        Condition = {
                "StringNotEquals": {
                    "aws:userid": ["admin", aws_iam_role.ec2_resource_access_role.name]
                }
            }
        Action = [
           "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetAuthorizationToken"
        ]
      }