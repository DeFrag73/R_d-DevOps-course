output "public_instance_id" {
  value = aws_instance.public.id
}

output "private_instance_id" {
  value = aws_instance.private.id
}

output "bastion_instance_id" {
  value = aws_instance.bastion.id
}