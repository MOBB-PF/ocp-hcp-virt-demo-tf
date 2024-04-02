######################
# Log into your AWS account before running this make file. See helpers section for make statements.
# Create .env file with your ROSA and helm repo token (if using seed.). This file will be ignored by git.
# format.
# TF_VAR_helm_token=<Helm Repository TOKEN>
# TF_VAR_RHCS_TOKEN=<ROSA TOKEN>

include .env
export $(shell sed '/^\#/d; s/=.*//' .env)
TF_VAR_AWS_DEFAULT_REGION := $(shell aws configure get region)
TF_VAR_RHCS_TOKEN=$RHCS_TOKEN
DATE=$(shell date)
######################
# State variables. Set your state variables for your bucket and which cluster you are deploying to.
# TF_LOG                        # debug level
# WORKSPACE                     # path within state file directory.
# TF_BACKEND_BUCKET             # S3 bucket name.
# TF_BACKEND_DYNAMO=            # dynamo lock shouldnt need to change.
# TF_BACKEND_KEY=               # path within state file directory.
# VARS                          # vars file of the cluster you want to build.

TF_LOG=INFO
WORKSPACE=nonprod-dev
# TF_BACKEND_BUCKET=terraform-state-foster-ocm-nonprod
# TF_BACKEND_DYNAMO=terraform-lock
# TF_BACKEND_KEY=cluster1-nonprod
VARS=clusters/cluster1-nonprod-public.tfvars.json
# TF_BACKEND_KEY=cluster2-nonprod
# VARS=clusters/cluster2-nonprod-public.tfvars.json
# TF_BACKEND_KEY=cluster3-nonprod
# VARS=clusters/cluster3-nonprod-public.tfvars.json
######################
.EXPORT_ALL_VARIABLES:

# Run make init \ make plan \ make apply \ make destroy

init:
	terraform init -input=false -lock=false -no-color -reconfigure
	echo "Selecting Terraform workspace $(WORKSPACE)"
	terraform workspace new $(WORKSPACE) 2>/dev/null || true
	terraform workspace "select" $(WORKSPACE)
.PHONY: init

plan: format validate
	terraform plan -lock=false -var-file=$(VARS) -out=.terraform-plan
.PHONY: plan

apply:
	rm output.log
	echo "#########################################" >> output.log 2>&1
	echo "# TF START $(DATE)" >> output.log 2>&1	 
	echo "#########################################" >> output.log 2>&1
	terraform apply .terraform-plan
.PHONY: apply

destroy:
	terraform destroy -auto-approve -input=false  -var-file=$(VARS)
.PHONY: destroy

output:
	terraform output > tf-output-parameters
.PHONY: output

format:
	terraform fmt -check

validate:
	terraform validate

## Helpers

disply-metal:
	rosa list instance-types --region=TF_VAR_AWS_DEFAULT_REGION | grep "metal"

display-accelerated:
	rosa list instance-types --region=TF_VAR_AWS_DEFAULT_REGION | grep "accelerated"