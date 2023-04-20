resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks.arn

  vpc_config {
    subnet_ids = var.subnets
  }

  depends_on = [aws_iam_role_policy_attachment.eks]
}

resource "aws_iam_role" "eks" {
  name = "eks-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks.name
}

resource "aws_launch_template" "main" {
  name_prefix = "eks-node-"
  image_id    = "ami-0fcf52bcf5db7b003"
  instance_type = var.instance_type
  key_name = "my-key-pair"

  vpc_security_group_ids = [
    aws_security_group.nodes.id
  ]

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
      delete_on_termination = true
      volume_type = "gp2"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "nodes" {
  name_prefix = "eks-nodes-"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_autoscaling_group" "main" {
  name_prefix = "eks-node-group-"
  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }
  vpc_zone_identifier = var.subnets
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
}