
resource "aws_account_alternate_contact" "operations" {

  alternate_contact_type = "OPERATIONS"

  name          = "Milan Rathod"
  title         = "Operations Manager"
  email_address = "operations.aws@aeonx.digital"
  phone_number  = "+917069015943"
}


resource "aws_account_alternate_contact" "security" {

  alternate_contact_type = "SECURITY"

  name          = "Madhavendra Kacha"
  title         = "Security Manager"
  email_address = "security.aws@aeonx.digital"
  phone_number  = "+919624155440"
}


resource "aws_account_alternate_contact" "billing" {

  alternate_contact_type = "BILLING"

  name          = "Hardik Raste"
  title         = "Billing Manager"
  email_address = "billing.aws@aeonx.digital"
  phone_number  = "+919998955438"
}





 




 



