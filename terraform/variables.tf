################################
# Authentication variables
################################

variable "RHCS_TOKEN" {
  type      = string
  sensitive = true
  default   = ""
}

variable "helm_token" {
  type      = string
  sensitive = true
  default   = ""
}

variable "AWS_ACCESS_KEY_ID" {
  type      = string
  sensitive = true
  default   = ""
}

variable "AWS_SECRET_ACCESS_KEY" {
  type      = string
  sensitive = true
  default   = ""
}

variable "AWS_DEFAULT_REGION" {
  type      = string
  sensitive = true
  default   = ""
}

################################
# Cluster variables.
################################

variable "cluster_name" {
  type        = string
  description = "Name of the cluster. After the creation of the resource, it is not possible to update the attribute value."
}

variable "openshift_version" {
  type        = string
  description = "Desired version of OpenShift for the cluster, for example '4.1.0'. If version is greater than the currently running version, an upgrade will be scheduled."
}

variable "oidc_config_id" {
  type        = string
  default     = null
  description = "The unique identifier associated with users authenticated through OpenID Connect (OIDC) within the ROSA cluster."
}

variable "aws_subnet_ids" {
  type        = list(string)
  default     = []
  description = "The Subnet IDs to use when installing the cluster. Leave empty for installer provisioned subnet IDs."
}

variable "kms_key_arn" {
  type        = string
  default     = null
  description = "The key ARN is the Amazon Resource Name (ARN) of a CMK. It is a unique, fully qualified identifier for the CMK. A key ARN includes the AWS account, Region, and the key ID."
}

variable "etcd_kms_key_arn" {
  type        = string
  default     = null
  description = "The key ARN is the Amazon Resource Name (ARN) of a CMK. It is a unique, fully qualified identifier for the CMK. A key ARN includes the AWS account, Region, and the key ID."
}

variable "private" {
  type        = bool
  default     = false
  description = "Restrict master API endpoint and application routes to direct, private connectivity. (default: false)"
}

variable "machine_cidr" {
  type        = string
  default     = null
  description = "Block of IP addresses used by OpenShift while installing the cluster, for example \"10.0.0.0/16\"."
}

variable "service_cidr" {
  type        = string
  default     = null
  description = "Block of IP addresses for services, for example \"172.30.0.0/16\"."
}

variable "pod_cidr" {
  type        = string
  default     = null
  description = "Block of IP addresses from which Pod IP addresses are allocated, for example \"10.128.0.0/14\"."
}

variable "host_prefix" {
  type        = number
  default     = null
  description = "Subnet prefix length to assign to each individual node. For example, if host prefix is set to \"23\", then each node is assigned a /23 subnet out of the given CIDR."
}

##############################################################
# Proxy variables
##############################################################

variable "http_proxy" {
  type        = string
  default     = null
  description = "A proxy URL to use for creating HTTP connections outside the cluster. The URL scheme must be http."
}

variable "https_proxy" {
  type        = string
  default     = null
  description = "A proxy URL to use for creating HTTPS connections outside the cluster."
}

variable "no_proxy" {
  type        = string
  default     = null
  description = "A comma-separated list of destination domain names, domains, IP addresses or other network CIDRs to exclude proxying."
}

variable "additional_trust_bundle" {
  type        = string
  default     = null
  description = "A string containing a PEM-encoded X.509 certificate bundle that will be added to the nodes' trusted certificate store."
}

##############################################################
# Optional properties and tags
##############################################################

variable "properties" {
  description = "User defined properties."
  type        = map(string)
  default     = null
}

variable "tags" {
  description = "Apply user defined tags to all cluster resources created in AWS. After the creation of the cluster is completed, it is not possible to update this attribute."
  type        = map(string)
  default     = null
}

##############################################################
# Optional ROSA Cluster Installation flags
##############################################################

variable "wait_for_create_complete" {
  type        = bool
  default     = true
  description = "Wait until the cluster is either in a ready state or in an error state. The waiter has a timeout of 60 minutes. (default: true)"
}

variable "etcd_encryption" {
  type        = bool
  default     = null
  description = "Add etcd encryption. By default etcd data is encrypted at rest. This option configures etcd encryption on top of existing storage encryption."
}

variable "disable_waiting_in_destroy" {
  type        = bool
  default     = null
  description = "Disable addressing cluster state in the destroy resource. Default value is false, and so a `destroy` will wait for the cluster to be deleted."
}

variable "destroy_timeout" {
  type        = number
  default     = null
  description = "Maximum duration in minutes to allow for destroying resources. (Default: 60 minutes)"
}

variable "upgrade_acknowledgements_for" {
  type        = bool
  default     = null
  description = "Indicates acknowledgement of agreements required to upgrade the cluster version between minor versions (e.g. a value of \"4.12\" indicates acknowledgement of any agreements required to upgrade to OpenShift 4.12.z from 4.11 or before)."
}


