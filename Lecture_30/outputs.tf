output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.subnet.public_subnet_id
}

output "private_subnet_id" {
  value = module.subnet.private_subnet_id
}

output "public_instance_id" {
  value = module.ec2.public_instance_id
}

output "private_instance_id" {
  value = module.ec2.private_instance_id
}

output "public_sg_id" {
  value = module.ec2.public_sg_id
}

output "private_sg_id" {
  value = module.ec2.private_sg_id
}

output "bastion_sg_id" {
  value = module.ec2.bastion_sg_id
}