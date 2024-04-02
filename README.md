# ROSA Cluster deployment

Deploying a Red Hat Openshift services on AWS (ROSA) cluster is a fairly straightforward process, by following the [official documentation](https://docs.openshift.com/rosa/rosa_install_access_delete_clusters/rosa-sts-creating-a-cluster-quickly.html), creating the required AWS networking infrastructure, and running the deployment command, a highly available OpenShift cluster will become available and ready to run containerised workloads in approximately 40-50 minutes.

This repo aims to provide an enterprise grade multi cluster pipeline wrapped around the [official RHCS Terraform Module](https://registry.terraform.io/providers/terraform-redhat/rhcs/latest). 

# ROSA Pre-requisites

## Make a copy of this repo on Github

Make a copy of this repo to your Github account, ensure that it is a private repo, this wil prevent accidental leaking of secrets and avoid anyone from the public running the Github actions workflow.

## Terraform state bucket

This pipeline relies on a perminant S3 state bucket being created within AWS, the AWS credentials used in the piepline must have access to both the state bucket and the target account of the ROSA cluster.

An example of creating an S3 bucket for a state file can be found here.

https://github.com/MOBB-PF/terraform-state-create-tf

Once the state bucket setup is complete update the following variables in the .gitihub/workflows/cluster*-nonprod-*private*.yaml and .gitihub/workflows/cluster*-nonprod-*.yaml files. Or if you are running locally outside of a pipeline update within the Maekfile.

| Component Name | Description |
| --- | --- | 
|TF_BACKEND_BUCKET| \<AWS S3 Bucket Name\> |

## Terraform runtime container.

In this pipeline we are using a custom container that includes terraform, helm, rosa, and the oc binary. An example of how the container is built is in the following directory.

https://github.com/MOBB-PF/terraform-aws-rosa-helm-image

If you wish to not only terraform the cluster but perform some day 2 operations such as described in the section "Cluster seeding", you will eather need to build this container and store it in a repository that you own or do some kind of equivilence. What ever container you are going to use even if its just a standard terraform container out of docker hub, you must update the .gitihub/workflows/cluster*-nonprod-*.yaml files on line 35 to reference your container that you have access to.

If you are running the terraform via Makefile - you need to make sure these binaries are installed on your system.

## Review the official ROSA prerequisits.

There are minimum requiments for an AWS account to be able to host a ROSA cluster. Please review the official documentation below and confirm your account meets the requirments.

[Review and confirm the offical pre-requists are met with in the ROSA documentation for your AWS account.](https://docs.openshift.com/rosa/rosa_planning/rosa-sts-aws-prereqs.html)

### Enable the ROSA service.

[Follw the official documentation to enable the ROSA service on the account you wish to deploy ROSA to.](https://docs.openshift.com/rosa/rosa_planning/rosa-sts-setting-up-environment.html)

## Networking.

A networking module has been added to this repository for completeness. It would be expected that in the real world networking would be IAC'd in another seperate repository.

To use the in built sub module to create the network along with the cluster set the following variables.

```create_vpc = true```
```vpc_name```
```vpc_cidr```
```vpc_private_subnets```
```vpc_public_subnets```

If you are BYO'ing your VPC set the following variables instead.

```create_vpc = false```
```vpc_cidr_block```
```vpc_private_subnets_ids```
```vpc_public_subnets_ids```

Please note public sts private link clusters require both private and public subnets where as private clusters only require private subnets.

## Download the Red Hat token

A Red Hat account is required to retrieve the ROSA token which is required to provision ROSA clusters. Visit https://console.redhat.com/, Log in, click "Services", click "Containers", click "Clusters", click "Downloads", bottom of the page click on "View API token", click "Load Token" and copy your token in preparation for creating a github secret.

## Secrets

> **Warnings** 
> Please be careful about how you store secrets. It is advised to use a private repo to ensure that there is a less chance of private data exposure.

### AWS Access

In this example pipeline we are hard coding AWS access ID and secret as github secrets for AWS access. In the real world it would be recommended to use STS integrated runners for what ever pipeline CI technology you are using and manage AWS access via STS web identity roles direct to your target AWS account.

If you are running locally follow the instructions within the Makefile for how the red hat token and aws credentials\region are managed.

### Create the Github Repository Secrets and Variables

| Secret Name | Description |
| --- | --- | 
|AWS_SECRET_ACCESS_KEY_NONPROD|The AWS access key secret for your user\role\account|
|AWS_ACCESS_KEY_ID_NONPROD|The AWS access key ID for your user\role\account|
|REDHAT_API_TOKEN|output from pre-requisit step "Download Red Hat token"|
|HELM_TOKEN|Optional: If you wish to automate the deployment of a helm chart to your cluster provide the token of your repository here. See section on cluster seeding below.|
|CONTAINER_REGISTRY_TOKEN||

# Triggering a build of a cluster

Once all pre-requisits have been met including creation of terraform state bucket and github action secret creation. To trigger a cluster build simply create a development branch, take a feature branch from development and touch (edit and add a blank new line) the terraform\clusters\*tfvars.json file of the cluster you want to create, commit\push your changes and complete the following steps.

* For a plan - Create a merge request from your feature branch to the development branch. 

* For an apply - Merge your feature request into the development branch.

A production branch should be used for production clusters (development should be merged into production branch for prod cluster plan\applys.)

## Example clusters

Two example clusters have been templated and can be run as is with out any modifications. One is for a private cluster and the other a public cluster. Both clusters will trigger a build on a merge into the development branch.

* cluster1-nonprod-private.yaml
  * cluster1-nonprod-private.tfvars.json

* cluster2-nonprod-public.yaml
  * cluster2-nonprod-public.tfvars.json

# Adding a new cluster to the pipeline

To add a new cluster you simply need to create a pair of files, one for the Github Action CI steps and another for the terraform json payload.

## Clone and update one of the example cluster CI files

Clone the CI file (.gitihub/workflows/cluster1-nonprod-private.yaml) from an existing cluster and update the following variables.

### Update the Github Action CI steps

Update the CI steps in the new file to reflect the following changes.

| Component Name | Description |
| --- | --- | 
|on: push: branches: | The name of the branch that the terraform will trigger on for terraform apply |
|on: push: paths: |  The name of the json payload file pair that will you will touch to trigger a run. | | 
|on: pull_request: branches: | The name of the branch that the terraform will trigger on for terraform plan | 
|on: pull_request: paths:| The name of the json payload file pair that will you will touch to trigger a run | 

### Update the Github Action Variables

| Variable Name | Description |
| --- | --- | 
| WORKSPACE | A unique name for the state workspace of the tf run example <nonprod\prod> |
| TF_BACKEND_KEY| A unique name for the state key of the tf run example <cluster name> |
| VARS| The name of the json payload file pair that will hold the cluster config. |
| AWS_DEFAULT_REGION | The region where you want to deploy your cluster |
| TF_VAR_AWS_DEFAULT_REGION | The region where you want to deploy your cluster |

## Clone and update one of the example cluster terraform json files

Clone the json payload for the cluster from an example file under terraform/clusters/*tfvars.json

Use the variables.tf file or [official documentation](https://docs.openshift.com/rosa/rosa_install_access_delete_clusters/) to understand all the variables being passed to the terraform resources.

### Machine pools 

Machine pools for the clusters on ROSA is managed in OCM via terraform and not the OCP GUI. Any number of machine pools can be added per cluster by creating an array of objects in the json payload. [Use the official terraform documentation exaples for all attributes that can be applied to a machine pool through terraform.](https://github.com/terraform-redhat/terraform-provider-rhcs/blob/main/examples/create_machine_pool/main.tf)

#### example 
```
    "machine_pools": {
        "1": {
            "name": "testpool",
            "machine_type": "r5.xlarge",
            "replicas": 1
        }
        "2": {
            
        }
    },
```

### Identity providers

IDP's for the clusters on ROSA in OCM via terraform and not the yaml applied directly to the clusters. Any number of identity providers can be added per cluster by creating an array of objects in the json payload. [Use the official terraform documentation for example configurations of each type of provider.](https://github.com/terraform-redhat/terraform-provider-rhcs/tree/main/examples/create_identity_provider)

#### example 
```
    "idp": {
        "1": {
            ldap = {
               url: <ldap_url>
               attributes: {}
               ca: <ldap_ca>
               insecure = false
            }       
        },
        "2": {

        }
    },
```

# Cluster seeding

You can optionally seed a cluster with a helm chart by setting "seed.deploy.true" in your json payload to true in the json payload and providing the helm variables below. By setting seed to true you will also generate and store the cluster admin credentials in an AWS secret for retrieval at a later date. Look at secrets.tf and scripts/seed_rosa_cluster.sh for further details.

You must have set up the HELM_TOKEN Github secret to seed the cluster

| Variable object seed | Description |
| --- | --- | 
|deploy| - set to "true" to create secret and deploy a helm chart to cluster.|
|helm_repo|The repo URL for the helm repository.|
|helm_chart|The chart name |
|helm_chart_version|The revision of the helm chart you with to deploy.|

Cluster seeding is only enabled in the public cluster example. To connect to and seed a private cluster the CI runner would need direct access to the cluster once provisioned - this example pipeline does not account for this.

```
    "seed": {
      "deploy": "true",
      "helm_repo": "https://mobb-pf.github.io/helm-repository/",
      "helm_chart": "cluster-seed",
      "helm_chart_version": "1.0.3"
    },
```
## Example seed helm chart.

[example helm chart](https://github.com/MOBB-PF/helm-repository/tree/main/charts/cluster-seed)

This helm chart uses helm pre and post hooks with a kubernetes job in the middle to validate that all operators have installed correctly and that any other pods etc are running before deploying any custom resources that may require operators running or crd's deployed first.

# Onboarding customers to the cluster

Optionally many object can be applied to the json payload under "customers" to set up application teams on the cluster using an opinionated gitops approach. By following this approach to adding customers to the cluster within the cluster creation terraform we provide DR capability and devops best practices. An example and more info on how this opinionated gitops approach works is detailed in the readme within the gitops repository [to be completed]

[An example helm chart to initialise an argocd application for a customer.](https://github.com/MOBB-PF/helm-repository/tree/main/charts/customer-onboarding)

Below is a configuration example of using that helm chart in the json payload of for the public cluster.

```
    "customer_chart": {
        "helm_repo": "https://mobb-pf.github.io/helm-repository/",
        "helm_chart": "customer-onboarding",
        "helm_chart_version": "1.0.0"
    },
```
[An example gitops repository for a customer.](https://github.com/MOBB-PF/payments-gitops)

This repository will use helm forloops to deliver a payload of argocd applications to deliver helm charts based on the config in this repo to the cluster for the customer.

An example single customer is configured below and also in the example public cluster of the repository. Here we pass the customers base gitiops repository and name to initalisation helm chart defined in the json payload under customer_chart.

```
    "customers": {
        "1": {
            "name": "payments",
            "git_repository": "https://github.com/MOBB-PF/payments-gitops"
        }  
    },
```

The actual argocd payload points at several other helm charts. In our example it builds the namespace for the customer and gives them the option to deploy helm charts with out knowing argocd and also microservices, again without configuring argocd applications.

[Example argocd payload helm chart](https://github.com/MOBB-PF/helm-repository/tree/main/charts/argocd-payload)

# Destroying a cluster

By setting the state file workspace and key in the CI variables each cluster has its own state file for all resources created in the pipeline. 

In each CI *.github/workflows/* yaml file. The following commented out CI step code and all resources associated with cluster will be destroyed on the creation of a pull request against the branch this cluster was created on.

```
      # - name: Terraform Destroy
      #   id: destroy
      #   run: |
      #     terraform destroy  -auto-approve -input=false  -var-file=$VARS
      #     exit 0

```
