terraform {
  required_version = ">= 1.0"

  required_providers {
    rhcs = {
      version = "= 1.6.0-prerelease.3"
      source  = "terraform-redhat/rhcs"
    }
  }
}
