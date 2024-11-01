#create a network ACL for private subnet
resource "aws_network_acl" "private_nacl" {
  vpc_id = module.vpc.vpc_id

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "private-nacl"
  }
}
