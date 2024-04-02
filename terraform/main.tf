module "rhcs_cluster_rosa_hcp" {
  source                             = "./modules/terraform-rhcs-rosa-hcp"
  cluster_name                       = var.cluster_name
  openshift_version                  = var.openshift_version
  oidc_config_id                     = var.oidc_config_id
  aws_subnet_ids                     = concat(module.vpc.public_subnets, module.vpc.private_subnets)
  hack_subnet_id_machine_pool        = tolist(module.vpc.private_subnets)[0]
  kms_key_arn                        = var.kms_key_arn
  etcd_kms_key_arn                   = var.etcd_kms_key_arn
  private                            = var.private
  machine_cidr                       = var.machine_cidr
  service_cidr                       = var.service_cidr
  pod_cidr                           = var.pod_cidr
  host_prefix                        = var.host_prefix
  http_proxy                         = var.http_proxy
  https_proxy                        = var.https_proxy
  no_proxy                           = var.no_proxy
  additional_trust_bundle            = var.additional_trust_bundle
  properties                         = var.properties
  tags                               = var.tags
  wait_for_create_complete           = var.wait_for_create_complete
  etcd_encryption                    = var.etcd_encryption
  disable_waiting_in_destroy         = var.disable_waiting_in_destroy
  destroy_timeout                    = var.destroy_timeout
  upgrade_acknowledgements_for       = var.upgrade_acknowledgements_for
  replicas                           = var.replicas
  compute_machine_type               = var.compute_machine_type
  aws_availability_zones             = module.vpc.availability_zones
  autoscaler_max_pod_grace_period    = var.autoscaler_max_pod_grace_period
  autoscaler_pod_priority_threshold  = var.autoscaler_pod_priority_threshold
  autoscaler_max_node_provision_time = var.autoscaler_max_node_provision_time
  autoscaler_max_nodes_total         = var.autoscaler_max_nodes_total
  default_ingress_id                 = var.default_ingress_id
  default_ingress_listening_method   = var.default_ingress_listening_method
  path                               = var.path
  permissions_boundary               = var.permissions_boundary
  create_account_roles               = var.create_account_roles
  account_role_prefix                = var.account_role_prefix
  create_oidc                        = var.create_oidc
  managed_oidc                       = var.managed_oidc
  create_operator_roles              = var.create_operator_roles
  operator_role_prefix               = var.operator_role_prefix
  oidc_endpoint_url                  = var.oidc_endpoint_url
  machine_pools                      = var.machine_pools
}

############################
# VPC
############################
module "vpc" {
  source = "./modules/terraform-rhcs-rosa-hcp/modules/vpc"

  name_prefix              = var.cluster_name
  availability_zones_count = var.replicas
}

