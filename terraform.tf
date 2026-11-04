terraform{
    required_providers{
        aws={
            source="hashicorp/aws"
            version = ">= 6.28.0, < 7.0.0"
        }
    }
     backend "s3" {
    bucket       = "lucky-s3-bucket-2026"
    key          = "terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
  }
}