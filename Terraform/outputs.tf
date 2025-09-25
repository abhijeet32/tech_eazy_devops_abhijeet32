output "vpc_id" {
    value = aws_vpc.tech_eazy_vpc.id
}

output "ec2_public_ip" {
    value = aws_instance.tech_eazy_ec2.public_ip
}

output "s3_bucket_name" {
    value = aws_s3_bucket.logs_bucket.id
}