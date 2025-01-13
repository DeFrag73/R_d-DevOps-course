provider "aws" {
  region     = var.region
}

# Отримання останнього AMI ID для Amazon Linux 2
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr = var.vpc_cidr
  env      = var.env
}

module "subnet" {
  source = "./modules/subnet"

  vpc_id             = module.vpc.vpc_id
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  az                 = var.az
  igw_id             = module.vpc.igw_id
  env                = var.env
}

module "ec2" {
  source = "./modules/ec2"

  ami_id           = data.aws_ami.amazon_linux_2.id
  instance_type    = var.instance_type
  public_subnet_id = module.subnet.public_subnet_id
  private_subnet_id = module.subnet.private_subnet_id
  env              = var.env
}