resource "aws_instance" "nginxserver" {
  ami                         = "ami-051a31ab2f4d498f5" #This is for Amazon Machine Image(os id)
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public-subnet.id
  vpc_security_group_ids      = [aws_security_group.nginx-sg.id]
  associate_public_ip_address = true

  #EOF:- End of File
  user_data = <<-EOF
            #!/bin/bash
            sudo yum install nginx -y
            sudo systemctl start nginx
            EOF

  tags = {
    Name = "Nginx-Server"
  }
}
