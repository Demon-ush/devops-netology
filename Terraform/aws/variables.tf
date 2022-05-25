variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "deploy_username" {
  type = string
}

variable "deploy_password" {
  type = string
}

variable "secret_key" {
  description = "Enter the secret key"
}

variable "access_key" {
  description = "Enter the access key"
}

variable "public_key" {
  description = "Enter the public SSH key"
}

variable "pubkey_name" {
  description = "Enter the name of the public SSH key"
}

variable "bucket_name" {
  description = "Enter the bucket name"
}

variable "az" {
  description = "Enter availability zone (ru-msk-comp1p by default)"
  default     = "ru-msk-comp1p"
}

variable "eips_count" {
  description = "Enter the number of Elastic IP addresses to create (1 by default)"
  default     = 1
}

variable "vms_count" {
  description = "Enter the number of virtual machines to create (1 by default)"
  default     = 1
}

variable "hostnames" {
  description = "Enter hostnames of VMs"
}

variable "allow_tcp_ports" {
  description = "Enter TCP ports to allow connections to (22, 80, 443 by default)"
  default     = [22, 80, 443]
}

variable "vm_template" {
  description = "Enter the template ID to create a VM from (cmi-3CF790E9 [CentOS 8.2] by default)"
  default     = "cmi-3CF790E9"
}

variable "vm_instance_type" {
  description = "Enter the instance type for a VM (m5.2small by default)"
  default     = "t2.micro"
}

variable "vm_volume_type" {
  description = "Enter the volume type for VM disks (gp2 by default)"
  default     = "gp2"
}

variable "vm_volume_size" {
  description = "Enter the volume size for VM disks (32 by default, in GiB, must be multiple of 32)"
  default     = 32
}