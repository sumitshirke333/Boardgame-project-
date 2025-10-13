##############################################
# 🚀 Terraform - AWS Master & Worker Infra
##############################################

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

##############################################
# 1️⃣ VPC
##############################################
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "boardgame-vpc"
  }
}

##############################################
# 2️⃣ Subnet
##############################################
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone

  tags = {
    Name = "boardgame-public-subnet"
  }
}

##############################################
# 3️⃣ Internet Gateway + Route Table
##############################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "boardgame-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "boardgame-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

##############################################
# 4️⃣ Security Groups
##############################################

# Master SG: Jenkins + SonarQube + SSH + Outbound
resource "aws_security_group" "master_sg" {
  name        = "master-sg"
  description = "Security group for Master Node"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "Allow Jenkins UI"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SonarQube UI"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "master-sg"
  }
}

# Worker SG: Allow 8080 from Master + SSH from anywhere (for project)
resource "aws_security_group" "worker_sg" {
  name        = "worker-sg"
  description = "Security group for Worker Node"
  vpc_id      = aws_vpc.main_vpc.id

  # Application traffic from Master
  ingress {
    description     = "Allow app port from Master SG"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.master_sg.id]
  }

  # SSH from anywhere (for project setup)
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "worker-sg"
  }
}

##############################################
# 5️⃣ EC2 Instances (Master & Worker)
##############################################

# Master Node (Jenkins + Ansible + SonarQube)
resource "aws_instance" "master_node" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.master_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = "master-node"
    Role = "Jenkins-Ansible-SonarQube"
  }
}

# Worker Node (Application)
resource "aws_instance" "worker_node" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.worker_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = "worker-node"
    Role = "Application"
  }
}
