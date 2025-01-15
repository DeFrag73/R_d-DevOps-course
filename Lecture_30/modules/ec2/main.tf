resource "aws_instance" "public" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_id
  vpc_security_group_ids = [var.security_group_id]
  associate_public_ip_address = true
  key_name      = var.key_name

  tags = {
    Name = "${var.env}-public-instance"
  }
}

resource "aws_instance" "private" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.private_subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name      = var.key_name

  tags = {
    Name = "${var.env}-private-instance"
  }
}

resource "aws_instance" "bastion" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_id
  vpc_security_group_ids = [var.security_group_id]
  associate_public_ip_address = true
  key_name      = var.key_name

  tags = {
    Name = "${var.env}-bastion"
  }
}