terraform {
  backend "s3" {
    bucket         = "tf-stage-zookeep-state"
    dynamodb_table = "terraform_state_lock"
    encrypt        = true
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
  }
}
