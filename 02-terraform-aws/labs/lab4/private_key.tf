resource "tls_private_key" "demo4_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "demo" {
  key_name   = "demo_key_auto"
  public_key = tls_private_key.demo4_key.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.demo4_key.private_key_pem
  filename = "${path.module}/demo_key_auto.pem"
}
