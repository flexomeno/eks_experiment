output "kubeconfig" {
  value = aws_eks_cluster.main.kubeconfig
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