data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.main.name
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.main.name

  depends_on = [
    aws_eks_cluster.main,
  ]
}

output "cluster_name" {
  value = aws_eks_cluster.main.name
}

output "nodes_security_group_id" {
  value = aws_security_group.nodes.id
}

output "nodes_autoscaling_group_name" {
  value = aws_autoscaling_group.main.name
}