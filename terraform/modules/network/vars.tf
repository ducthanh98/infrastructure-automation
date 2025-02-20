variable "region" {
  default = "ap-southeast-1"
}

variable "project_id" {
  type = string
  description = "Project name"
}

variable "cidr_block" {
  type = string
  description = "VPC CIDR Block"
  default = "10.0.0.0/16"
}


variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type = list(string)
  default = [ "10.0.0.0/22","10.0.4.0/22","10.0.8.0/22" ]
}

variable "private_subnets" {
  description = "List of public subnet CIDR blocks"
  type = list(string)
  default = [ "10.0.16.0/20","10.0.32.0/20","10.0.48.0/20" ]
}

variable "nat_eip" {
  type = string
}