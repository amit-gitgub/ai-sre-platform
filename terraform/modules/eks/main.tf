# Create the IAM role for the cluster

resource "aws_iam_role" "eks_cluster_role" {
    name = "${var.cluster_name}-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Service = "eks.amazonaws.com"

                }

                Action = "sts:AssumeRole"
            }
        ]
    })
  
}

# Attached the policy to the role
resource "aws_iam_role_policy_attachment" "eks_cluster" {
    role = aws_iam_role.eks_cluster_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  
}

# Create the cluster (Kubernetes Control Plane only...NOT the worker node)

resource "aws_eks_cluster" "this" {
  name = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = concat(
      var.public_subnet_ids,
      var.private_subnet_ids
    )
  }
  depends_on = [ 
    aws_iam_role_policy_attachment.eks_cluster
   ]
}

# Create the Node group role

resource "aws_iam_role" "node_role" {
    name = "${var.cluster_name}-node-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
                Action = "sts:AssumeRole"


            }

            
        ]
    })
  
}

# Enable Worker nodes to join the cluster.
resource "aws_iam_role_policy_attachment" "worker_node_policy" {

  role = aws_iam_role.node_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  
}
#Enable Pods  networking.
resource "aws_iam_role_policy_attachment" "node_networking" {

  role = aws_iam_role.node_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  
}
# Enable Pull Docker Images from ECR
resource "aws_iam_role_policy_attachment" "node_pull_docker_image" {

  role = aws_iam_role.node_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  
}

# Managed node group 

resource "aws_eks_node_group" "this" {
    cluster_name = aws_eks_cluster.this.name
    node_group_name = "platform-workers"
    node_role_arn = aws_iam_role.node_role.arn
    subnet_ids = var.public_subnet_ids

    scaling_config {
      desired_size = 2
      max_size = 3
      min_size = 2
    }

    instance_types = ["t3.micro"]
  
}