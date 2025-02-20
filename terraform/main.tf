provider "aws" {
  region = var.aws_region
}

module "eip" {
  source = "./modules/eip"
  project_id = "jaeger"
}

module "network" {
  source = "./modules/network"

  project_id = "jaeger"
  nat_eip = module.eip.natgw_ip
}


module "security" {
  source = "./modules/security"
  vpc_id = module.network.vpc_id
  region = var.aws_region
  project_id = "jaeger"

  public_subnets = module.network.public_subnets
  private_subnets = module.network.private_subnets
  depends_on = [module.network]
}

module "iam" {
  source = "./modules/iam"
}

module "eks" {
  source = "./modules/kubernetes"

  vpc_id = module.network.vpc_id
  region = var.aws_region
  project_id = "jaeger"

  private_subnets = module.network.private_subnets

  eks_cluster_role_arn = module.iam.eks_cluster_role_arn
  eks_worker_role_arn = module.iam.eks_worker_role_arn 
  eks_cluster_sg = [module.security.eks_cluster_sg]
  eks_worker_sg = [module.security.eks_worker_sg]


}

