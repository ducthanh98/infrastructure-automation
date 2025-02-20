variable "project_id" {
  type        = string
  description = "Region"
}

variable "region" {
  type        = string
  description = "Region"
}

variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}