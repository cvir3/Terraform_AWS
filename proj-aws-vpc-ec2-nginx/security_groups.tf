resource "aws_security_group" "nginx-sg" {
  vpc_id = aws_vpc.my_vpc.id

  #Inbound rule for HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Outbound rule for HTTP(Allow all outbound)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG_Nginx"
  }

  /*
Note:- 
    Ingress means inbound rule
    Egress means outbound rule
    Nginx is lesten on 80 port number
    For protocol -1 is for all protocal 
*/
}
