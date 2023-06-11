variable "region" {
  description = "Region instance"
  default     = "us-east-1"
}

variable "name" {
  description = "Application name"
  default     = "elk"
}

variable "ami" {
  description = "AWS AMI to be used"
  default     = "ami_elk"
}

variable "instance_type" {
  description = "hardware configuration"
  default     = "t2.medium"
}

variable "sg_elk" {
  description = "Security group of application"
}

variable "availability_zones" {
  description = "available zones"
  default     = ["us-east-1a"]
}

variable "keypair_name" {
  description = "Kay pair name"
}

variable "owner" {
  description = "GitHub user"
  default     = "julianooen"
}

variable "project" {
  description = "Project name"
  default     = "Tema13"
}

variable "ec2_economizator" {
  default = "TRUE"
}

variable "customerid" {
  default = "ILEGRA"
}