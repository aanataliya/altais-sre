resource "aws_key_pair" "altais-key" {
  key_name   = "altais-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC0tkKQ45yQam6KV0RSH5jMJmkrKBvghbNjd4d8q48BIW6MgEbjGvBPtrSoo0AsuQtmRXc+EU49zwvl32iKHB3xiObOQZDtuAOofzhIOtSo8zq+Bbv9qOWrYOHHCH3su3JpvMZnQCTlXY+X2Yi3PUw3Eg5CpWsd9rpaYrwbIz4hSozVz8xUCDsGD9eSNjMr0JolIcXob7A1oDRC614Tovrdc3C7ktWkSxddyJUbnpaRuHNqdwJeOmT1PK+yI+J32A3OFhQwEWl1130vhAPqmJwFh4V2Iwziyu88MDz2Dkie9awOPtlvMH5DgO/sNjEGnmBHyPc36U1L6pz4atzb8XWH717PnV4myQBjLoD94FAVqVYZQXWwoCNxSwabZXI4fZLa+Q+nwsFECfZzOypCt/O9Sq0G6tGM+02z0QMLvvdRDK4Zdhvgz4dyk09hSSX8waj5zJ+6ldyhQSCLXeh4cK5jujtHcP7MhmvgBttE3u5XaZaVUKIIiA0GiMpunfqIe0E= Ashif_Nataliya@EPGBLONW004D"
}

resource "aws_security_group" "altais-ec2-sg" {
  vpc_id      = module.vpc.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = "22"
    to_port     = "22"
    cidr_blocks = ["${var.cidr}","90.247.84.240/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Traffic
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  tags = {
    Name = "altais-ec2-sg"
  }

}

data "aws_subnet" "public_sub"{
  cidr_block = "${var.public_subnets[0]}"
  depends_on = [module.vpc]
}

resource "aws_instance" "apache_server" {
  ami           = "${var.apache-ami}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.altais-ec2-sg.id}"]
  subnet_id = data.aws_subnet.public_sub.id
  key_name = "altais-key"
  associate_public_ip_address = true

  user_data = <<-EOF
  #!/bin/bash
  echo "*** Installing apache"
  sudo yum update -y
  sudo yum install httpd -y
  sudo touch /var/www/html/index.html
  sudo echo "Hi Altias" >> /var/www/html/index.html
  sudo systemctl start httpd.service
  sudo systemctl enable httpd.service
  echo "*** Completed Installing apache"
  EOF

  tags = {
    Name = "altais-apache-ec2"
  }
}
