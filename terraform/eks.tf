module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "my-eks-test"
  kubernetes_version = "1.30"
  enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]
  addons = {
    coredns                = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy             = {}
    vpc-cni                = {
      before_compute = true
    }
  }

  # Optional
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  # Optional: Additional cluster access entries for IAM entities (users, roles, groups) creates for codebuild to access the cluster
  access_entries = {
  codebuild = {
    principal_arn = aws_iam_role.codebuild_role.arn

    policy_associations = {
      admin = {
        policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
        access_scope = {
          type = "cluster"
        }
      }
    }
  }
}

  vpc_id                   = aws_vpc.vpc-1.id
  subnet_ids               = [aws_subnet.pub-sub-1.id,aws_subnet.pub-sub-2.id]
  control_plane_subnet_ids = [aws_subnet.priv-sub-1.id,aws_subnet.priv-sub-2.id]

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    worker-node = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["${var.instance-type}"]

      min_size     = 4
      max_size     = 6
      desired_size = 5
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}