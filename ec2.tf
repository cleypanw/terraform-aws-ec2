resource "aws_key_pair" "ssh_key" {
  key_name   = local.sshkey_name
  public_key = "${var.public_ssh_key}"
}

resource "aws_instance" "ec2instance" {

  ami                       = data.aws_ami.ubuntu.id
  instance_type             = "t2.micro"
  subnet_id                 = aws_subnet.public.id
  private_ip                = "10.0.4.10"
  vpc_security_group_ids    = ["${aws_security_group.sg-ec2.id}"]

  #checkov:skip=CKV_AWS_88
  associate_public_ip_address   = true

  key_name = "${aws_key_pair.ssh_key.key_name}"

  root_block_device {
    delete_on_termination   = true
    volume_size             = 20
    volume_type             = "gp2"
    encrypted               = true
  }

  ## https://docs.bridgecrew.io/docs/bc_aws_general_31
  #metadata_options {
  #  http_endpoint = "enabled"
  #  http_tokens   = "required"
  #}

  depends_on = [
    aws_key_pair.ssh_key
  ]

  tags = {
    Name  = local.ec2_instance_name
  }
}