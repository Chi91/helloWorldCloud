#Create security group for loadbalancer
resource "aws_security_group" "lb_sg" {
  name   = "alb-sg"
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "alb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_lb_sg" {
  security_group_id = aws_security_group.lb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"

}

resource "aws_vpc_security_group_egress_rule" "egress_lb_sg" {
  security_group_id = aws_security_group.lb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
