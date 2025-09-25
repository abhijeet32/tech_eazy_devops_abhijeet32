variable "ssh_key_name" {
    description = "The name of the ssh key pair for instance"
    type = string
    default = "demo_12"
}

variable "ami_id" {
    description = "Amazon Linux 2 AMI ID"
    type = string
    default = "ami-0360c520857e3138f"
}

variable "s3_bucket_name" {
    description = "Name of the S3 bucket for logs"
    type = string
    default = "logsbucket"
}