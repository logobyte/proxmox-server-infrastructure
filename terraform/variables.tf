variable "aws_region" {
  description = "AWS region where resources will be created."
  type        = string
  default     = "ap-southeast-1"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance. Supply a valid AMI for your selected region."
  type        = string

  validation {
    condition     = can(regex("^ami-[0-9a-fA-F]+$", var.ami_id))
    error_message = "ami_id must look like a valid AWS AMI ID."
  }
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance."
  type        = string
  default     = "portfolio-demo"
}
