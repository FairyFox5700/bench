resource "aws_key_pair" "scalla-key" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = var.private_key_algorithm
  rsa_bits  = var.private_key_rsa_bits
}

resource "local_file" "scalla-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = var.private_key_file_name
}