##############################################################
# Default Machine Pool Variables
# These attributes are specifically applies for the default Machine Pool and becomes irrelevant once the resource is created.
# Any modifications to the default Machine Pool should be made through the Terraform imported Machine Pool resource.
##############################################################

variable "replicas" {
  type        = number
  default     = null
  description = "Number of worker nodes to provision. This attribute is applicable solely when autoscaling is disabled. Single zone clusters need at least 2 nodes, multizone clusters need at least 3 nodes. Hosted clusters require that the number of worker nodes be a multiple of the number of private subnets. (default: 2)"
}
variable "compute_machine_type" {
  type        = string
  default     = null
  description = "Identifies the Instance type used by the default worker machine pool e.g. `m5.xlarge`. Use the `rhcs_machine_types` data source to find the possible values."
}

variable "aws_availability_zones" {
  type        = list(string)
  default     = []
  description = "The AWS availability zones where instances of the default worker machine pool are deployed. Leave empty for the installer to pick availability zones"
}

##############################################################
# Autoscaler resource variables
##############################################################

variable "autoscaler_max_pod_grace_period" {
  type        = number
  default     = null
  description = "Gives pods graceful termination time before scaling down."
}

variable "autoscaler_pod_priority_threshold" {
  type        = number
  default     = null
  description = "To allow users to schedule 'best-effort' pods, which shouldn't trigger Cluster Autoscaler actions, but only run when there are spare resources available."
}

variable "autoscaler_max_node_provision_time" {
  type        = string
  default     = null
  description = "Maximum time cluster-autoscaler waits for node to be provisioned."
}

variable "autoscaler_max_nodes_total" {
  type        = number
  default     = null
  description = "Maximum number of nodes in all node groups. Cluster autoscaler will not grow the cluster beyond this number."
}

##############################################################
# default_ingress resource variables
##############################################################

variable "default_ingress_id" {
  type        = string
  default     = null
  description = "Unique identifier of the ingress."
}

variable "default_ingress_listening_method" {
  type        = string
  default     = ""
  description = "Listening Method for ingress. Options are [\"internal\", \"external\"]. Default is \"external\"."
}
##############################################################
# General variables
# Relevant to "account roles", "operator roles" and "OIDC"
##############################################################

variable "path" {
  type        = string
  default     = "/"
  description = "The arn path for the account/operator roles as well as their policies."
}

variable "permissions_boundary" {
  type        = string
  default     = ""
  description = "The ARN of the policy that is used to set the permissions boundary for the IAM roles in STS clusters."
}

##############################################################
# Account Roles
##############################################################

variable "create_account_roles" {
  type        = bool
  default     = false
  description = "Create the aws account roles for rosa"
}

variable "account_role_prefix" {
  type        = string
  default     = null
  description = "User-defined prefix for all generated AWS resources (default \"account-role-<random>\")"
}

##############################################################
# OIDC provider and config
##############################################################

variable "create_oidc" {
  description = "Create the oidc resources."
  type        = bool
  default     = false
}

variable "managed_oidc" {
  description = "OIDC type managed or unmanaged oidc"
  type        = bool
  default     = true
}

##############################################################
# Operator policies and roles
##############################################################

variable "create_operator_roles" {
  description = "Create the aws account roles for rosa"
  type        = bool
  default     = false
}

variable "operator_role_prefix" {
  type        = string
  default     = null
  description = "User-defined prefix for generated AWS operator policies. Use \"account-role-prefix\" in case no value provided."
}

variable "oidc_endpoint_url" {
  type        = string
  default     = null
  description = "Registered OIDC configuration issuer URL, added as the trusted relationship to the operator roles. Valid only when create_oidc is false."
}

variable "machine_pools" {
  type        = map(any)
  default     = {}
  description = "Provides a generic approach to add multiple machine pools after the creation of the cluster. This variable allows users to specify configurations for multiple machine pools in a flexible and customizable manner, facilitating the management of resources post-cluster deployment. For additional details regarding the variables utilized, please refer to the [machine-pool sub-module](./modules/machine-pool). For non-primitive variables (such as maps, lists, and objects), please supply the JSON-encoded string."
}

variable "identity_providers" {
  type        = map(any)
  default     = {}
  description = "Provides a generic approach to add multiple identity providers after the creation of the cluster. This variable allows users to specify configurations for multiple identity providers in a flexible and customizable manner, facilitating the management of resources post-cluster deployment. For additional details regarding the variables utilized, please refer to the [idp sub-module](./modules/idp). For non-primitive variables (such as maps, lists, and objects), please supply the JSON-encoded string."
}

################################
# cluster seed
################################

variable "seed" {
  type        = map(string)
  description = "Create a secret for the admin password, generate and store secret, and deploy a helm chart to cluster."
  default = {
  }
}

variable "hack_subnet_id_machine_pool" {
  type        = string
  description = "hack so i dont need to code in values file a subnet id every time when it always changes."
  default     = ""
}