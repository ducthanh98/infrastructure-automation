terraform {
  backend "s3" {
    bucket  = "jaeger-terraform-states"
    key     = "terraform.tfstate"
    region  = "ap-southeast-1"
    encrypt = true
  }
}