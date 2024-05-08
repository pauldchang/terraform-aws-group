module "terraform-aws-group" {
    source = "../"
    ami = "ami-09b90e09742640522"
    instance_type = "t2.micro"
    key_name = "SSH-Mac"
}