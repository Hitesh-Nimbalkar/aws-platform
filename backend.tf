
terraform {
  backend "s3" {
    bucket         = "msumani-terraform-state"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "msumani-terraform-lock"
    encrypt        = true
  }
}



