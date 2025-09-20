provider "aws" {
    region = "us-east-1"
}

resource "aws_vpc" "tech_eazy_vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    
    tags = {
        Name = "tech-eazy-vpc"
    }
}

resource "aws_subnet" "tech_eazy_subnet" {
    vpc_id = aws_vpc.tech_eazy_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true

    tags = {
        Name = "tech-eazy-subnet"
    }
}

resource "aws_internet_gateway" "tech_eazy_igw" {
    vpc_id = aws_vpc.tech_eazy_vpc.id

    tags = {
        Name = "tech-eazy-internet-gateway"
    }
}

resource "aws_route_table" "tech_eazy_rt" {
    vpc_id = aws_vpc.tech_eazy_vpc.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.tech_eazy_igw.id
    }

    tags = {
        Name = "tech-eazy-routtable"
    }
}

resource "aws_route_table_association" "tech-eazy_rta" {
    subnet_id = aws_subnet.tech_eazy_subnet.id
    route_table_id = aws_route_table.tech_eazy_rt.id
}

resource "aws_security_group" "tech_eazy_sg" {
    vpc_id = aws_vpc.tech_eazy_vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "tech-eazy-security-group"
    }
}

resource "aws_instance" "tach_eazy_ec2" {
    ami = var.ami_id
    instance_type = "t2.medium"
    subnet_id = aws_subnet.tech_eazy_subnet.id
    vpc_security_group_ids = [aws_security_group.tech_eazy_sg.id]
    associate_public_ip_address = true
    key_name = var.ssh_key_name

    tags = {
        Name = "tech-eazy-instance"
    }
}