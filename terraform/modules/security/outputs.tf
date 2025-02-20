output "eks_cluster_sg" {
  value = aws_security_group.eks_cluster_sg.id
}

output "eks_worker_sg" {
  value = aws_security_group.eks_worker_sg.id
}