resource "rhcs_hcp_machine_pool" "machine_pool" {
  cluster                 = var.cluster_id
  name                    = var.name
  replicas                = var.replicas
  autoscaling             = var.autoscaling
  labels                  = var.labels
  taints                  = var.taints
  subnet_id               = var.subnet_id
  aws_node_pool           = var.aws_node_pool
  auto_repair             = var.auto_repair

  lifecycle {
    ignore_changes = [
      cluster,
      name,
    ]
  }
}
