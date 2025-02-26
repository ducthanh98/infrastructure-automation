resource "aws_network_acl" "public_nacl" {
    vpc_id = var.vpc_id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_block = "0.0.0.0/0"
        action = "allow"
        rule_no = 100
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_block = "0.0.0.0/0"
        action = "allow"
        rule_no = 200

    }

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_block = "10.0.0.0/16"
        action = "allow"
        rule_no = 300

    }

    ingress {
        from_port = 1024
        to_port = 65535
        protocol = "tcp"
        cidr_block = "0.0.0.0/0"
        action = "allow"
        rule_no = 400
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_block = "0.0.0.0/0"
        action = "allow"
        rule_no = 500
    }

    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_block = "0.0.0.0/0"
        action = "allow"
        rule_no = 100
    }

    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_block = "0.0.0.0/0"
        action = "allow"
        rule_no = 200
    }


    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_block = "10.0.0.0/16"
        action = "allow"
        rule_no = 300
    }

    

    egress {
        from_port = 1024
        to_port = 65535
        protocol = "tcp"
        cidr_block = "0.0.0.0/0"
        action = "allow"
        rule_no = 400
    }

    egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_block = "0.0.0.0/0"
        action = "allow"
        rule_no = 500
    }

    tags = {
      Name: "${var.project_id}_public_nacl"
      project_id: var.project_id
    }
  
}

resource "aws_network_acl_association" "public_nacl_association" {
  count = length(var.public_subnets)

  network_acl_id = aws_network_acl.public_nacl.id
  subnet_id = var.public_subnets[count.index]
}

resource "aws_network_acl" "private_nacl" {
    vpc_id = var.vpc_id

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_block = "10.0.0.0/16"
        action = "allow"
        rule_no = 100

    }

    ingress {
        from_port = 1024
        to_port = 65535
        protocol = "tcp"
        cidr_block = "0.0.0.0/0"
        action = "allow"
        rule_no = 200
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_block = "0.0.0.0/0"
        action = "allow"
        rule_no = 300
    }


    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_block = "0.0.0.0/0"
        action = "allow"
        rule_no = 100
    }

    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_block = "0.0.0.0/0"
        action = "allow"
        rule_no = 200
    }

    egress {
        from_port = 1024
        to_port = 65535
        protocol = "tcp"
        cidr_block = "0.0.0.0/0"
        action = "allow"
        rule_no = 300
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_block = "0.0.0.0/0"
        action = "allow"
        rule_no = 400
    }

    tags = {
      Name: "${var.project_id}_private_nacl"
      project_id: var.project_id
    }
  
}

resource "aws_network_acl_association" "private_nacl_association" {
  count = length(var.private_subnets)


  network_acl_id = aws_network_acl.private_nacl.id
  subnet_id = var.private_subnets[count.index]
}


// Security group

// EKS
# Security Group cho EKS Cluster
resource "aws_security_group" "eks_cluster_sg" {
  name   = "eks-cluster-sg"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 4️⃣ Security Group cho Worker Nodes
resource "aws_security_group" "eks_worker_sg" {
  name   = "eks-worker-sg"
  vpc_id = var.vpc_id

  # Cho phép giao tiếp giữa các worker nodes
  ingress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    self = true
    cidr_blocks = [] 
  }

  # Pod communication
  ingress {
    from_port       = 10250
    to_port         = 10255
    protocol        = "tcp"
    self = true
    cidr_blocks = [] 
  }

  ingress {
    from_port       = 30000
    to_port         = 32767
    protocol        = "tcp"
    self = true
    cidr_blocks = [] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Cho phép worker nodes truy cập API Server của EKS
resource "aws_security_group_rule" "allow_worker_access_cluster" {
    security_group_id = aws_security_group.eks_worker_sg.id
    type = "ingress"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    source_security_group_id = aws_security_group.eks_cluster_sg.id
}

 # Cho phép truy cập API Server từ Worker Nodes
resource "aws_security_group_rule" "allow_cluster_access_worker" {
    security_group_id = aws_security_group.eks_worker_sg.id
    type = "ingress"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    source_security_group_id = aws_security_group.eks_cluster_sg.id
}


# Ec2 Bastion SG

resource "aws_security_group" "bastion_sg" {
  name   = "bastion-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Chỉ cho phép IP cụ thể truy cập SSH
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
