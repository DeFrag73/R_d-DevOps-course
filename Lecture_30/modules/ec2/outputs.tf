output "public_instance_id" {
  value = aws_instance.public.id
}

output "private_instance_id" {
  value = aws_instance.private.id
}

output "bastion_instance_id" {
  value = aws_instance.bastion.id
}

output "bastion_instance_name" {
  value = aws_instance.bastion.tags.Name
}

output "public_instance_name" {
  value = aws_instance.public.tags.Name
}

output "private_instance_name" {
  value = aws_instance.private.tags.Name
}

output "public_sg_id" {
  value = aws_security_group.public_sg.id
}

output "private_sg_id" {
  value = aws_security_group.private_sg.id
}

output "bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}