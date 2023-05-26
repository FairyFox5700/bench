resource "aws_iam_role" "terraform_role" {
  name = "terrafrom"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudformation.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "terraform_role_policy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.terraform_role.name
}

resource "aws_iam_role_policy_attachment" "terraform_role_policy_attach1" {
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
  role       = aws_iam_role.terraform_role.name
}

resource "aws_iam_role_policy_attachment" "terraform_role_policy_attach2" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  role       = aws_iam_role.terraform_role.name
}

resource "aws_iam_role_policy_attachment" "terraform_role_policy_attach3" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.terraform_role.name
}

resource "aws_iam_role_policy_attachment" "terraform_role_policy_attach4" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53RecoveryClusterFullAccess"
  role       = aws_iam_role.terraform_role.name
}

resource "aws_iam_role_policy_attachment" "terraform_role_policy_attach5" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudFormationFullAccess"
  role       = aws_iam_role.terraform_role.name
}

resource "aws_iam_role_policy_attachment" "terraform_role_policy_attach6" {
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
  role       = aws_iam_role.terraform_role.name
}

resource "aws_iam_role_policy_attachment" "terraform_role_policy_attach7" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.terraform_role.name
}