# module "rhcs_cluster_rosa_classic" {
#   source                                           = "./modules/terraform-rhcs-rosa-classic"
#   cluster_name                                     = var.cluster_name
#   openshift_version                                = var.openshift_version
#   oidc_config_id                                   = var.oidc_config_id
#   aws_subnet_ids                                   = var.aws_subnet_ids
#   aws_additional_infra_security_group_ids          = var.aws_additional_infra_security_group_ids
#   aws_additional_control_plane_security_group_ids  = var.aws_additional_control_plane_security_group_ids
#   kms_key_arn                                      = var.kms_key_arn
#   aws_private_link                                 = var.aws_private_link
#   private                                          = var.private
#   machine_cidr                                     = var.machine_cidr
#   service_cidr                                     = var.service_cidr
#   pod_cidr                                         = var.pod_cidr
#   host_prefix                                      = var.host_prefix
#   ec2_metadata_http_tokens                         = var.ec2_metadata_http_tokens
#   admin_credentials_username                       = var.admin_credentials_username
#   admin_credentials_password                       = var.admin_credentials_password
#   http_proxy                                       = var.http_proxy
#   https_proxy                                      = var.https_proxy
#   no_proxy                                         = var.no_proxy
#   additional_trust_bundle                          = var.additional_trust_bundle
#   properties                                       = var.properties
#   wait_for_create_complete                         = var.wait_for_create_complete
#   disable_workload_monitoring                      = var.disable_workload_monitoring
#   disable_scp_checks                               = var.disable_scp_checks
#   etcd_encryption                                  = var.etcd_encryption
#   fips                                             = var.fips
#   disable_waiting_in_destroy                       = var.disable_waiting_in_destroy
#   destroy_timeout                                  = var.destroy_timeout
#   upgrade_acknowledgements_for                     = var.upgrade_acknowledgements_for
#   multi_az                                         = var.multi_az
#   autoscaling_enabled                              = var.autoscaling_enabled
#   replicas                                         = var.replicas
#   min_replicas                                     = var.min_replicas
#   max_replicas                                     = var.max_replicas
#   compute_machine_type                             = var.compute_machine_type
#   worker_disk_size                                 = var.worker_disk_size
#   default_mp_labels                                = var.default_mp_labels
#   aws_availability_zones                           = var.aws_availability_zones
#   aws_additional_compute_security_group_ids        = var.aws_additional_compute_security_group_ids
#   cluster_autoscaler_enabled                       = var.cluster_autoscaler_enabled
#   autoscaler_balance_similar_node_groups           = var.autoscaler_balance_similar_node_groups
#   autoscaler_skip_nodes_with_local_storage         = var.autoscaler_skip_nodes_with_local_storage
#   autoscaler_log_verbosity                         = var.autoscaler_log_verbosity
#   autoscaler_max_pod_grace_period                  = var.autoscaler_max_pod_grace_period
#   autoscaler_pod_priority_threshold                = var.autoscaler_pod_priority_threshold
#   autoscaler_ignore_daemonsets_utilization         = var.autoscaler_ignore_daemonsets_utilization
#   autoscaler_max_node_provision_time               = var.autoscaler_max_node_provision_time
#   autoscaler_balancing_ignored_labels              = var.autoscaler_balancing_ignored_labels
#   autoscaler_max_nodes_total                       = var.autoscaler_max_nodes_total
#   autoscaler_cores                                 = var.autoscaler_cores
#   autoscaler_memory                                = var.autoscaler_memory
#   autoscaler_gpus                                  = var.autoscaler_gpus
#   autoscaler_scale_down_enabled                    = var.autoscaler_scale_down_enabled
#   autoscaler_scale_down_unneeded_time              = var.autoscaler_scale_down_unneeded_time
#   autoscaler_scale_down_utilization_threshold      = var.autoscaler_scale_down_utilization_threshold
#   autoscaler_scale_down_delay_after_add            = var.autoscaler_scale_down_delay_after_add
#   autoscaler_scale_down_delay_after_delete         = var.autoscaler_scale_down_delay_after_delete
#   autoscaler_scale_down_delay_after_failure        = var.autoscaler_scale_down_delay_after_failure
#   default_ingress_id                               = var.default_ingress_id
#   default_ingress_route_selectors                  = var.default_ingress_route_selectors
#   default_ingress_excluded_namespaces              = var.default_ingress_excluded_namespaces
#   default_ingress_route_wildcard_policy            = var.default_ingress_route_wildcard_policy
#   default_ingress_route_namespace_ownership_policy = var.default_ingress_route_namespace_ownership_policy
#   default_ingress_cluster_routes_hostname          = var.default_ingress_cluster_routes_hostname
#   default_ingress_load_balancer_type               = var.default_ingress_load_balancer_type
#   default_ingress_cluster_routes_tls_secret_ref    = var.default_ingress_cluster_routes_tls_secret_ref
#   path                                             = var.path
#   permissions_boundary                             = var.permissions_boundary
#   create_account_roles                             = var.create_account_roles
#   account_role_prefix                              = var.account_role_prefix
#   create_oidc                                      = var.create_oidc
#   managed_oidc                                     = var.managed_oidc
#   create_operator_roles                            = var.create_operator_roles
#   operator_role_prefix                             = var.operator_role_prefix
#   oidc_endpoint_url                                = var.oidc_endpoint_url
#   machine_pools                                    = var.machine_pools
#   identity_providers                               = var.identity_providers
#   tags                                             = var.tags
# }

