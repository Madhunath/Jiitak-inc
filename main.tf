provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

resource "aws_vpc" "proj_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "proj-vpc"
  }
}

resource "aws_subnet" "proj_subnet" {
  vpc_id     = aws_vpc.proj_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"
  tags = {
    Name = "proj-subnet"
  }
}

resource "aws_internet_gateway" "proj_igw" {
  vpc_id = aws_vpc.proj_vpc.id
}

resource "aws_route_table" "proj_route_table" {
  vpc_id = aws_vpc.proj_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.proj_igw.id
  }
}

resource "aws_instance" "project_instance" {
  ami           = "ami-0ee4f2271a4df2d7d"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.proj_subnet.id
  key_name      = "awskey"
  associate_public_ip_address = true

  tags = {
    Name = "project-instance"
  }
}
