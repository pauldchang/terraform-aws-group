terraform {
  backend "s3" {
    bucket = "paulc-terraform6"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }
}
