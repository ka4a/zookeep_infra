module "my_ec2" {
  source          = "../modules/ec2"
  ami_id          = "ami-0df99b3a8349462c6" #ubuntu20
  instance_type   = "t2.small"
  subnet_id       = module.my_vpc.subnet_id
  ec2_count       = 1
  environment     = "dev"
  security_groups = module.my_vpc.sg_id
}

module "my_vpc" {
  source      = "../modules/vpc"
  vpc_cidr    = "10.0.0.0/16"
  tenancy     = "default"
  vpc_id      = module.my_vpc.vpc_id
  subnet_cidr = "10.0.1.0/24"
  environment = "dev"
}

module "my_rds" {
  source          = "../modules/rds"
  identifier      = "dev-rds"
  db_name         = "talentai_dev"
  username        = "talentaiuser"
  password        = var.pg_password
  storage         = "10"
  engine          = "postgres"
  engine_version  = "10.15"
  instance_class  = "db.t2.micro"
  private_net_ids = module.my_vpc.private_subnet_ids
  environment     = "dev"
  vpc_id          = module.my_vpc.vpc_id

}

module "s3bucket" {
  source      = "../modules/s3"
  s3bucket_name = "hccrzk-dev"
}