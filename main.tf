provider "aws" {
    region = var.region
    access_key = var.access_key
    secret_key = var.secret_key
  
}

module "IAMRoles" {
    source = "./IAMRoles"
  
}

module "AccountINFO" {
    source = "./AccountINFO"
  
}

module "CloudTrail" {
    source = "./CloudTrail"
    company_name = var.my_company_name
    cloudtail_tags = var.cloudtrail_tags

}

