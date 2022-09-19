terraform {
  backend "s3" {
    bucket         = "tf-prod-zookeep-state"
    dynamodb_table = "terraform_state_lock"
    encrypt        = true
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
  }
}
