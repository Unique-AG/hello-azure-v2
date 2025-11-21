terraform {
  required_version = ">= 1.0"
  
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

variable "environments" {
  description = "Map of environment configurations"
  type = map(object({
    name                 = string
    subscription_id      = string
    storage_account_name = string
    container_name       = string
    key                  = string
    resource_group_name  = string
    tenant_id            = string
    client_id            = string
    name_prefix          = string
    environment          = string
    dns_zone_name        = string
  }))
}

locals {
  environments = var.environments
}

# Generate 00-config.auto.tfvars for each environment
resource "local_file" "config_tfvars" {
  for_each = local.environments

  filename = "generated/${each.key}/00-config.auto.tfvars"
  content  = templatefile("${path.module}/templates/00-config.auto.tfvars.tftmpl", {
    environment = each.value
  })
}

# Generate 00-environment.auto.tfvars for each environment
resource "local_file" "environment_tfvars" {
  for_each = local.environments

  filename = "generated/${each.key}/00-environment.auto.tfvars"
  content  = templatefile("${path.module}/templates/00-environment.auto.tfvars.tftmpl", {
    environment = each.value
  })
}

# Generate 90-backend.tf for each environment
resource "local_file" "backend_tf" {
  for_each = local.environments

  filename = "generated/${each.key}/90-backend.tf"
  content  = templatefile("${path.module}/templates/90-backend.tf.tftmpl", {
    environment = each.value
  })
}

# Generate 91-providers.tf for each environment
resource "local_file" "providers_tf" {
  for_each = local.environments

  filename = "generated/${each.key}/91-providers.tf"
  content  = templatefile("${path.module}/templates/91-providers.tf.tftmpl", {
    environment = each.value
  })
}

# Generate 92-versions.tf for each environment
resource "local_file" "versions_tf" {
  for_each = local.environments

  filename = "generated/${each.key}/92-versions.tf"
  content  = templatefile("${path.module}/templates/92-versions.tf.tftmpl", {
    environment = each.value
  })
}

# Generate import-resources.sh for each environment
resource "local_file" "import_resources_sh" {
  for_each = local.environments

  filename             = "generated/${each.key}/import-resources.sh"
  content              = templatefile("${path.module}/templates/import-resources.sh.tftmpl", {
    environment = each.value
  })
  file_permission      = "0755"
}

