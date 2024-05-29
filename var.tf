variable "access_key" {
    type = string
  
}

variable "secret_key" {
    type = string
}

variable "region" {
    type = string
  
}

variable "my_company_name" {
  description = "Enter Name for S3 bucket that prefix with company name"
  type = string
}

variable "cloudtrail_tags" {
    default = {}
  type = map(string)
 
}