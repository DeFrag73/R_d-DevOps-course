provider "aws" {
  region     = var.region
}

# Отримання останнього AMI ID для Amazon Linux 2
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's owner ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
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

module "route_tables" {
  source = "./modules/route_tables"

  vpc_id           = module.vpc.vpc_id
  igw_id           = module.vpc.igw_id
  public_subnet_id = module.subnet.public_subnet_id
  private_subnet_id = module.subnet.private_subnet_id
  env              = var.env
}

# module "security_group" {
#   source = "./modules/security_group"
#
#   vpc_id           = module.vpc.vpc_id
#   env              = var.env
#   name             = "${var.env}-sg"
# }

module "ec2" {
  source = "./modules/ec2"

  vpc_id              = module.vpc.vpc_id
  ami_id              = data.aws_ami.ubuntu.id
  instance_type       = var.instance_type
  public_subnet_id    = module.subnet.public_subnet_id
  private_subnet_id   = module.subnet.private_subnet_id
  key_name            = var.key_name
  env                 = var.env
  private_subnet_cidr = var.private_subnet_cidr
  public_subnet_cidr  = var.public_subnet_cidr

  public_ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port = -1
      to_port   = -1
      protocol  = "icmp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  public_egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  private_ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 27017
      to_port     = 27017
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 27018
      to_port     = 27018
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port = -1
      to_port   = -1
      protocol  = "icmp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  private_egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  bastion_ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port = -1
      to_port   = -1
      protocol  = "icmp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  bastion_egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}


