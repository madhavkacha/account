

# List of IAM user ARNs for the trust relationship of Aeonx-L1-Role
variable "trusted_users_l1" {
  default = [
    "arn:aws:iam::761685920937:user/harsh.tripathi",
    "arn:aws:iam::761685920937:user/Jigark.maheshwari",
    "arn:aws:iam::761685920937:user/prateek.tyagi",
    "arn:aws:iam::761685920937:user/Parth.Padhariya",
    "arn:aws:iam::761685920937:user/raja.banerjee",
    "arn:aws:iam::761685920937:user/mayank.chawla",
    "arn:aws:iam::761685920937:user/vatsal.shah",
    "arn:aws:iam::761685920937:user/sadiyah.akbany",
    "arn:aws:iam::761685920937:user/santosh.salapu",
    "arn:aws:iam::761685920937:user/jiten.gor",
    "arn:aws:iam::761685920937:user/pratik.dudhatra"
  ]
}

# List of IAM user ARNs for the trust relationship of Aeonx-L2-Role
variable "trusted_users_l2" {
  default = [
    "arn:aws:iam::761685920937:user/madhav.kacha",
    "arn:aws:iam::761685920937:user/hardik.raste"
  ]
}

# List of IAM user ARNs for the trust relationship of Aeonx-L3-Role
variable "trusted_users_l3" {
  default = [
    "arn:aws:iam::761685920937:user/milan.rathod",
    "arn:aws:iam::761685920937:user/deepak.bhardwaj"
  ]
}

# Create the Aeonx-L1-Role
resource "aws_iam_role" "aeonx_l1_role" {
  name               = "Aeonx-L1-Role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          AWS = var.trusted_users_l1
        },
        Action    = "sts:AssumeRole",
        Condition = {
          Bool = {
            "aws:MultiFactorAuthPresent" = "true"
          }
        }
      }
    ]
  })
}

# Attach ReadOnlyAccess policy to the Aeonx-L1-Role
resource "aws_iam_policy_attachment" "aeonx_l1_readonly" {
  name       = "Aeonx-L1-ReadOnlyAccess"
  roles      = [aws_iam_role.aeonx_l1_role.name]
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# Create the Aeonx-L2-Role
resource "aws_iam_role" "aeonx_l2_role" {
  name               = "Aeonx-L2-Role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          AWS = var.trusted_users_l2
        },
        Action    = "sts:AssumeRole",
        Condition = {
          Bool = {
            "aws:MultiFactorAuthPresent" = "true"
          }
        }
      }
    ]
  })
}

# Attach AdministratorAccess policy to the Aeonx-L2-Role
resource "aws_iam_policy_attachment" "aeonx_l2_admin_access" {
  name       = "Aeonx-L2-AdministratorAccess"
  roles      = [aws_iam_role.aeonx_l2_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Create the Aeonx-L3-Role
resource "aws_iam_role" "aeonx_l3_role" {
  name               = "Aeonx-L3-Role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          AWS = var.trusted_users_l3
        },
        Action    = "sts:AssumeRole",
        Condition = {
          Bool = {
            "aws:MultiFactorAuthPresent" = "true"
          }
        }
      }
    ]
  })
}

# Attach AdministratorAccess policy to the Aeonx-L3-Role
resource "aws_iam_policy_attachment" "aeonx_l3_admin_access" {
  name       = "Aeonx-L3-AdministratorAccess"
  roles      = [aws_iam_role.aeonx_l3_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

