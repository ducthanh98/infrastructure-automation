variable "project_id" {
  type = string
}

variable "bastion_sg" {
  type = string
}

variable "bastion_eip" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}
