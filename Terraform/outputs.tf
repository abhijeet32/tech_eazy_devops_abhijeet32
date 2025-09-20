output "vpc_id" {
    value = aws_vpc.tech_eazy_vpc.id
}

output "ec2_public_ip" {
    value = aws_instance.tach_eazy_ec2.public_ip
}