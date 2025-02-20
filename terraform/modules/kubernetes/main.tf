resource "aws_eks_cluster" "eks" {
  name = "${var.project_id}-eks"
  role_arn = var.eks_cluster_role_arn

  vpc_config {
    security_group_ids = var.eks_cluster_sg
    subnet_ids = var.private_subnets
    endpoint_private_access = false  # Enables private access
    endpoint_public_access  = true # Disables public access
  }

  tags = {
    project_id = var.project_id
  }
}


# 8️⃣ Tạo Spot Worker Node Group
resource "aws_eks_node_group" "spot_workers" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "spot-worker-nodes"
  node_role_arn   = var.eks_worker_role_arn
  subnet_ids      = var.private_subnets
  

  instance_types = ["t2.micro"]  # Free Tier Instance

  remote_access {
    ec2_ssh_key = "thanhld"
  }


  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 1
  }



  # depends_on = [aws_iam_role_policy_attachment.eks_worker_policy]
}
