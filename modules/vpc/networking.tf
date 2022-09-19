resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.tenancy
  enable_dns_hostnames = var.vpc_dns_hostnames
  enable_dns_support   = var.vpc_dns_support

  tags = {
    "Name"       = "${var.environment}-vpc"
    "managed_by" = "terraform"
  }
}
#########################################################################
resource "aws_subnet" "main" {
  vpc_id     = var.vpc_id
  cidr_block = var.subnet_cidr

  tags = {

    "Name"       = "${var.environment}-subnet"
    "managed_by" = "terraform"
  }
}

resource "aws_subnet" "subnet-a" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.sbn_cidr_block_a
  map_public_ip_on_launch = var.sbn_public_ip
  availability_zone       = "${var.aws_region}${var.aws_region_a}"

  tags = {

    "Name"       = "${var.environment}-db-subnet"
    "managed_by" = "terraform"
  }
}

resource "aws_subnet" "subnet-c" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.sbn_cidr_block_c
  map_public_ip_on_launch = var.sbn_public_ip
  availability_zone       = "${var.aws_region}${var.aws_region_c}"

  tags = {

    "Name"       = "${var.environment}-db-subnet"
    "managed_by" = "terraform"
  }
}



##################################################################################
resource "aws_route_table" "rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = var.rt_cidr_block
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    "Name"       = "${var.environment}-rt"
    "managed_by" = "terraform"
  }

}

resource "aws_route_table_association" "rt_sbn_asso" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = {

    "Name"       = "${var.environment}-igw"
    "managed_by" = "terraform"
  }
}

resource "aws_security_group" "sg" {
  name        = "${var.environment}-sg"
  description = "Allow inbound traffic"
  vpc_id      = var.vpc_id

  ingress = [{
    description      = "My public IP"
    protocol         = var.sg_ingress_proto
    from_port        = var.sg_ingress_ssh
    to_port          = var.sg_ingress_ssh
    cidr_blocks      = [var.sg_ingress_cidr_block]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
    },
    {
      description      = "My public IP"
      protocol         = var.sg_ingress_proto
      from_port        = var.sg_ingress_http
      to_port          = var.sg_ingress_http
      cidr_blocks      = [var.sg_ingress_cidr_block]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "My public IP"
      protocol         = var.sg_ingress_proto
      from_port        = var.sg_ingress_https
      to_port          = var.sg_ingress_https
      cidr_blocks      = [var.sg_ingress_cidr_block]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
  }, ]

  egress = [{
    description      = "All traffic"
    protocol         = var.sg_egress_proto
    from_port        = var.sg_egress_all
    to_port          = var.sg_egress_all
    cidr_blocks      = [var.sg_egress_cidr_block]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false

  }]

  tags = {
    "Name"       = "${var.environment}-sg"
    "managed_by" = "terraform"
  }
}







###########################################################################################
output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_id" {
  value = aws_subnet.main.id
}

output "sg_id" {
  value = aws_security_group.sg.id
}

output "private_subnet_ids" {
  value = concat("${aws_subnet.subnet-a.*.id}", "${aws_subnet.subnet-c.*.id}")
}