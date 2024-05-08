resource "aws_s3_bucket" "rahat-terraform" {
  bucket = "rahat-terraform"

  tags = {
    Name = "rahat-terraform"
  }
}