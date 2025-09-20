variable "ssh_key_name" {
    description = "The name of the ssh key pair for instance"
    type = string
    default = "demo_12"
}

variable "ami_id" {
    type = string
    default = "ami-0360c520857e3138f"
}