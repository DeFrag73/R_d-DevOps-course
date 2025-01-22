output "app_instance" {
  value = aws_instance.app_instance.public_ip
}

output "jenkins_master" {
  value = aws_instance.jenkins_master.public_ip
}

output "jenkins_worker" {
  value = aws_instance.jenkins_worker.public_ip
}