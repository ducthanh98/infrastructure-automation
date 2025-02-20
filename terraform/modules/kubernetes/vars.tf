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

variable "private_subnets" {
  type = list(string)
}

variable "eks_worker_role_arn" {
  type = string
}

variable "eks_cluster_role_arn" {
  type = string
}

variable "eks_cluster_sg" {
  type = list(string)
}

variable "eks_worker_sg" {
  type = list(string)
}