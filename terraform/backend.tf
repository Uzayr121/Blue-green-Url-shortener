terraform {
  backend "s3" {
    bucket         = "s3-state-bucket-tf"
    key            = "terraform/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    use_lockfile = true #s3 native state locking
  }
}