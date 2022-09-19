terraform {
  backend "s3" {
    bucket         = "tf-dev-zookeep-state"
    dynamodb_table = "terraform_state_lock"
    encrypt        = true
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
  }
}
