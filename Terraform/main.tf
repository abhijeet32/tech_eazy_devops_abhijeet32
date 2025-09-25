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

resource "aws_iam_role" "s3_readonly_role" {
    name = "tech-eazy-s3-readonly"
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [{
            Effect = "Allow",
            Principal = { 
                Service = "ec2.amazonaws.com" 
            },
            Action = "sts:AssumeRole"
        }]
    })
}

resource "aws_iam_role_policy" "s3_readonly_policy" {
    name = "s3-readonly-policy"
    role = aws_iam_role.s3_readonly_role.id
    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
            Effect   = "Allow",
            Action   = ["s3:ListBucket"],
            Resource = aws_s3_bucket.logs_bucket.arn
            },
            {
            Effect   = "Allow",
            Action   = ["s3:GetObject"],
            Resource = "${aws_s3_bucket.logs_bucket.arn}/*"
            }
        ]
    })
}

resource "aws_iam_role" "s3_upload_role" {
    name = "tech-eazy-s3-uploader"
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [{
            Effect = "Allow",
            Principal = { 
                Service = "ec2.amazonaws.com" 
            },
            Action = "sts:AssumeRole"
        }]
    })
}

resource "aws_iam_role_policy" "s3_upload_policy" {
    name = "s3-upload-policy"
    role = aws_iam_role.s3_upload_role.id
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
            Effect = "Allow"
            Action = [
                "s3:CreateBucket"
            ]
            Resource = "*"
            },
            {
            Effect = "Allow"
            Action = [
                "s3:PutObject"
            ]
            Resource = "${aws_s3_bucket.logs_bucket.arn}/*"
            }
        ]
    })
}

resource "aws_iam_instance_profile" "uploader_profile" {
    name = "tech-eazy-instance-profile"
    role = aws_iam_role.s3_upload_role.name
}


resource "random_id" "bucket_id" {
    byte_length = 4
}

resource "aws_s3_bucket" "logs_bucket" {
    bucket = "${var.s3_bucket_name}-${random_id.bucket_id.hex}"
}

resource "aws_s3_bucket_lifecycle_configuration" "logs_lifecycle" {
    bucket = aws_s3_bucket.logs_bucket.id

    rule {
        id = "log-expiration"
        status = "Enabled"

        filter {}

        expiration {
            days = 7
        }
    }
}


resource "aws_instance" "tech_eazy_ec2" {
    ami = var.ami_id
    instance_type = "t2.medium"
    subnet_id = aws_subnet.tech_eazy_subnet.id
    vpc_security_group_ids = [aws_security_group.tech_eazy_sg.id]
    associate_public_ip_address = true
    key_name = var.ssh_key_name
    iam_instance_profile = aws_iam_instance_profile.uploader_profile.name


    user_data = <<-EOT
    #!/bin/bash
    apt-get update -y
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    sudo apt install unzip
    unzip awscliv2.zip
    sudo ./aws/install
    mkdir -p /app/logs && echo "App log" > /app/logs/app.log
    BUCKET="${aws_s3_bucket.logs_bucket.id}"
    aws s3 cp /var/log/cloud-init.log s3://$BUCKET/logs/system/
    aws s3 cp /app/logs s3://$BUCKET/logs/app/ --recursive
    EOT


    tags = {
        Name = "tech-eazy-instance"
    }
}